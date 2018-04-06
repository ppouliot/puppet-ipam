FROM puppet/puppet-agent
MAINTAINER peter@pouliot.net
COPY Puppetfile /etc/puppetlabs/code/environments/production/Puppetfile
COPY files/hiera /etc/puppetlabs/code/environments/production/data
COPY files/hiera/hiera.yaml /etc/puppetlabs/code/environments/production/hiera.yaml
COPY Dockerfile Dockerfile
RUN \
    apt-get update -y && apt-get install git curl software-properties-common -y \
    && gem install r10k \
    && cd /etc/puppetlabs/code/environments/production/ \
    && r10k puppetfile install --verbose DEBUG2 \
#    && ln -s data/hiera.yaml /etc/puppetlabs/hiera.yaml \
    && cp data/nodes/ipam1.yaml data/nodes/`facter | grep fqdn | awk '{print $3}'| sed -e 's/\"//g'| awk -F. '{print $1}'`.yaml \
    && cp data/nodes/ipam1.yaml data/nodes/`facter | grep fqdn | awk '{print $3}'| sed -e 's/\"//g'`yaml \
    && ls data/nodes && echo $HOSTNAME \
    && mkdir -p /var/lock/named /var/run/named \
    && puppet module list \
    && puppet module list --tree \
    &&  puppet apply --debug --trace --verbose --modulepath=/etc/puppetlabs/code/environments/production/modules /etc/puppetlabs/code/environments/production/modules/ipam/examples/init.pp
RUN \
    echo "**** Verifying that the ISC-DHCP-SERVER Configuration ****" \
    && /usr/sbin/dhcpd -t
RUN \
    echo "**** Verifying that the BIND Configuration ****" \
    && /usr/sbin/named-checkconf
# Test Slave Build
RUN \
    cd /etc/puppetlabs/code/environments/production/ \
    && cp data/nodes/ipam2.yaml data/nodes/`facter | grep fqdn | awk '{print $3}'| sed -e 's/\"//g'| awk -F. '{print $1}'`.yaml \
    && cp data/nodes/ipam1.yaml data/nodes/`facter | grep fqdn | awk '{print $3}'| sed -e 's/\"//g'`yaml \
    && puppet apply --debug --trace --verbose --modulepath=/etc/puppetlabs/code/environments/production/modules /etc/puppetlabs/code/environments/production/modules/ipam/examples/init.pp
RUN \
    echo "**** Verifying that the ISC-DHCP-SERVER Configuration ****" \
    && /usr/sbin/dhcpd -t
RUN \
    echo "**** Verifying that the BIND Configuration ****" \
    && /usr/sbin/named-checkconf
