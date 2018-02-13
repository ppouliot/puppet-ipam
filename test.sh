# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=ppouliot
# image name
IMAGE=puppet-ipam
# ensure we're up to date
git pull
# bump version
docker run --rm -v "$PWD":/app treeder/bump patch
VERSION=`cat VERSION`
set -x
echo "version: $VERSION"
sed -i '' 's/^.*\"version\"\:.*/\"version\"\:\ \"'"$VERSION"'\",/' metadata.json

# run build
./build.sh
# tag it
git add -A
git commit -m "version $version"
git tag -a "$version" -m "version $version"
git push
git push --tags
docker tag $USERNAME/$IMAGE:latest $USERNAME/$IMAGE:$version $USERNAME/IMAGE:$version-centos $USERNAME/$IMAGE:$version-debian $USERNAME/$IMAGE:$version $USERNAME/$IMAGE:$version-ubuntu
# push it
docker push $USERNAME/$IMAGE:latest
docker push $USERNAME/$IMAGE:$version
docker push $USERNAME/IMAGE:$version-centos
docker push $USERNAME/$IMAGE:$version-debian
docker push $USERNAME/$IMAGE:$version-ubuntu
