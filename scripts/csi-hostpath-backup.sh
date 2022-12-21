#!/bin/bash

# Copyright 2022 Wong Hoi Sing Edison <hswong3i@pantarei-design.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euxo pipefail

PID_FILE="/var/run/${0##*/}.pid"
LOG_FILE="/var/log/${0##*/}.log"
TIMESTAMP=${TIMESTAMP:-$(date +%s)}

HOSTPATH_VG=${HOSTPATH_VG:-"kubernetes"}
HOSTPATH_LV=${HOSTPATH_LV:-"csi-hostpath"}
HOSTPATH_SNAPSHOT=${HOSTPATH_SNAPSHOT:-"$HOSTPATH_LV-$TIMESTAMP"}
HOSTPATH_SNAPSHOT_DIR=${HOSTPATH_SNAPSHOT_DIR:-$(mktemp -d)}

RESTIC_OPTS=${RESTIC_OPTS:-"--verbose"}
RESTIC_REPOSITORY=${RESTIC_REPOSITORY:-"/root/backups/restic/csi-hostpath"}
RESTIC_PASSWORD_FILE=${RESTIC_PASSWORD_FILE:-"/root/.ssh/id_rsa"}

RESTIC_KEEP_HOURLY=${RESTIC_KEEP_HOURLY:-"24"}
RESTIC_KEEP_DAILY=${RESTIC_KEEP_DAILY:-"7"}
RESTIC_KEEP_WEEKLY=${RESTIC_KEEP_WEEKLY:-"5"}
RESTIC_KEEP_MONTHLY=${RESTIC_KEEP_MONTHLY:-"12"}
RESTIC_KEEP_YEARLY=${RESTIC_KEEP_YEARLY:-"7"}

exec 9>$PID_FILE
flock -n 9 || exit 1
renice 10 -p $$
echo $$ 1>&9

exec 1> >(tee -a $LOG_FILE) 2>&1

# RESTIC - Init
mkdir -p $RESTIC_REPOSITORY
if [[ ! -f $RESTIC_REPOSITORY/config ]]; then
restic init \
    --repo $RESTIC_REPOSITORY \
    --password-file $RESTIC_PASSWORD_FILE \
    $RESTIC_OPTS
fi

# HOSTPATH - Snapshot
lvcreate \
    --snapshot \
    -pr \
    -L1M \
    $HOSTPATH_VG/$HOSTPATH_LV $HOSTPATH_SNAPSHOT
mkdir -p $HOSTPATH_SNAPSHOT_DIR
mount /dev/$HOSTPATH_VG/$HOSTPATH_SNAPSHOT $HOSTPATH_SNAPSHOT_DIR

# RESTIC - Backup
cd $HOSTPATH_SNAPSHOT_DIR
restic unlock \
    --repo $RESTIC_REPOSITORY \
    --password-file $RESTIC_PASSWORD_FILE \
    $RESTIC_OPTS
ionice -c2 nice -n19 restic backup . \
    --repo $RESTIC_REPOSITORY \
    --password-file $RESTIC_PASSWORD_FILE \
    $RESTIC_OPTS

# HOSTPATH - Cleanup
umount $HOSTPATH_SNAPSHOT_DIR
rmdir $HOSTPATH_SNAPSHOT_DIR
lvremove -y $HOSTPATH_VG/$HOSTPATH_SNAPSHOT

# RESTIC - Rotation
ionice -c2 nice -n19 restic forget \
    --prune \
    --group-by host \
    --keep-hourly $RESTIC_KEEP_HOURLY \
    --keep-daily $RESTIC_KEEP_DAILY \
    --keep-weekly $RESTIC_KEEP_WEEKLY \
    --keep-monthly $RESTIC_KEEP_MONTHLY \
    --keep-yearly $RESTIC_KEEP_YEARLY \
    --repo $RESTIC_REPOSITORY \
    --password-file $RESTIC_PASSWORD_FILE \
    $RESTIC_OPTS

# RESTIC - Snapshots
restic snapshots \
    --repo $RESTIC_REPOSITORY \
    --password-file $RESTIC_PASSWORD_FILE \
    $RESTIC_OPTS
