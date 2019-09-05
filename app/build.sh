#!/bin/bash

while getopts "d:g:t:" opt; do
  case $opt in
    d)
      DOCKER_REPO="$OPTARG"
      ;;
    g)
      GIT_REPO="$OPTARG"
      ;;
    t)
      VERSION="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo "usage: $(basename $0) [-g <zcash repo>] [-t <zcash tag>] [-d <docker repo>]"
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      echo "usage: $(basename $0) [-g <zcash repo>] [-t <zcash tag>] [-d <docker repo>]"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

IMAGE=zcashd

#if [ -z "$DOCKER_REPO" ]
#then
#  echo "Docker repository required to build image"
#  echo "usage: $(basename $0) [-g <zcash repo>] [-t <zcash tag>] [-d <docker repo>]"
#  exit 1
#fi

curr_dir=$PWD
echo current directory $curr_dir

mkdir -p target
cd target

cp $curr_dir/app/Dockerfile .
cp $curr_dir/app/entrypoint.sh .


if [ -z "$GIT_REPO" ]
then
  GIT_REPO=https://github.com/zcash/zcash.git
fi

#if [ -d ./zcash ]
#then
#  echo "Removing zcash directory"
#  rm -rf ./zcash
#fi

if [ -f ./VERSION ]
then
  echo "Removing VERSION file"
  rm -rf ./VERSION
fi

echo "Retrieving git resources from $GIT_REPO"
git clone $GIT_REPO
cd zcash

if [ -z "$VERSION" ]
then
  VERSION=`git describe --tags $(git rev-list --tags --max-count=1)`
else
  git checkout $VERSION
fi

# write the version to a txt file
echo $VERSION >> VERSION

echo "Building $DOCKER_REPO/$IMAGE:$VERSION"
cd ..
docker build -t $IMAGE:$VERSION --memory-swap -1 .

#docker build --build-arg VERSION -t $DOCKER_REPO/$IMAGE:$VERSION --memory-swap -1 .
#docker tag $DOCKER_REPO/$IMAGE:$VERSION $DOCKER_REPO/$IMAGE:latest

# remove zcash clone
echo "Cleaning up git resources"
#rm -rf zcash
#rm VERSION

# remove unused images
#echo "Cleaning up unused docker images"
#docker rmi $(docker images | grep "^<none>" | awk '{print $3}')

