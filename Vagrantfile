# -*- mode: ruby -*-
# vi: set ft=ruby :
[
  { :name => "vagrant-scp", :version => ">= 0.5.7" },
  { :name => "vagrant-puppet-install", :version => ">= 5.0.0" },
  { :name => "vagrant-vbguest", :version => ">= 0.15.1" }
].each do |plugin|
  if not Vagrant.has_plugin?(plugin[:name], plugin[:version])
#    raise "#{plugin[:name]} #[plugin[:version]} is required. Please run `vagrant plugin install #{plugin[:name]}`"
    system "vagrant plugin install #{plugin}" unless VAgrant.has_plugin plugin
  end
end

Vagrant.configure("2") do |config|
#  config.vm.box = "ubuntu/xenial64"
  config.vm.synced_folder ".", "/etc/puppetlabs/code/modules/ipam", :mount_options => ['dmode=775','fmode=777']
  config.vm.synced_folder "./files/hiera", "/etc/puppetlabs/code/environments/production/data", :mount_options => ['dmode=775','fmode=777']
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "2048"]
    v.linked_clone = true
  config.puppet_install.puppet_version = :latest
  config.vm.provision "shell", path: "files/prepare.sh"
  config.vm.provision "shell", inline: "/opt/puppetlabs/puppet/bin/gem install r10k hiera-eyaml"
  config.vm.provision "shell", inline: "curl -o /etc/puppetlabs/code/environments/production/Puppetfile https://raw.githubusercontent.com/ppouliot/puppet-ipam/master/Puppetfile"
  config.vm.provision "shell", inline: "curl -o  /etc/puppetlabs/puppet/hiera.yaml https://raw.githubusercontent.com/ppouliot/puppet-ipam/master/files/hiera/hiera.yaml"
  config.vm.provision "shell", inline: "cd /etc/puppetlabs/code/environments/production && /opt/puppetlabs/puppet/bin/r10k puppetfile install --verbose DEBUG2"
  config.vm.provision "shell", inline: "/opt/puppetlabs/bin/puppet module list --tree"
  config.vm.provision "shell", inline: "/opt/puppetlabs/bin/puppet apply --debug --trace --verbose --modulepath=/etc/puppetlabs/code/environments/production/modules:/etc/puppetlabs/code/modules /etc/puppetlabs/code/modules/ipam/examples/init.pp"
# Advanced Puppet Example
#config.vm.provision :shell, :privileged => false do |shell|
#  shell.inline = "puppet apply --debug --modulepath '/vagrant/#{ENV.fetch('MODULES_PATH', 'modules')}' --detailed-exitcodes '/vagrant/#{ENV.fetch('MANIFESTS_PATH', 'manifests')}/#{ENV.fetch('MANIFEST_FILE', 'site.pp')}'"
#end

  end
  config.vm.define "ipam1" do |v|
#    v.vm.box = "centos/7"
#    v.vm.box = "centos/6"
    v.vm.box = "ubuntu/xenial64"
    v.vm.hostname = "ipam1.contoso.ltd"
    v.vm.network "private_network", ip: "192.168.0.2"
  end
# IPAM2 Definition
#  config.vm.define "ipam2" do |v|
#  v.vm.box = "debian/jessie64"
#  Centos ( Work In progress )
#   v.vm.box = "centos/7"
#   v.vm.box_version = "1801.02"
#   v.vm.box_url = "http://cloud.centos.org/centos/7/vagrant/x86_64/images/CentOS-7.box"
#   v.vm.hostname = "ipam2.contoso.ltd"
#   v.vm.network "private_network", ip: "192.168.0.3"
#  end

#  config.vm.define :pxe_client do |pxe_client|

#    pxe_client.vm.box = 'centos/atomic-host'

#    pxe_client.vm.provider :libvirt do |libvirt|
#      libvirt.cpu_mode = 'host-passthrough'
#      libvirt.memory = '1024'
#      libvirt.cpus = '1'
#      libvirt.storage :file, :size => '10G', :type => 'qcow2'
#      libvirt.boot 'network'
#      libvirt.mgmt_attach = 'false'
#      libvirt.management_network_name = "pxe_network"
#      libvirt.management_network_address = "192.168.0.0/24"
#      libvirt.management_network_mode = "nat"
#    end

#    pxe_client.vm.provider :virtualbox do |vb|
#      vb.memory = '1024'
#      vb.cpus = '1'
#      vb.gui = 'true'
#
#      vb.customize [
#        'modifyvm', :id,
#        '--nic1', 'intnet',
#        '--intnet1', 'private_network',
#        '--boot1', 'net',
#        '--boot2', 'none',
#        '--boot3', 'none',
#        '--boot4', 'none'
#      ]
#    end

#  end

end
