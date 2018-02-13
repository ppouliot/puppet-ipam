#!/usr/bin/env bash

/opt/puppetlabs/puppet/bin/gem install r10k hiera-eyaml
cd /etc/puppetlabs/code/environments/production
cp modules/ipam/Puppetfile /etc/puppetlabs/code/environments/production/Puppetfile
cd /etc/puppetlabs/code/environments/production && /opt/puppetlabs/puppet/bin/r10k puppetfile install 
