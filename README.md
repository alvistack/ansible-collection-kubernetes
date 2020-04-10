# Ansible Collection for Kubernetes

[![Travis](https://img.shields.io/travis/com/alvistack/ansible-collection-kubernetes.svg)](https://travis-ci.com/alvistack/ansible-collection-kubernetes)
[![GitHub release](https://img.shields.io/github/release/alvistack/ansible-collection-kubernetes.svg)](https://github.com/alvistack/ansible-collection-kubernetes/releases)
[![GitHub license](https://img.shields.io/github/license/alvistack/ansible-collection-kubernetes.svg)](https://github.com/alvistack/ansible-collection-kubernetes/blob/master/LICENSE)
[![Ansible Collection](https://img.shields.io/badge/galaxy-alvistack.kubernetes-blue.svg)](https://galaxy.ansible.com/alvistack/kubernetes)

Ansible collection for deploying Kubernetes.

This Ansible collection provides Ansible playbooks and roles for the deployment and configuration of an [Kubernetes](https://github.com/kubernetes/kubernetes) environment.

## Requirements

This playbook require Ansible 2.9 or higher.

This playbook was designed for Ubuntu 16.04/18.04/19.10 or RHEL/CentOS 7/8 or openSUSE Leap 15.1.

## Quick Start

### Bootstrap Ansible and Roles

Start by cloning the Alvistack-Ansible repository, checkout the corresponding branch, and init with `git submodule`, then bootstrap Python3 + Ansible with provided helper script:

    # GIT clone the development branch
    git clone --branch develop https://github.com/alvistack/ansible-collection-kubernetes
    cd ansible-collection-kubernetes
    
    # Setup Roles with GIT submodule
    git submodule init
    git submodule sync
    git submodule update
    
    # Bootstrap Ansible
    ./scripts/bootstrap-ansible.sh
    
    # Confirm the version of Python3, PIP3 and Ansible
    python3 --version
    pip3 --version
    ansible --version

### AIO

All-in-one (AIO) build is a great way to perform an Kubernetes build for:

  - A development environment
  - An overview of how all the Kubernetes services fit together
  - A simple lab deployment

This deployment will setup the follow components:

  - [Flannel](https://github.com/coreos/flannel)
  - [Dashboard](https://github.com/kubernetes/dashboard)
  - [NGINX Ingress Controller](https://github.com/kubernetes/ingress-nginx)
  - [cert-manager](https://github.com/jetstack/cert-manager)
  - [Local Path Provisioner](https://github.com/rancher/local-path-provisioner)

Simply run the playbooks with sample AIO inventory:

    # Run playbooks
    ansible-playbook -i inventory/aio/hosts playbooks/setup-aio.yml
    
    # Confirm the version and status of Kubernetes
    kubectl version
    kubectl get node
    kubectl get pod --all-namespaces

### Production

For production environment we should backed with [Ceph File System](https://docs.ceph.com/docs/master/cephfs/) for [Kubernetes Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/).

Moreover, using [Weave Net](https://github.com/weaveworks/weave) as network plugin so we could support [Kubernetes Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/).

Finally, in order to avoid [Single Point of Failure](https://en.wikipedia.org/wiki/Single_point_of_failure), at least 3 instances for CephFS and 3 instances for Kubernetes is recommended.

This deployment will setup the follow components:

  - [Ceph](https://ceph.io/)
  - [Weave Net](https://github.com/weaveworks/weave)
  - [Dashboard](https://github.com/kubernetes/dashboard)
  - [NGINX Ingress Controller](https://github.com/kubernetes/ingress-nginx)
  - [cert-manager](https://github.com/jetstack/cert-manager)
  - [CephFS Volume Provisioner](https://github.com/kubernetes-incubator/external-storage/tree/master/ceph/cephfs)

Start by copying the sample inventory for customization:

    # Copy sample inventory
    cp -rfp inventory/sample inventory/myinventory

Once update `inventory/myinventory/hosts` as per your production environment, now run the playbooks:

    # Run playbooks
    ansible-playbook -i inventory/myinventory/hosts playbooks/setup-everything.yml
    
    # Confirm the version and status of Ceph
    ceph --version
    ceph --status
    ceph health detail
    
    # Confirm the version and status of Kubernetes
    kubectl version
    kubectl get node
    kubectl get pod --all-namespaces

Moreover, we don't setup the Ceph OSD and Ceph MDS for you, which you should set it up once manually according to your production environment, e.g.:

    # Initialize individual OSDs
    ceph-volume lvm create --bluestore --data /dev/sdb
    ceph-volume lvm create --bluestore --data /dev/sdc
    ceph-volume lvm create --bluestore --data /dev/sdd
    ceph-volume lvm activate --all
    
    # Create OSD pool for RBD
    ceph osd pool create rbd 8 8
    ceph osd pool set rbd size 3
    ceph osd pool set rbd min_size 2
    
    # Create OSD pool for CephFS Metadata
    ceph osd pool create cephfs_metadata 32 32
    ceph osd pool set cephfs_metadata size 3
    ceph osd pool set cephfs_metadata min_size 2
    
    # Create OSD pool for CephFS data
    ceph osd pool create cephfs_data 128 128
    ceph osd pool set cephfs_data size 3
    ceph osd pool set cephfs_data min_size 2
    
    # Create CephFS
    ceph fs new cephfs cephfs_metadata cephfs_data
    ceph fs set cephfs standby_count_wanted 0
    ceph fs set cephfs max_mds 1

### Molecule

You could also run our [Molecule](https://molecule.readthedocs.io/en/stable/) test cases if you have [Vagrant](https://www.vagrantup.com/) and [Libvirt](https://libvirt.org/) installed, e.g.

    # Run Molecule on Ubuntu 18.04 with Vagrant and Libvirt
    molecule converge -s ubuntu-18.04

Please refer to [.travis.yml](.travis.yml) for more information on running Molecule and LXD.

## License

  - Code released under [Apache License 2.0](LICENSE)
  - Docs released under [CC BY 4.0](http://creativecommons.org/licenses/by/4.0/)

## Author Information

  - Wong Hoi Sing Edison
      - <https://twitter.com/hswong3i>
      - <https://github.com/hswong3i>
