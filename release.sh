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

# Bump Version
docker run --rm -v "$PWD":/app treeder/bump patch
VERSION=`cat VERSION`
set -x
echo "version: $VERSION"
# Bump Version in metadata.json
sed -i '' 's/^.*\"version\"\:.*/\"version\"\:\ \"'"$VERSION"'\",/' metadata.json

echo -n "***Retrieving and Preparing $IMAGE Wiki for BuildLog Posting ***"

if [ ! -d ./.wiki ];
then 
  git clone https://github.com/$USERNAME/$IMAGE.wiki.git .wiki
fi

if [ ! -d ./.wiki/img/buildlog ];
then
  mkdir -p ./.wiki/img/buildlog
fi

if [ ! -d ./.wiki/json ];
then
  mkdir -p ./.wiki/json
fi

# run build

asciinema rec -q --title="BuildLog-$IMAGE-$VERSION" -c './build.sh -d && ./build.sh -v' ./.wiki/json/buildlog-$IMAGE-$VERSION.json
docker run --rm -v $PWD:/data asciinema/asciicast2gif -s 2 ./.wiki/json/buildlog-$IMAGE-$VERSION.json .wiki/images/buildlog-$IMAGE-$VERSION.gif
# tag Wiki
echo $WIKI
cd $WIKI
git add -A
git commit -m "Build Logs for version $VERSION"
git tag -a "$VERSION" -m "version $VERSION"
git push
git push --tags

echo $BASE
cd $BASE

cp .wiki/images/buildlog-$IMAGE-$VERSION.gif ./BUILDLOG.gif
cp ./.wiki/json/build-$IMAGE-$VERSION.json ./BUILDLOG.json

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
