# Ansible Collection for Kubernetes

<a href="https://alvistack.com" title="AlviStack" target="_blank"><img src="/alvistack.svg" height="75" alt="AlviStack"></a>
<a href="https://landscape.cncf.io/?selected=alvi-stack-ansible-collection-for-kubernetes" title="Certified Kubernetes" target="_blank"><img src="https://github.com/cncf/artwork/blob/master/projects/kubernetes/certified-kubernetes/versionless/color/certified-kubernetes-color.svg" height="75" alt="Certified Kubernetes"></a>

[![Gitlab pipeline status](https://img.shields.io/gitlab/pipeline/alvistack/ansible-collection-kubernetes/master)](https://gitlab.com/alvistack/ansible-collection-kubernetes/-/pipelines)
[![GitHub tag](https://img.shields.io/github/tag/alvistack/ansible-collection-kubernetes.svg)](https://github.com/alvistack/ansible-collection-kubernetes/tags)
[![GitHub license](https://img.shields.io/github/license/alvistack/ansible-collection-kubernetes.svg)](https://github.com/alvistack/ansible-collection-kubernetes/blob/master/LICENSE)
[![Ansible Collection](https://img.shields.io/badge/galaxy-alvistack.kubernetes-blue.svg)](https://galaxy.ansible.com/alvistack/kubernetes)

Ansible Collection for
[Kubernetes](https://github.com/kubernetes/kubernetes).

This Ansible collection provides Ansible playbooks and roles for the
deployment and configuration of a [Certified
Kubernetes](https://www.cncf.io/certification/software-conformance/)
environment.

## Requirements

This collection require Ansible community package 4.10 or higher.

This collection was designed for:

- Ubuntu 20.04, 22.04, 24.04, 25.04
- AlmaLinux 8, 9
- openSUSE Leap 15.6, Tumbleweed
- Debian 12, 13, Testing
- Fedora 40, 41, 42, Rawhide
- CentOS 7, 8 Stream, 9 Stream
- RHEL 7, 8, 9

## Quick Start

### Bootstrap Ansible and Roles

Start by cloning the repository, checkout the corresponding branch, and
init with `git submodule`, then install Ansible (see
<https://software.opensuse.org/download/package?package=ansible&project=home%3Aalvistack>):

    # GIT checkout development branch
    mkdir -p /opt/ansible-collection-kubernetes
    cd /opt/ansible-collection-kubernetes
    git init
    git remote add upstream https://github.com/alvistack/ansible-collection-kubernetes.git
    git fetch --all --prune
    git checkout upstream/develop -- .
    git submodule sync --recursive
    git submodule update --init --recursive

    # Bootstrap Ansible
    printf "Components:\nEnabled: yes\nX-Repolib-Name: alvistack\nSigned-By: /etc/apt/keyrings/home-alvistack.asc\nSuites: /\nTypes: deb\nURIs: http://downloadcontent.opensuse.org/repositories/home:/alvistack/xUbuntu_24.04\n" | tee /etc/apt/sources.list.d/home-alvistack.sources > /dev/null
    curl -fsSL https://downloadcontent.opensuse.org/repositories/home:alvistack/xUbuntu_24.04/Release.key | tee /etc/apt/keyrings/home-alvistack.asc > /dev/null
    apt update
    apt install ansible

    # Confirm the version of Ansible
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
    kubectl version --output=yaml
    kubectl get node --output=yaml
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

Moreover, we are using [Cilium](https://cilium.io/) as [Kubernetes
network plugin
(CNI)](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/)
so we could support [Kubernetes Network
Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/).

This deployment will setup the follow components:

- [Kubernetes](https://kubernetes.io/)
  - CRI: [CRI-O](https://github.com/cri-o/cri-o)
  - CNI: [Cilium](https://github.com/cilium/cilium)
  - CSI: [CSI CephFS](https://github.com/ceph/ceph-csi)
  - Addons:
    - [Kubernetes
      Dashboard](https://github.com/kubernetes/dashboard)
    - [NGINX Ingress
      Controller](https://github.com/kubernetes/ingress-nginx)
    - [Cert Manager](https://github.com/jetstack/cert-manager)

Start by copying the default inventory for customization:

    # Copy default inventory
    mkdir -p /etc/ansible
    rsync -av /opt/ansible-collection-kubernetes/inventory/default/ /etc/ansible

You should update the following files as per your production
environment:

- `/etc/ansible/hosts`
  - Update with your inventory hostnames and IPs
- `/etc/ansible/group_vars/all/*.yml`
  - Update `*_release` and `*_version` if you hope to pin the
    deployment into any legacy supported version

Once update now run the playbooks:

    # Run playbooks
    cd /opt/ansible-collection-kubernetes
    ansible-playbook playbooks/converge.yml
    ansible-playbook playbooks/50-kube-verify.yml
    ansible-playbook playbooks/60-helm_cilium-install.yml
    ansible-playbook playbooks/70-helm_csi_cephfs-install.yml
    ansible-playbook playbooks/70-helm_csi_cephfs-verify.yml
    ansible-playbook playbooks/80-helm_ingress_nginx-install.yml
    ansible-playbook playbooks/80-helm_cert_manager-install.yml

    # Confirm the version and status of Kubernetes
    kubectl version --output=yaml
    kubectl get node --output=yaml
    kubectl get pod --all-namespaces

### Molecule

You could also run our
[Molecule](https://molecule.readthedocs.io/en/stable/) test cases if you
have [Vagrant](https://www.vagrantup.com/) and
[Libvirt](https://libvirt.org/) installed, e.g.

    # Run Molecule on Ubuntu 24.04
    molecule converge -s ubuntu-24.04

Please refer to [.gitlab-ci.yml](.gitlab-ci.yml) for more information on
running Molecule.

## Versioning

### `YYYYMMDD.Y.Z`

Release tags could be find from [GitHub
Release](https://github.com/alvistack/ansible-collection-kubernetes/tags)
of this repository. Thus using these tags will ensure you are running
the most up to date stable version of this image.

### `YYYYMMDD.0.0`

Version tags ended with `.0.0` are rolling release rebuild by [GitLab
pipeline](https://gitlab.com/alvistack/ansible-collection-kubernetes/-/pipelines)
in weekly basis. Thus using these tags will ensure you are running the
latest packages provided by the base image project.

## License

- Code released under [Apache License 2.0](LICENSE)
- Docs released under [CC BY
  4.0](http://creativecommons.org/licenses/by/4.0/)

## Author Information

- Wong Hoi Sing Edison
  - <https://twitter.com/hswong3i>
  - <https://github.com/hswong3i>
