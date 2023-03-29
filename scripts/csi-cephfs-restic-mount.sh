#!/bin/bash

# Copyright 2023 Wong Hoi Sing Edison <hswong3i@pantarei-design.com>
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

RESTIC_MOUNT_DIR=${RESTIC_MOUNT_DIR:-"/root/restores/restic/csi-cephfs"}

RESTIC_OPTS=${RESTIC_OPTS:-"--verbose"}
RESTIC_REPOSITORY=${RESTIC_REPOSITORY:-"/root/backups/restic/csi-cephfs"}
RESTIC_PASSWORD_FILE=${RESTIC_PASSWORD_FILE:-"/root/.ssh/id_rsa"}

exec 9>$PID_FILE
flock -n 9 || exit 1
renice 10 -p $$
echo $$ 1>&9

exec 1> >(tee -a $LOG_FILE) 2>&1

# RESTIC - mount
! mkdir -p $RESTIC_MOUNT_DIR
! umount $RESTIC_MOUNT_DIR
restic unlock \
    --repo $RESTIC_REPOSITORY \
    --password-file $RESTIC_PASSWORD_FILE \
    $RESTIC_OPTS
screen -dm restic mount \
    --repo $RESTIC_REPOSITORY \
    --password-file $RESTIC_PASSWORD_FILE \
    $RESTIC_OPTS $RESTIC_MOUNT_DIR
