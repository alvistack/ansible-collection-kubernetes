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

cd "$(cd "$(dirname "$0")"; pwd -P)/../"

export ANSIBLE_FORCE_COLOR=true
export ANSIBLE_LOG_PATH="./ansible.log"
export ANSIBLE_ROLES_PATH="~/.ansible/roles"

DOCKER_IMAGE=${DOCKER_IMAGE:-"hello-world"}
docker pull $DOCKER_IMAGE

DOCKER_ID=${DOCKER_ID:-"$(docker run -itd --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /sys/fs/cgroup:/sys/fs/cgroup:ro --tmpfs /run --tmpfs /run/lock $DOCKER_IMAGE | head -c12)"}
docker start $DOCKER_ID

yamllint -c .yamllint playbooks tests
ansible-playbook -i $DOCKER_ID, -c docker tests/test.yml --syntax-check
ansible-playbook -i $DOCKER_ID, -c docker tests/test.yml --diff
ansible-playbook -i $DOCKER_ID, -c docker tests/test.yml --diff
tail -n 1 $ANSIBLE_LOG_PATH | grep -Eq 'changed=0 +unreachable=0 +failed=0'
