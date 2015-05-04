# Ipam
# VERSION 1.0
FROM ubuntu
RUN apt-get update -y && apt-get install -y git wget
RUN release=`lsb_release -c | awk '{print $2}'`
RUN cd /tmp &&  wget http://apt.puppetlabs.com/puppetlabs-release-$release.deb; dpkg -i puppetlabs-release-$release.deb
RUN if [ $? $test -eq 1 ]; then \
   echo "Could not find puppetlabs release for $release.  Trying alternative." \
   wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb; dpkg -i puppetlabs-release-precise.deb \
fi
RUN apt-get update -y && apt-get install -y --force-yes openssh-server puppet ruby ruby-dev
RUN gem install r10k
RUN gem install hiera-eyaml
RUN cd /etc/puppet && wget https://raw.githubusercontent.com/openstack-hyper-v/puppet-ipam/master/Puppetfile -O /etc/puppet/Puppetfile
RUN r10k --verbose DEBUG puppetfile install
RUN puppet apply --verbose --trace --debug --modulepath=/etc/puppet/modules /etc/puppet/modules/ipam/tests/bootstrap.pp
