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

# Prepare APT dependencies
if [ -x "$(command -v apt-get)" ]; then
    apt-get update
    apt-get -y install build-essential curl git libffi-dev libssl-dev python-dev python-minimal
    apt-get -y purge python-pip
    apt-get -y autoremove
fi

# Prepare YUM dependencies
if [ -x "$(command -v yum)" ]; then
    yum -y install epel-release
    yum -y install curl gcc git libffi-devel openssl-devel python python python-devel python-urllib3 redhat-rpm-config
    yum -y remove python-pip
    yum -y autoremove
fi

# Install PIP
curl -skL https://bootstrap.pypa.io/get-pip.py | python

# Install PIP dependencies
pip install --upgrade -r requirements.txt
