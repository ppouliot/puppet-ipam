FROM msopenstack/sentinel-ubuntu:latest
 
RUN apt-get update -y
RUN apt-get install software-properties-common -y
RUN puppet module install puppetlabs-stdlib
RUN puppet module install puppetlabs-apt
RUN puppet module install puppetlabs-concat
RUN puppet module install puppetlabs-firewall
RUN puppet module install puppetlabs-ntp
RUN puppet module install puppetlabs-inifile
RUN puppet module install puppetlabs-dhcp
RUN puppet module install ajjahn-dns
RUN git clone https://github.com/openstack-hyper-v/puppet-ipam /etc/puppet/modules/ipam
RUN mkdir /etc/puppet/hiera
RUN cp /etc/puppet/modules/ipam/files/hieradata/hiera.yaml /etc/puppet/hiera.yaml
RUN cp /etc/puppet/modules/ipam/files/hieradata/ipam.yaml /etc/puppet/hiera/ipam.yaml
RUN cp /etc/puppet/modules/ipam/files/hieradata/ns1.yaml /etc/puppet/hiera/`hostname`.yaml
RUN puppet apply --debug --trace --verbose --modulepath=/etc/puppet/modules /etc/puppet/modules/ipam/tests/init.pp
