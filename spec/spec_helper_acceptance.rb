require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'
require 'beaker-task_helper'

UNSUPPORTED_PLATFORMS = '%w[Windows Solaris AIX]'.freeze

run_puppet_install_helper_on(hosts)
configure_type_defaults_on(hosts)
install_ca_certs unless pe_install?

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    hosts.each do |host|
      # install git
      install_package host, 'git'
      shell('/opt/puppetlabs/puppet/bin/gem install r10k hiera-eyaml')
      shell('curl https://raw.githubusercontent.com/ppouliot/puppet-ipam/master/Puppetfile -o /etc/puppetlabs/code/environments/production/Puppetfile')
      shell('curl https://raw.githubusercontent.com/ppouliot/puppet-ipam/master/files/hiera/hiera.yaml -o /etc/puppetlabs/code/environments/production/hiera.yaml')
      shell('cd /etc/puppetlabs/code/environments/production && /opt/puppetlabs/puppet/bin/r10k puppetfile install --verbose DEBUG')
      shell('cp -R /etc/puppetlabs/code/environments/production/modules/ipam/files/hiera /etc/puppetlabs/code/environments/production/data')
      shell('rm -rf /etc/puppetlabs/code/environments/production/modules/ipam')
      shell("cp /etc/puppetlabs/code/environments/production/data/nodes/ipam1.contoso.ltd.yaml /etc/puppetlabs/code/environments/production/data/nodes/`facter | grep fqdn | awk '{print $3}'| sed -e 's/\"//g'| awk -F, '{print $1}'`.yaml")
      shell("cp /etc/puppetlabs/code/environments/production/data/nodes/ipam1.contoso.ltd.yaml /etc/puppetlabs/code/environments/production/data/nodes/`facter | grep fqdn | awk '{print $3}'| sed -e 's/\"//g'| awk -F, '{print $1}'`.contoso.ltd.yaml")
      shell("cp /etc/puppetlabs/code/environments/production/data/nodes/ipam1.contoso.ltd.yaml /etc/puppetlabs/code/environments/production/data/nodes/`facter | grep fqdn | awk '{print $3}'| sed -e 's/\"//g'`yaml")

    end
    install_module_on(hosts)
    # install_module_dependencies_on(hosts)
  end
end
