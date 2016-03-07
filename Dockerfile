FROM msopenstack/sentinel-ubuntu:latest
 
RUN apt-get update
RUN apt-get install software-properties-common -y
RUN puppet module install puppetlabs-apt
RUN puppet module install puppetlabs-stdlib
RUN puppet module install puppetlabs-concat
RUN puppet module install puppetlabs-firewall
RUN puppet module install puppetlabs-ntp
RUN puppet module install puppetlabs-inifile
RUN puppet module install puppetlabs-dhcp
RUN puppet module install ajjahn-dns

RUN git clone https://github.com/openstack-hyper-v/puppet-ipam /etc/puppet/modules/ipam
RUN puppet apply --debug --trace --verbose --modulepath=/etc/puppet/modules /etc/puppet/modules/ipam/tests/init.pp
