# AlviStack-Ansible

## 4.2.0 - TBC

### Major Changes

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
