#!/bin/bash

set -euxo pipefail

# 1. Fetch all PVs associated with the csi-rbd StorageClass
RBD_PVS=$(kubectl get pv -o jsonpath='{range .items[?(@.spec.storageClassName=="csi-rbd")]}{.metadata.name}{"\n"}{end}' || true)

if [ -z "${RBD_PVS}" ]; then
  echo "No PVs found for StorageClass csi-rbd."
  exit 0
fi

# 2. Patch each RBD PV directly with the optimized block mount options
echo "=== Patching spec.mountOptions on Ceph RBD PVs ==="
echo "${RBD_PVS}" | xargs -I {} kubectl patch pv {} --type=merge -p '{"spec":{"mountOptions":["noatime","nodiratime","discard","barrier=0","commit=60"]}}'

# 3. Verify that spec.mountOptions is applied to the PV manifests
echo "=== Verifying updated RBD PV specifications ==="
kubectl get pv -o custom-columns=NAME:.metadata.name,CLASS:.spec.storageClassName,MOUNT_OPTIONS:.spec.mountOptions

# 4. Lazy-unmount lingering host-level CSI RBD globalmounts
echo "=== Flushing stale host-level Ceph RBD globalmounts ==="
cut -d ' ' -f 2 /proc/mounts | grep 'kubernetes.io/csi/rbd.csi.ceph.com' | xargs -r umount -l || true

# 5. Verify live kernel mounts for updated parameters
echo "=== Checking host mounts for updated RBD block parameters ==="
mount | grep -E 'rbd|ext4|xfs' | grep -E 'noatime|barrier=0|commit=60' || echo "Note: Active workloads using RBD volumes must be restarted to attach with updated options."
