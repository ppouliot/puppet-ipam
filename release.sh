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

if [ ! -d ./assets ];
then
  mkdir ./assets
  echo `date` > ./assets/.gitkeeper
fi
if [ ! -d ./.wiki ];
then 
  git clone https://github.com/$USERNAME/$IMAGE.wiki.git .wiki
fi

if [ ! -d ./.wiki/img ];
then
  mkdir -p ./.wiki/img
  echo `date` > ./.wiki/img/.gitkeeper
fi

if [ ! -d ./.wiki/json ];
then
  mkdir -p ./.wiki/json
  echo `date` > ./.wiki/json/.gitkeeper
fi

# run build


asciinema rec -q --title="BuildLog-$IMAGE-$VERSION-Docker" -c './build.sh -d' ./.wiki/json/buildlog-$IMAGE-$VERSION-docker.json
echo "# Docker $USER/$IMAGE:$VERSION" >> BUILDLOG.gifs.sh.md
echo "docker run --rm -v $PWD:/data asciinema/asciicast2gif -s 2 -t solarized-dark ./.wiki/json/buildlog-$IMAGE-$VERSION-docker.json /.wiki/img/buildlog-$IMAGE-$VERSION-docker.gif" >> ./.wiki/BUILDLOG.gifs.sh.md

asciinema rec -q --title="BuildLog-$IMAGE-$VERSION-Vagrant" -c './build.sh -d' ./.wiki/json/buildlog-$IMAGE-$VERSION-vagrant.json
echo "# Docker $USER/$IMAGE:$VERSION" >> BUILDLOG.gifs.sh.md
echo "docker run --rm -v $PWD:/data asciinema/asciicast2gif -s 2 -t solarized-dark ./.wiki/json/buildlog-$IMAGE-$VERSION-vagrant.json /.wiki/img/buildlog-$IMAGE-$VERSION-vagrant.gif" >> ./.wiki/BUILDLOG.gifs.sh.md



# tag Wiki
echo -n "**** COMMITING VERSION:$VERSION $WIKI TO WIKI $USER/$IMAGE.wiki.git ****"
echo -n "**** COMMITING $WIKI TO PROJECT WIKI****"
cd $WIKI
git add -A
echo -n "**** COMMITING VERSION:$VERSION $WIKI TO WIKI $USER/$IMAGE.wiki.git ****"
git commit -m "Build Logs for version $VERSION"
echo -n "**** TAGGING VERSION:$VERSION $WIKI TO WIKI $USER/$IMAGE.wiki.git ****"
git tag -a "$VERSION" -m "version $VERSION"
echo -n "**** PUSHING VERSION:$VERSION $WIKI TO WIKI $USER/$IMAGE.wiki.git ****"
git push
git push --tags

echo -n "**** ADDING BUILD LOGS TO BASE PROJECT VERSION:$VERSION $USER/$IMAGE.wiki.git ****"
cd $BASE
cp ./.wiki/img/buildlog-$IMAGE-$VERSION.gif ./assets/BUILDLOG.gif
cp ./.wiki/json/build-$IMAGE-$VERSION.json ./assets/BUILDLOG.json
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
docker tag $USERNAME/$IMAGE \
$USERNAME/$IMAGE:$VERSION \
$USERNAME/$IMAGE-centos:$VERSION \
$USERNAME/$IMAGE-debian:$VERSION \
$USERNAME/$IMAGE-ubuntu:$VERSION

# push it
echo -n "**** PUSHING DOCKER IMAGE VERSION:$VERSION $BASE TO $USER/$IMAGE:$VERSION (centos,debian,ubuntu)[hub.docker.com]****"
docker push $USERNAME/$IMAGE
docker push $USERNAME/$IMAGE:$VERSION
docker push $USERNAME/$IMAGE-centos:$VERSION
docker push $USERNAME/$IMAGE-debian:$VERSION
docker push $USERNAME/$IMAGE-ubuntu:$VERSION
