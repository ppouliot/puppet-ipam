# Puppetfile for local repositories to build core network infrastructure
# Git Settings
git_protocol=ENV['git_protocol'] || 'git'
base_url = "#{git_protocol}://github.com"


branch_name = 'master'
mod 'ripienaar/concat', :git => "#{base_url}/ripienaar/puppet-concat", :ref => branch_name
mod 'puppetlabs/stdlib', :git => "#{base_url}/puppetlabs/puppetlabs-stdlib", :ref => branch_name
#mod 'cprice404/inifile', :git => "#{base_url}/cprice-puppet/puppetlabs-inifile"

#mod 'ppouliot/dhcp', :git => "#{base_url}/ppouliot/puppetlabs-dhcp"
mod 'puppetlabs/dhcp', :git => "#{base_url}/puppetlabs/puppetlabs-dhcp"
#mod 'ppouliot/dns', :git => "#{base_url}/ppouliot/puppet-dns"
mod 'ajjahn/dns', :git => "#{base_url}/ajjahn/puppet-dns"
mod 'ppouliot/ipam', :git => "#{base_url}/ppouliot/puppet-ipam"
