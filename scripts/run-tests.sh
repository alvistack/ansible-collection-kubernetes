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
export ANSIBLE_ROLES_PATH="roles:../roles:~/.ansible/roles:/etc/ansible/roles"

LXC_IMAGE=${LXC_IMAGE:-"ubuntu:16.04"}
LXC_ID=${LXC_ID:-"$(cat /dev/urandom | tr -dc a-z | head -c1)$(cat /dev/urandom | tr -dc a-z0-9 | head -c11)"}
lxc restart $LXC_ID || lxc launch $LXC_IMAGE $LXC_ID -c security.nesting=true -c security.privileged=true

yamllint -c .yamllint playbooks/*.yml tests/*.yml
ansible-lint -r $HOME/.ansible/galaxy-lint-rules/rules playbooks/roles
ansible-playbook -i $LXC_ID, -c lxd tests/test.yml --syntax-check
ansible-playbook -i $LXC_ID, -c lxd tests/test.yml --diff
ansible-playbook -i $LXC_ID, -c lxd tests/test.yml --diff
tail -n 1 $ANSIBLE_LOG_PATH | grep -Eq 'changed=0 +unreachable=0 +failed=0'
