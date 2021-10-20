# Ansible Collection for Kubernetes

## YYYYMMDD.Y.Z - TBC

### Major Changes

## 20211020.1.1 - 2021-10-20

### Major Changes

  - Remove Fedora 33 support
  - Remove Ubuntu 20.10 support
  - Support Fedora 35
  - Support Ubuntu 21.10
  - Upgrade minimal Ansible community package support to 4.7.0
  - Install dependencies with package manager
  - Rename prefix with `kube_`
  - Predefine `ceph_release` with latest available per distribution
  - Restructure dependency packages with upstream repository

## 20210718.1.1 - 2021-07-18

### Major Changes

  - Upgrade minimal Ansible community package support to 4.2.0
  - Support Debian 11
  - Support openSUSE Leap 15.3

## 20210602.1.1 - 2021-06-02

### Major Changes

  - Upgrade minimal Ansible support to 4.0.0
  - Support Fedora 34
  - Support Ubuntu 21.04

## 20210313.1.1 - 2021-03-13

### Major Changes

  - Bugfix [ansible-lint `namespace`](https://github.com/ansible-community/ansible-lint/pull/1451)
  - Bugfix [ansible-lint `no-handler`](https://github.com/ansible-community/ansible-lint/pull/1402)
  - Bugfix [ansible-lint `unnamed-task`](https://github.com/ansible-community/ansible-lint/pull/1413)
  - Install Python package with `pipx`
  - Simplify Python dependency with system packages
  - Support RHEL 8 with Molecule
  - Support RHEL 7 with Molecule
  - Remove CentOS 8 support
  - Support CentOS 8 Stream
  - Support openSUSE Tumbleweed
  - Migrate base Vagrant box from `generic/*` to `alvistack/*`

## 4.6.0 - 2020-12-28

### Major Changes

  - Simplify Molecule scenario for vagrant-libvirt
  - Migrate from Travis CI to GitLab CI
  - Split Ceph related to `alvistack/ansible-collection-ceph`
  - Support Fedora 33
  - Remove Fedora 32 support
  - Support Ubuntu 20.10
  - Bugfix graceful shutdown deadlock due to systemd dependencies

## 4.5.0 - 2020-08-26

### Major Changes

  - Upgrade minimal Ansible Lint support to 4.3.2
  - Shutdown Kubernetes containers before shutting down the system
  - Shutdown CRI-O containers before shutting down the system
  - Attach/Detach RBD or CephFS after/before `ceph.target` during startup/shutdown
  - Upgrade Travis CI test as Ubuntu Focal based
  - Upgrade minimal Ansible support to 2.10.0
  - Support openSUSE Leap 15.2
  - Remove Ubuntu 19.10 support

## 4.4.0 - 2020-06-04

### Major Changes

  - Install with static binary archive
  - Default with `crun`
  - Support Fedora 32
  - Support Debian 10
  - Support CephFS creation
  - Support OSD pool creation
  - Discovery device for OSD from `ansible_devices`
  - Template complex variable with Jinja `namespace()`
  - Replace use of `ansible_hostname` with `inventory_hostname`
  - `molecule -s default` with delegated to localhost

## 4.3.0 - 2020-04-22

### Major Changes

  - Support CentOS/RHEL 8
  - Support Ubuntu 20.04
  - Remove Ubuntu 16.04 support
  - Upgrade minimal Molecule support to 3.0.2
  - Migrate role name to lowercase or underline
  - Migrate group name to lowercase or underline
  - Migrate molecule `group_vars` to file
  - Consolidate molecule tests into `default` (noop)
  - Revamp as Ansible Collection
  - Revamp with `kube_master` and `kube_node`
  - Default with `cri_o`
  - Default with `ExternalEtcd`
  - Default with Ceph Octoups
  - Default with kubernetes v1.18

## 4.2.0 - 2020-02-15

### Major Changes

  - Migrate molecule driver to Libvirt
  - Migrate molecule verifier to Ansible
  - Support Ubuntu 19.10
  - Add `operator-sdk`
  - Replace `duplicity` with `restic`
  - Default with `mainline` kernel

## 4.1.0 - 2020-01-15

### Major Changes

  - Avoid EPEL Repo and IUS Repo for CentOS/RHEL 7
  - Handle controller setup with `ansible-install.yml`
  - Copy keys for controller by `ceph-install.yml` and `kubernetes-install.yml`
  - Replace default `cephfs-provisioner` with `csi-cephfs`

## 4.0.0 - 2019-11-05

  - Initial release for Ansible 2.9 or higher
  - Support both Ubuntu 16.04/18.04 or RHEL/CentOS 7 or openSUSE Leap 15.1
