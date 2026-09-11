#!/bin/bash

set -euxo pipefail

# 1. Audit /etc configuration files for active (uncommented) fuse-overlayfs lines
echo "=== Auditing /etc/ configuration files for uncommented fuse-overlayfs references ==="
UNCOMMENTED_FUSE=$(find /etc/ -type f | xargs fgrep -nH "fuse-overlayfs" | grep -v -E ':[0-9]+:\s*#' || true)

if [ -n "${UNCOMMENTED_FUSE}" ]; then
  echo "ERROR: Active (uncommented) fuse-overlayfs directive found in /etc/ configuration files:"
  echo "${UNCOMMENTED_FUSE}"
  exit 1
fi
echo "Audit passed: All fuse-overlayfs directives in /etc are safely commented out."

# 2. Stop container services
systemctl stop crio kubelet podman || true

# 3. Unmount all active fuse-overlayfs mounts
cut -d ' ' -f 2 /proc/mounts | grep '/var/lib/containers/storage/overlay' | xargs -r umount -l || true

# 4. Terminate lingering fuse processes
pkill -9 fuse-overlayfs || true

# 5. Wipe legacy storage metadata and layer caches
rm -rf /var/lib/containers/storage/overlay*
rm -rf /var/lib/containers/storage/containers.lock
rm -rf /var/lib/containers/storage/overlay-containers
rm -rf /var/lib/containers/storage/overlay-images

# 6. Restart container runtime
systemctl start crio kubelet

# 7. Verify native kernel mounts and zero fuse processes
echo "=== Active fuse-overlayfs processes (should be empty) ==="
ps aux | grep [f]use-overlayfs || true

echo "=== System Overlay Mounts (should show type 'overlay') ==="
mount | grep "type overlay" | head -n 3 || true
