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
docker-compose build --no-cache --force-rm
