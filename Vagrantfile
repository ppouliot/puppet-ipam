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
  config.vm.box = "ubuntu/xenial64"
#  config.vm.synced_folder ".", "/etc/puppetlabs/code/environments/production/modules/ipam", :mount_options => ['dmode=774','fmode=775']
  config.vm.synced_folder ".", "/usr/local/src/puppet-ipam", :mount_options => ['dmode=774','fmode=775']
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "2048"]
    v.linked_clone = true
  config.puppet_install.puppet_version = :latest
  config.vm.provision "shell", inline: "/opt/puppetlabs/puppet/bin/gem install r10k hiera-eyaml"
  config.vm.provision "shell", inline: "cd /etc/puppetlabs/code/environments/production && wget https://raw.githubusercontent.com/ppouliot/puppet-ipam/master/Puppetfile"
  config.vm.provision "shell", inline: "cd /etc/puppetlabs/code/environments/production && /opt/puppetlabs/puppet/bin/r10k puppetfile install --verbose DEBUG2"
#  config.vm.provision "shell", path: "files/vagrant.sh"
  end

  config.vm.define "ipam1" do |v|
    v.vm.hostname = "ipam1.contoso.tld"
    v.vm.network "private_network", ip: "192.168.0.2"
  end

end
