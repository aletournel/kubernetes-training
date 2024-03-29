#!/bin/bash

# Disable Swap
swapoff -a
sed -i 's|^/swapfile|#/swapfile|' /etc/fstab

# Disable SELinux
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config

# Handle Yum

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

yum update -y
yum install -y vim wget docker kubelet kubeadm kubectl --disableexcludes=kubernetes

# Enable routing
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# Enable devicemapper
cat <<EOF > /etc/sysconfig/docker-storage
DOCKER_STORAGE_OPTIONS="--storage-driver devicemapper "
EOF
cat <<EOF > /etc/sysconfig/docker-storage-setup
STORAGE_DRIVER=devicemapper
EOF

# Start services
systemctl enable --now docker
systemctl enable --now kubelet
