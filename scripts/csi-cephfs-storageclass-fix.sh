#!/bin/bash

set -euxo pipefail

# 1. Fetch all PVs associated with the csi-cephfs StorageClass
CEPHFS_PVS=$(kubectl get pv -o jsonpath='{range .items[?(@.spec.storageClassName=="csi-cephfs")]}{.metadata.name}{"\n"}{end}' || true)

if [ -z "${CEPHFS_PVS}" ]; then
  echo "No PVs found for StorageClass csi-cephfs."
  exit 0
fi

# 2. Patch each PV directly with the optimized mount options
echo "=== Patching spec.mountOptions on CephFS PVs ==="
echo "${CEPHFS_PVS}" | xargs -I {} kubectl patch pv {} --type=merge -p '{"spec":{"mountOptions":["noatime","rsize=16777216","wsize=16777216","readdir_max_bytes=4194304"]}}'

# 3. Verify that spec.mountOptions is applied to the PV manifests
echo "=== Verifying updated PV specifications ==="
kubectl get pv -o custom-columns=NAME:.metadata.name,CLASS:.spec.storageClassName,MOUNT_OPTIONS:.spec.mountOptions

# 4. Lazy-unmount lingering CSI mounts on host so next pod attach forces a fresh NodeStage RPC
echo "=== Flushing stale host-level CephFS globalmounts ==="
cut -d ' ' -f 2 /proc/mounts | grep 'kubernetes.io/csi/cephfs.csi.ceph.com' | xargs -r umount -l || true

# 5. Verify live kernel mounts with new options
echo "=== Checking host mounts for updated parameters (should show noatime/rsize) ==="
mount | grep "type ceph" | grep -E 'noatime|rsize' || echo "Note: Active workloads must be restarted to attach with updated options."
