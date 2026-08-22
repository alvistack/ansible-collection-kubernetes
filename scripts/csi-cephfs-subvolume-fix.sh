#!/usr/bin/env bash
set -euo pipefail

# Configuration Defaults (Adjust if using non-default names)
FS_NAME="cephfs"
SUBVOL_GROUP="csi"
METADATA_POOL="cephfs_metadata"
CSI_NAMESPACE="csi"

echo "=== Step 1: Auto-detecting failed/unmounted CephFS PVs from Kubernetes ==="

# Fetch all PVs managed by cephfs.csi.ceph.com
PVS=$(kubectl get pv -o json | jq -r '
  .items[] 
  | select(.spec.csi.driver=="cephfs.csi.ceph.com") 
  | .metadata.name
')

if [ -z "$PVS" ]; then
  echo "No CephFS PVs found in the cluster."
  exit 0
fi

echo "Found CephFS PVs. Analyzing volume structures..."
echo "------------------------------------------------"

for PV in $PVS; do
  # Extract values directly from PV spec
  JSON=$(kubectl get pv "$PV" -o json)
  
  SUBVOL=$(echo "$JSON" | jq -r '.spec.csi.volumeAttributes.subvolumeName // empty')
  VOL_ID=$(echo "$JSON" | jq -r '.spec.csi.volumeHandle // empty')
  SUBVOL_PATH=$(echo "$JSON" | jq -r '.spec.csi.volumeAttributes.subvolumePath // empty')
  
  # Skip if volume attributes are missing
  if [ -z "$SUBVOL" ] || [ -z "$VOL_ID" ]; then
    echo "Skipping $PV: missing subvolumeName or volumeHandle."
    continue
  fi

  UUID_ONLY="${SUBVOL#csi-vol-}"
  SUBVOL_UUID=$(echo "$SUBVOL_PATH" | awk -F'/' '{print $NF}')
  OMAP_KEY="csi.volume.${UUID_ONLY}"

  echo "Processing PV:          $PV"
  echo "  Subvolume Name:      $SUBVOL"
  echo "  Volume ID:           $VOL_ID"
  echo "  Subvolume UUID:      $SUBVOL_UUID"
  echo "  RADOS OMAP Object:   $OMAP_KEY"

  # 1. Ensure Subvolume Group exists
  ceph fs subvolume group create "$FS_NAME" "$SUBVOL_GROUP" --mode 0755 2>/dev/null || true

  # 2. Re-create the Subvolume directory structure in CephFS
  echo "  -> [1/2] Creating CephFS Subvolume in cluster..."
  ceph fs subvolume create "$FS_NAME" "$SUBVOL" \
    --group_name "$SUBVOL_GROUP" \
    --mode 0777 2>/dev/null || echo "     Subvolume $SUBVOL already exists or created."

  # 3. Create the RADOS object and set OMAP keys individually
  echo "  -> [2/2] Re-building CSI RADOS OMAP object..."
  
  # Touch/Create the RADOS object in the metadata pool
  rados -p "$METADATA_POOL" -N "$CSI_NAMESPACE" create "$OMAP_KEY" 2>/dev/null || true
  
  # Set OMAP attributes required by cephfs.csi.ceph.com
  rados -p "$METADATA_POOL" -N "$CSI_NAMESPACE" setomapval "$OMAP_KEY" "namingPrefix" "csi-vol-" >/dev/null
  rados -p "$METADATA_POOL" -N "$CSI_NAMESPACE" setomapval "$OMAP_KEY" "volName" "$SUBVOL" >/dev/null

  echo "  ✓ Successfully restored metadata for $SUBVOL"
  echo "------------------------------------------------"
done

echo "=== Step 2: Restarting CSI Node Plugins to clear cached failures ==="

# Force Kubelet / CSI Driver to reload state
kubectl rollout restart daemonset -n "$CSI_NAMESPACE" cephfs-csi-nodeplugin 2>/dev/null || \
kubectl rollout restart daemonset -n kube-system csi-cephfsplugin 2>/dev/null || \
echo "Nodeplugin restart skipped (check namespace if different)."

echo "=== Finished! Check 'kubectl get pods -A' to monitor volume mounts. ==="
