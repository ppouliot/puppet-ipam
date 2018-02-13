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

./build.sh
# tag it
git add -A
git commit -m "version $VERSION"
git tag -a "$VERSION" -m "version $VERSION"
git push
git push --tags
docker tag $USERNAME/$IMAGE:$VERSION $USERNAME/IMAGE:$VERSION-centos $USERNAME/$IMAGE:$VERSION-debian $USERNAME/$IMAGE:$VERSION $USERNAME/$IMAGE:$VERSION-ubuntu

# push it
docker push $USERNAME/$IMAGE
docker push $USERNAME/$IMAGE:$VERSION
docker push $USERNAME/$IMAGE:$VERSION-centos
docker push $USERNAME/$IMAGE:$VERSION-debian
docker push $USERNAME/$IMAGE:$VERSION-ubuntu
