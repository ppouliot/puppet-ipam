# -*- mode: ruby -*-
# vi: set ft=ruby :
[
  { :name => "vagrant-scp", :version => ">= 0.5.7" },
  { :name => "vagrant-puppet-install", :version => ">= 5.0.0" },
].each do |plugin|
  if not Vagrant.has_plugin?(plugin[:name], plugin[:version])
    raise "#{plugin[:name]} #[plugin[:version]} is required. Please run `vagrant plugin install #{plugin[:name]}`"
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
  config.vm.provision "shell", inline: "/opt/puppetlabs/puppet/bin/gem install r10k hiera-eyaml"
  config.vm.provision "shell", inline: "cd /etc/puppetlabs/code/environments/production && wget https://raw.githubusercontent.com/ppouliot/puppet-ipam/master/Puppetfile"
  config.vm.provision "shell", inline: "cd /etc/puppetlabs/code/environments/production && /opt/puppetlabs/puppet/bin/r10k puppetfile install --verbose DEBUG2"
  config.vm.provision "shell", inline: "cd /etc/puppetlabs/puppet/ && wget https://raw.githubusercontent.com/ppouliot/puppet-ipam/master/files/hiera/hiera.yaml"
  config.vm.provision "shell", inline: "/opt/puppetlabs/bin/puppet module list --tree"
  config.vm.provision "shell", inline: "/opt/puppetlabs/bin/puppet apply --debug --trace --verbose --modulepath=/etc/puppetlabs/code/environments/production/modules:/etc/puppetlabs/code/modules /etc/puppetlabs/code/modules/ipam/examples/init.pp"

  end
  config.vm.define "ipam1" do |v|
    v.vm.box = "ubuntu/xenial64"
    v.vm.hostname = "ipam1.contoso.lld"
    v.vm.network "private_network", ip: "192.168.0.2"
  end
  config.vm.define "ipam2" do |v|
    v.vm.box = "centos/7"
    v.vm.hostname = "ipam2.contoso.ltd"
    v.vm.network "private_network", ip: "192.168.0.3"
  end


end
