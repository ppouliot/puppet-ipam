#!/usr/bin/env bash

# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=ppouliot
# image name
IMAGE=puppet-ipam
# Ensure the repo is up to date
git pull

# Bump Version
docker run --rm -v "$PWD":/app treeder/bump patch
VERSION=`cat VERSION`
set -x
echo "version: $VERSION"
# Bump Version in metadata.json
sed -i '' 's/^.*\"version\"\:.*/\"version\"\:\ \"'"$VERSION"'\",/' metadata.json

# run build

asciinema rec -q --title=BuildLog-$IMAGE-$VERSION ./build-$IMAGE-$VERSION.json
./build.sh -d
./build.sh -v 
exit 
mv ./build-$IMAGE-$VERSION.json ./BUILDLOG.json
# tag it
git add -A
git commit -m "version $VERSION"
git tag -a "$VERSION" -m "version $VERSION"
git push
git push --tags
docker tag $USERNAME/$IMAGE \
$USERNAME/$IMAGE:$VERSION \
$USERNAME/$IMAGE-centos:$VERSION \
$USERNAME/$IMAGE-debian:$VERSION \
$USERNAME/$IMAGE-ubuntu:$VERSION

# push it
docker push $USERNAME/$IMAGE
docker push $USERNAME/$IMAGE-centos:$VERSION
docker push $USERNAME/$IMAGE-debian:$VERSION
docker push $USERNAME/$IMAGE-ubuntu:$VERSION


