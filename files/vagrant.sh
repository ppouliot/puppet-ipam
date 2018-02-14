#!/usr/bin/env bash

/opt/puppetlabs/puppet/bin/gem install r10k hiera-eyaml
cd /etc/puppetlabs/code/environments/production
ln -s modules/ipam/Puppetfile
/opt/puppetlabs/puppet/bin/r10k puppetfile install --verbose DEBUG2
