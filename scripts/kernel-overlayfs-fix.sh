#!/bin/bash

set -euxo pipefail

# 1. Stop container services
systemctl stop crio kubelet podman || true

# 2. Unmount all active fuse-overlayfs mounts (|| true prevents exit if grep finds 0 mounts)
cut -d ' ' -f 2 /proc/mounts | grep '/var/lib/containers/storage/overlay' | xargs -r umount -l || true

# 3. Terminate lingering fuse processes
pkill -9 fuse-overlayfs || true

# 4. Wipe legacy storage metadata and layer caches
rm -rf /var/lib/containers/storage/overlay*
rm -rf /var/lib/containers/storage/containers.lock
rm -rf /var/lib/containers/storage/overlay-containers
rm -rf /var/lib/containers/storage/overlay-images

# 5. Restart container runtime
systemctl start crio kubelet

# 6. Verify native kernel mounts and zero fuse processes
echo "=== Active fuse-overlayfs processes (should be empty) ==="
ps aux | grep [f]use-overlayfs || true

echo "=== System Overlay Mounts (should show type 'overlay') ==="
mount | grep "type overlay" | head -n 3 || true
