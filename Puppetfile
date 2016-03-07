# Puppetfile for local repositories to build core network infrastructure
# Git Settings
git_protocol=ENV['git_protocol'] || 'git'
base_url = "#{git_protocol}://github.com"


branch_name = 'master'


mod 'stdlib',     :git => "#{base_url}/puppetlabs/puppetlabs-stdlib" #,    :tag => '4.5.1'
mod 'concat',     :git => "#{base_url}/puppetlabs/puppetlabs-concat" #,    :tag => '1.2.0'
mod 'firewall',   :git => "#{base_url}/puppetlabs/puppetlabs-firewall" #,  :tag => '1.4.0'
mod 'ntp',        :git => "#{base_url}/puppetlabs/puppetlabs-ntp" #,       :tag => '3.3.0'
mod 'inifile',    :git => "#{base_url}/puppetlabs/puppetlabs-inifile" #,   :tag => '1.2.0'
mod 'dhcp',       :git => "#{base_url}/puppetlabs/puppetlabs-dhcp" #,      :tag => '0.3.0'
mod 'ajjahn/dns', :git => "#{base_url}/ajjahn/puppet-dns" #,               :tag => '1.1.0'
mod 'ipam',       :git => "#{base_url}/openstack-hyper-v/puppet-ipam",    :ref => "#{branch_name}"
