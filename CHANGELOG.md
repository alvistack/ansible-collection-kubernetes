# Ansible Collection for Kubernetes

## 4.6.0 - TBC

### Major Changes

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
