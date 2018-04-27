#!/usr/bin/env bash 
# SET THE FOLLOWING VARIABLES
BASE=`pwd`
WIKI="`pwd`/.wiki"
# docker hub username
USERNAME=ppouliot
# image name
IMAGE=puppet-ipam
echo "base:$BASE wiki:$WIKI"
# Ensure the repo is up to date
git pull
echo "**** Bumping  Version ****"
docker run --rm -v "$PWD":/app treeder/bump patch
VERSION=`cat VERSION`
set -x
echo "version: $VERSION"
echo "Bump Version in metadata.json"
sed -i '' 's/^.*\"version\"\:.*/\"version\"\:\ \"'"$VERSION"'\",/' metadata.json
echo "Remove previous log and  run build"
rm -rf ./BUILDLOG.json

asciinema rec -q --title="BuildLog-$IMAGE-$VERSION" -c './build.sh -d && ./build.sh -v' ./BUILDLOG.json 
echo "**** Removing build artifacts before commiting and tagging ****"
./tests/cleanup.sh

# tag it
git add -A
echo -n "**** COMMITING VERSION:$VERSION $BASE TO $USER/$IMAGE.git ****"
git commit -m "Build Logs for version $VERSION"
echo -n "**** TAGGING VERSION:$VERSION $BASE TO $USER/$IMAGE.git ****"
git tag -a "$VERSION" -m "version $VERSION"
echo -n "**** PUSHING VERSION:$VERSION $BASE TO $USER/$IMAGE.git ****"
git push
git push --tags
echo -n "**** DOCKER IMAGE TAGGING VERSION:$VERSION $BASE TO $USER/$IMAGE:$VERSION (centos,debian,ubuntu) ****"
docker tag $USERNAME/$IMAGE $USERNAME/$IMAGE:$VERSION
docker tag $USERNAME/$IMAGE-centos $USERNAME/$IMAGE-centos:$VERSION
docker tag $USERNAME/$IMAGE-debian $USERNAME/$IMAGE-debian:$VERSION
docker tag $USERNAME/$IMAGE-ubuntu $USERNAME/$IMAGE-ubuntu:$VERSION

# push it
echo -n "**** PUSHING DOCKER IMAGE VERSION:$VERSION $BASE TO $USER/$IMAGE:$VERSION (centos,debian,ubuntu)[hub.docker.com]****"
docker push $USERNAME/$IMAGE
docker push $USERNAME/$IMAGE-centos
docker push $USERNAME/$IMAGE-debian
docker push $USERNAME/$IMAGE-ubuntu
