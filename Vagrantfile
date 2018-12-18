# -*- mode: ruby -*-
# vi: set ft=ruby :
#
required_plugins = %w(vagrant-scp vagrant-puppet-install vagrant-vbguest)

plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end

Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/etc/puppetlabs/code/modules/ipam", :mount_options => ['dmode=775','fmode=777']
  config.vm.synced_folder "./files/hiera", "/etc/puppetlabs/code/environments/production/data", :mount_options => ['dmode=775','fmode=777']
  config.vm.synced_folder "./files/hiera/groups", "/etc/puppetlabs/puppet/data", :mount_options => ['dmode=775','fmode=777']
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "2048"]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.linked_clone = true
  end
  config.puppet_install.puppet_version = "5.5.7"
  config.vm.provision "shell", path: "files/prepare.sh"
  config.vm.provision "shell", inline: "/opt/puppetlabs/puppet/bin/gem install r10k hiera-eyaml"
  config.vm.provision "shell", inline: "curl -o /etc/puppetlabs/code/environments/production/Puppetfile https://raw.githubusercontent.com/ppouliot/puppet-ipam/master/Puppetfile"
  config.vm.provision "shell", inline: "curl -o  /etc/puppetlabs/code/environments/production/hiera.yaml https://raw.githubusercontent.com/ppouliot/puppet-ipam/master/files/hiera/hiera.yaml"
  config.vm.provision "shell", inline: "curl -o  /etc/puppetlabs/puppet/hiera.yaml https://raw.githubusercontent.com/ppouliot/puppet-ipam/master/files/hiera/hiera.yaml"
  config.vm.provision "shell", inline: "cd /etc/puppetlabs/code/environments/production && /opt/puppetlabs/puppet/bin/r10k puppetfile install --verbose DEBUG2"
  config.vm.provision "shell", inline: "/opt/puppetlabs/bin/puppet module list --tree"
  config.vm.provision "shell", inline: "/opt/puppetlabs/bin/puppet apply --debug --trace --verbose --modulepath=/etc/puppetlabs/code/modules:/etc/puppetlabs/code/environments/production/modules /etc/puppetlabs/code/modules/ipam/examples/init.pp"
  config.vm.provision "shell", path: "files/create_omapi.sh"
  config.vm.provision "shell", inline: "/opt/puppetlabs/bin/puppet apply --debug --trace --verbose --modulepath=/etc/puppetlabs/code/modules:/etc/puppetlabs/code/environments/production/modules /etc/puppetlabs/code/modules/ipam/examples/init.pp"

  # IPAM1 Definition
  config.vm.define "ipam1" do |v|
#   v.vm.box = "centos/7"
#   v.vm.box = "debian/jessie64"
    v.vm.box = "ubuntu/xenial64"
    v.vm.hostname = "ipam1.contoso.ltd"
    v.vm.network "private_network", ip: "192.168.0.2"
      nic_type: "virtio"
  end

  # IPAM2 Definition
  config.vm.define "ipam2" do |v|
#   v.vm.box = "centos/7"
#   v.vm.box = "debian/jessie64"
    v.vm.box = "ubuntu/xenial64"
    v.vm.hostname = "ipam2.contoso.ltd"
    v.vm.network "private_network", ip: "192.168.0.3"
      nic_type: "virtio"
  end

#  # Pxe Client
#  config.vm.define "pxe1", autostart: false do |vb|
#    vb.vm.box = "c33s/empty"
#    vb.vm.boot_timeout = 600
#    vb.vm.hostname = "pxe1.contoso.ltd"
#    #  Advanced network configuration
#    vb.vm.provider "virtualbox" do |vb|
#      vb.customize ["modifyvm", :id, "--macaddress2", "000743141530"]
#      vb.customize ['modifyvm', :id, '--boot1', 'net']
#      vb.customize ["modifyvm", :id, "--nic1", "private_network"]
#    end
#  end
end
