# Ansible Collection for Kubernetes

## YYYYMMDD.Y.Z - TBC

### Major Changes

-   Support Fedora 38
-   Remove Kubernetes 1.24 support

## 20230329.1.1 - 2023-03-29

### Major Changes

-   Support Ansible community package 7.4.0
-   Support Ubuntu 23.04
-   Support Kubernetes 1.27

## 20230301.1.1 - 2023-03-01

### Major Changes

-   Support Ansible community package 7.3.0

## 20230201.1.1 - 2023-02-01

### Major Changes

-   Support Ansible community package 7.2.0
-   Support Kubernetes 1.26
-   Remove Kubernetes 1.23 support

## 20221209.1.1 - 2022-12-09

### Major Changes

-   Support Ansible community package 7.1.0

## 20221126.1.1 - 2022-11-26

### Major Changes

-   Support Ansible community package 7.0.0

## 20221110.1.1 - 2022-11-10

### Major Changes

-   Support Ansible community package 6.6.0
-   Remove Fedora 35 support
-   Remove openSUSE Leap 15.3 support

## 20221014.1.1 - 2022-10-14

### Major Changes

-   Support Ansible community package 6.5.0
-   Support Ubuntu 22.10
-   Support Fedora 37

## 20220915.1.1 - 2022-09-15

### Major Changes

-   Support Ansible community package 6.4.0

## 20220824.1.1 - 2022-08-24

### Major Changes

-   Support Ansible community package 6.3.0

## 20220803.1.1 - 2022-08-03

### Major Changes

-   Support Ansible community package 6.2.0

## 20220714.1.1 - 2022-07-14

### Major Changes

-   Support Ansible community package 6.1.0
-   Remove Ubuntu 21.10 support

## 20220622.1.1 - 2022-06-22

### Major Changes

-   Support Ansible community package 6.0.0

## 20220608.1.1 - 2022-06-08

### Major Changes

-   Support Ansible community package 5.9.0

## 20220520.1.1 - 2022-05-20

### Major Changes

-   Support Ansible community package 5.8.0
-   Remove Fedora 34 support
-   Cilium as default CNI

## 20220427.1.1 - 2022-04-27

### Major Changes

-   Rename Ansible Role with FQCN
-   Support Ansible community package 5.7.0
-   Support RHEL 9
-   Support CentOS 9 Stream
-   Support openSUSE Leap 15.4

## 20220407.1.2 - 2022-04-07

### Major Changes

-   Support Ansible community package 5.6.0
-   Support Fedora 36
-   Support Ubuntu 22.04
-   Support Ansible community package 5.5.0
-   Remove Kubernetes 1.20 suport
-   Support Ansible community package 5.4.0

## 20220211.1.1 - 2022-02-11

### Major Changes

-   Remove Ubuntu 21.04 support
-   Skip package upgrade before running molecule

## 20211231.1.3 - 2021-12-31

### Major Changes

-   Support Fedora Rawhide
-   Support Debian Testing
-   Remove openSUSE Leap 15.2 support
-   Upgrade minimal Ansible community package support to 4.10

## 20211020.1.1 - 2021-10-20

### Major Changes

-   Remove Fedora 33 support
-   Remove Ubuntu 20.10 support
-   Support Fedora 35
-   Support Ubuntu 21.10
-   Upgrade minimal Ansible community package support to 4.7.0
-   Install dependencies with package manager
-   Rename prefix with `kube_`
-   Predefine `ceph_release` with latest available per distribution
-   Restructure dependency packages with upstream repository

## 20210718.1.1 - 2021-07-18

### Major Changes

-   Upgrade minimal Ansible community package support to 4.2.0
-   Support Debian 11
-   Support openSUSE Leap 15.3

## 20210602.1.1 - 2021-06-02

### Major Changes

-   Upgrade minimal Ansible support to 4.0.0
-   Support Fedora 34
-   Support Ubuntu 21.04

## 20210313.1.1 - 2021-03-13

### Major Changes

-   Bugfix [ansible-lint `namespace`](https://github.com/ansible-community/ansible-lint/pull/1451)
-   Bugfix [ansible-lint `no-handler`](https://github.com/ansible-community/ansible-lint/pull/1402)
-   Bugfix [ansible-lint `unnamed-task`](https://github.com/ansible-community/ansible-lint/pull/1413)
-   Install Python package with `pipx`
-   Simplify Python dependency with system packages
-   Support RHEL 8 with Molecule
-   Support RHEL 7 with Molecule
-   Remove CentOS 8 support
-   Support CentOS 8 Stream
-   Support openSUSE Tumbleweed
-   Migrate base Vagrant box from `generic/*` to `alvistack/*`

## 4.6.0 - 2020-12-28

### Major Changes

-   Simplify Molecule scenario for vagrant-libvirt
-   Migrate from Travis CI to GitLab CI
-   Split Ceph related to `alvistack/ansible-collection-ceph`
-   Support Fedora 33
-   Remove Fedora 32 support
-   Support Ubuntu 20.10
-   Bugfix graceful shutdown deadlock due to systemd dependencies

## 4.5.0 - 2020-08-26

### Major Changes

-   Upgrade minimal Ansible Lint support to 4.3.2
-   Shutdown Kubernetes containers before shutting down the system
-   Shutdown CRI-O containers before shutting down the system
-   Attach/Detach RBD or CephFS after/before `ceph.target` during startup/shutdown
-   Upgrade Travis CI test as Ubuntu Focal based
-   Upgrade minimal Ansible support to 2.10.0
-   Support openSUSE Leap 15.2
-   Remove Ubuntu 19.10 support

## 4.4.0 - 2020-06-04

### Major Changes

-   Install with static binary archive
-   Default with `crun`
-   Support Fedora 32
-   Support Debian 10
-   Support CephFS creation
-   Support OSD pool creation
-   Discovery device for OSD from `ansible_devices`
-   Template complex variable with Jinja `namespace()`
-   Replace use of `ansible_hostname` with `inventory_hostname`
-   `molecule -s default` with delegated to localhost

## 4.3.0 - 2020-04-22

### Major Changes

-   Support CentOS/RHEL 8
-   Support Ubuntu 20.04
-   Remove Ubuntu 16.04 support
-   Upgrade minimal Molecule support to 3.0.2
-   Migrate role name to lowercase or underline
-   Migrate group name to lowercase or underline
-   Migrate molecule `group_vars` to file
-   Consolidate molecule tests into `default` (noop)
-   Revamp as Ansible Collection
-   Revamp with `kube_master` and `kube_node`
-   Default with `cri_o`
-   Default with `ExternalEtcd`
-   Default with Ceph Octoups
-   Default with kubernetes v1.18

## 4.2.0 - 2020-02-15

### Major Changes

-   Migrate molecule driver to Libvirt
-   Migrate molecule verifier to Ansible
-   Support Ubuntu 19.10
-   Add `operator-sdk`
-   Replace `duplicity` with `restic`
-   Default with `mainline` kernel

## 4.1.0 - 2020-01-15

### Major Changes

-   Avoid EPEL Repo and IUS Repo for CentOS/RHEL 7
-   Handle controller setup with `ansible-install.yml`
-   Copy keys for controller by `ceph-install.yml` and `kubernetes-install.yml`
-   Replace default `cephfs-provisioner` with `csi-cephfs`

## 4.0.0 - 2019-11-05

-   Initial release for Ansible 2.9 or higher
-   Support both Ubuntu 16.04/18.04 or RHEL/CentOS 7 or openSUSE Leap 15.1
