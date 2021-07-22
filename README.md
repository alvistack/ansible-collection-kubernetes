# Ansible Collection for Kubernetes

[![Gitlab pipeline
status](https://img.shields.io/gitlab/pipeline/alvistack/ansible-collection-kubernetes/master)](https://gitlab.com/alvistack/ansible-collection-kubernetes/-/pipelines)
[![GitHub
release](https://img.shields.io/github/release/alvistack/ansible-collection-kubernetes.svg)](https://github.com/alvistack/ansible-collection-kubernetes/releases)
[![GitHub
license](https://img.shields.io/github/license/alvistack/ansible-collection-kubernetes.svg)](https://github.com/alvistack/ansible-collection-kubernetes/blob/master/LICENSE)
[![Ansible
Collection](https://img.shields.io/badge/galaxy-alvistack.kubernetes-blue.svg)](https://galaxy.ansible.com/alvistack/kubernetes)

Ansible collection for deploying Kubernetes.

This Ansible collection provides Ansible playbooks and roles for the
deployment and configuration of an
[Kubernetes](https://github.com/kubernetes/kubernetes) environment.

## Requirements

This collection require Ansible community package 4.3 or higher.

This collection was designed for:

  - Ubuntu 18.04, 20.04, 20.10, 21.04
  - CentOS 7, 8 Stream
  - openSUSE Leap 15.2, Leap 15.3, Tumbleweed
  - Debian 10, 11
  - Fedora 33, 34
  - RHEL 7, 8

## Quick Start

### Bootstrap Ansible and Roles

Start by cloning the repository, checkout the corresponding branch, and
init with `git submodule`, then bootstrap Python3 + Ansible with
provided helper script:

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

All-in-one (AIO) build is a great way to perform an Kubernetes build
for:

  - A development environment
  - An overview of how all the Kubernetes services fit together
  - A simple lab deployment

Simply execule our default Molecule test case and it will deploy all
default components into your localhost:

    # Run Molecule test case
    molecule test -s default
    
    # Confirm the version and status of Kubernetes
    kubectl version
    kubectl get node --output wide
    kubectl get pod --all-namespaces

### Production

In order to avoid [Single Point of
Failure](https://en.wikipedia.org/wiki/Single_point_of_failure), at
least 3 instances for Kubernetes is recommended.

For production environment we should backed with [Ceph File
System](https://docs.ceph.com/docs/master/cephfs/) for [Kubernetes
Persistent
Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
with `ReadWriteMany` support. Corresponding dynamic provisioning could
be handled by using [CSI CephFS](https://github.com/ceph/ceph-csi).

Traditionally we could use
[Docker](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker)
or
[containerd](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd)
as [Kubernetes container runtime
(CRI)](https://kubernetes.io/blog/2016/12/container-runtime-interface-cri-in-kubernetes/).
Now a day, this collection is default with the modern
[CRI-O](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#cri-o)
implementation.

Moreover, we are using [Weave Net](https://github.com/weaveworks/weave)
as [Kubernetes network plugin
(CNI)](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/)
so we could support [Kubernetes Network
Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/).

This deployment will setup the follow components:

  - [Kubernetes](https://kubernetes.io/)
      - CRI: [CRI-O](https://cri-o.io/)
      - CNI: [Weave Net](https://github.com/weaveworks/weave)
      - CSI: [CSI
        Hostpath](https://github.com/kubernetes-csi/csi-driver-host-path)
      - Addons:
          - [Kubernetes
            Dashboard](https://github.com/kubernetes/dashboard)
          - [NGINX Ingress
            Controller](https://github.com/kubernetes/ingress-nginx)
          - [Cert Manager](https://github.com/jetstack/cert-manager)

Start by copying the default inventory for customization:

    # Copy default inventory
    cp -rfp inventory/default inventory/myinventory

You should update the following files as per your production
environment:

    - `inventory/myinventory/hosts`
      - Update with your inventory hostnames and IPs
    - `inventory/myinventory/group_vars/all/00-defaults.yml`
      - Update `*_release` and `*_version` if you hope to pin the deployment into any legacy supported version

Once update now run the playbooks:

    # Run playbooks
    ansible-playbook -i inventory/myinventory/hosts playbooks/converge.yml
    
    # Confirm the version and status of Kubernetes
    kubectl version
    kubectl get node --output wide
    kubectl get pod --all-namespaces

### Molecule

You could also run our
[Molecule](https://molecule.readthedocs.io/en/stable/) test cases if you
have [Vagrant](https://www.vagrantup.com/) and
[Libvirt](https://libvirt.org/) installed, e.g.

    # Bootstrap Vagrant and Libvirt
    ./scripts/bootstrap-vagrant.sh
    
    # Run Molecule on Ubuntu 20.04
    molecule converge -s ubuntu-20.04

Please refer to [.travis.yml](.travis.yml) for more information on
running Molecule.

## License

  - Code released under [Apache License 2.0](LICENSE)
  - Docs released under [CC BY
    4.0](http://creativecommons.org/licenses/by/4.0/)

## Author Information

  - Wong Hoi Sing Edison
      - <https://twitter.com/hswong3i>
      - <https://github.com/hswong3i>
