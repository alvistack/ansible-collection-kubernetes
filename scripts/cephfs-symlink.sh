#!/bin/bash

# (c) Wong Hoi Sing Edison <hswong3i@pantarei-design.com>
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

set -o xtrace

kubectl get pv -o name | while read line
do
    namespace="$(kubectl get $line -o jsonpath='{.spec.claimRef.namespace}')"
    name="$(kubectl get $line -o jsonpath='{.spec.claimRef.name}')"
    path="volumes/csi/csi-vol-$(kubectl get $line -o jsonpath='{.spec.csi.volumeHandle}' | sed 's/^0001-0004-ceph-0000000000000001-//g')"

    if [[ -f $path/.meta ]]
    then
        path="$(cat $path/.meta | egrep -e '^path = ' | sed 's/^path = \///g')"
    fi

    mkdir -p symlinks/$namespace
    cd symlinks/$namespace
    rm $name
    ln -fs ../../$path $name
    cd ../../
done
