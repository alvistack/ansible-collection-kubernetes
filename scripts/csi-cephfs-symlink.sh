#!/bin/bash

# Copyright 2024 Wong Hoi Sing Edison <hswong3i@pantarei-design.com>
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

kubectl get pv --output=name | while read line
do
    _namespace="$(kubectl get $line --output=jsonpath='{.spec.claimRef.namespace}')"
    _name="$(kubectl get $line --output=jsonpath='{.spec.claimRef.name}')"
    _status="$(kubectl get $line --output=jsonpath='{.status.phase}')"
    _path="volumes/csi/csi-vol-$(kubectl get $line --output=jsonpath='{.spec.csi.volumeHandle}' | sed 's/^0001-0004-ceph-0000000000000001-//g')"

    if [[ -f $_path/.meta ]]
    then
        _path="$(cat $_path/.meta | egrep -e '^path = ' | sed 's/^path = \///g')"
    fi

    if [[ "$_status" == "Bound" ]]
    then
        mkdir -p symlinks/$_namespace
        cd symlinks/$_namespace
        rm -rf $_name
        ln -fs ../../$_path $_name
        cd ../../
    fi
done
