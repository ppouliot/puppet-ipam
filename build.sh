#!/usr/bin/env bash
set -ex
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=ppouliot
# image name
IMAGE=puppet-ipam
VERSION=`cat VERSION`
export USERNAME
export IMAGE
export VERSION
-d () {
  docker-compose build --no-cache --force-rm
}
-v () {
 vagrant up ipam1 
 vagrant ssh ipam1 -c 'sudo /etc/puppetlabs/code/modules/ipam/tests/dns_watch_named_xfer_primary_secondary.sh' &
 vagrant up ipam2
}
echo "USAGE: -d Docker -v Vagrant"
$1
