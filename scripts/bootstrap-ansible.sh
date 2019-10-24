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
    apt-get -y install ca-certificates curl gcc git libffi-dev libssl-dev make python3 python3-dev sudo
fi

# Prepare YUM dependencies
if [ -x "$(command -v yum)" ]; then
    yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    yum -y install https://centos7.iuscommunity.org/ius-release.rpm
    yum -y install ca-certificates curl gcc git2u libffi-devel make openssl-devel python3 python3-devel redhat-rpm-config sudo
fi

# Prepare Zypper dependencies
if [ -x "$(command -v zypper)" ]; then
    zypper -n --gpg-auto-import-keys refresh
    zypper -n install -y ca-certificates* curl gcc git libffi-devel libopenssl-devel make python3 python3-devel python3-xml sudo
fi

# Install PIP
curl -skL https://bootstrap.pypa.io/get-pip.py | python3

# Install PIP dependencies
pip3 install --upgrade --ignore-installed  --requirement requirements.txt
