# -*- mode: ruby -*-
# vi: set ft=ruby :
plugins=[
  {
    :name    => "vagrant-scp",
    :version => ">= 0.5.7",
  },
  {
    :name    => "vagrant-puppet-install",
    :version => ">= 5.0.0",
  },
  {
    :name    => "vagrant-vbguest",
    :version => ">= 0.15.1",
  },
]
plugins.each do |plugin|
  if not Vagrant.has_plugin?(plugin[:name], plugin[:version])
    system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin plugin
  end
end

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.synced_folder ".", "/etc/puppetlabs/code/modules/ipam", :mount_options => ['dmode=775','fmode=777']
  config.vm.synced_folder "./files/hiera", "/etc/puppetlabs/code/environments/production/data", :mount_options => ['dmode=775','fmode=777']

  config.vm.provider "virtualbox" do |v|
    # use host as nat dns resolver 
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--memory", "2048"]
    v.linked_clone = true
  end

  config.vm.define "ipam1" do |v|
    v.vm.hostname = "ipam1.dev"
    v.vm.network "private_network", ip: "192.168.0.2", mac: "000c295526f8"
    v.puppet_install.puppet_version = :latest
  #  v.vm.provision "shell", path: "files/prepare.sh"  # disable updates for now
    v.vm.provision "shell", inline: "/opt/puppetlabs/puppet/bin/gem install r10k hiera-eyaml"
    v.vm.provision "shell", inline: "curl -o /etc/puppetlabs/code/environments/production/Puppetfile https://raw.githubusercontent.com/ppouliot/puppet-ipam/master/Puppetfile"
    v.vm.provision "shell", inline: "curl -o  /etc/puppetlabs/puppet/hiera.yaml https://raw.githubusercontent.com/ppouliot/puppet-ipam/master/files/hiera/hiera.yaml"
    v.vm.provision "shell", inline: "cd /etc/puppetlabs/code/environments/production && /opt/puppetlabs/puppet/bin/r10k puppetfile install --verbose DEBUG2"
    v.vm.provision "shell", inline: "/opt/puppetlabs/bin/puppet module list --tree"
    v.vm.provision "shell", inline: "/opt/puppetlabs/bin/puppet apply --debug --trace --verbose --modulepath=/etc/puppetlabs/code/environments/production/modules:/etc/puppetlabs/code/modules /etc/puppetlabs/code/modules/ipam/examples/init.pp"
  end
  config.vm.define "ipam2", autostart: false do |v|
    v.vm.hostname = "ipam2.dev"
    v.vm.network "private_network", ip: "192.168.30.2", mac: "000c293a3efc"
  end

  config.vm.define "pxe1", autostart: false do |v|
    v.vm.hostname = "ipam2.dev"
    v.vm.network "private_network", ip: "dhcp", mac: "000743141530"
  end

end
