# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Configuration
  nb_workers = 3
  bridge_interface = "wlp2s0"

  # Common VM configuration

  config.vm.box = "centos/7"
  config.vm.network :public_network, type: "dhcp", bridge: bridge_interface
  config.vm.provision "shell", name: "prepare-kubeadm", path: "./prepare-for-kube.sh"

  # Configure Kubernetes master node
  config.vm.define "kube-master" do |master|
    master.vm.hostname = "kube-master"
    master.vm.provider :virtualbox do |v|
      v.name = "kube-master"
      v.cpus = 4
      v.memory = 4096
    end
  end

  # Configure Kubernetes workers nodes

  (1..nb_workers).each do |i|
    config.vm.define "kube-worker-#{i}" do |worker|
      worker.vm.hostname = "kube-worker-#{i}"
      worker.vm.provider :virtualbox do |v|
        v.name = "kube-worker-#{i}"
        v.cpus = 2
        v.memory = 2048
      end
    end
 end
end
