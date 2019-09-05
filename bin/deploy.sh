#!/usr/bin/env bash

# name of app to build
APP=$1
NAMESPACE=$2

curr_dir=$PWD
VERSION=$(< app/$APP/version.txt)
MANIFEST_FILE=manifests/app/$APP.yaml

#if [ -z $DOCKER_REPO ]
#then
#  DOCKER_REPO=localhost:3200
#fi

echo "APP=$APP. VERSION=$VERSION. NAMESPACE=$NAMESPACE"

if [ $APP == "zcashd" ]; then

    sed -i.bu 's/image:.*/image: '${REPOSITORY_URI}'\/zcashd:'${VERSION}'/g' $MANIFEST_FILE
    sed -i.bu 's/namespace:.*/namespace: '${NAMESPACE}'/g' $MANIFEST_FILE

	kubectl apply -f $MANIFEST_FILE
	      
elif [ $APP == "zcash-explorer" ]; then

    sed -i.bu 's/image:.*/image: '${REPOSITORY_URI}'\/zcash-explorer:'${VERSION}'/g' $MANIFEST_FILE
    sed -i.bu 's/namespace:.*/namespace: '${NAMESPACE}'/g' $MANIFEST_FILE

	kubectl apply -f $MANIFEST_FILE

elif [ $APP == "zcash-ui" ]; then

    sed -i.bu 's/image:.*/image: '${REPOSITORY_URI}'\/zcash-ui:'${VERSION}'/g' $MANIFEST_FILE
    sed -i.bu 's/namespace:.*/namespace: '${NAMESPACE}'/g' $MANIFEST_FILE

	kubectl apply -f $MANIFEST_FILE

elif [ $APP == "zcash-lwd" ]; then

    sed -i.bu 's/image:.*/image: '${REPOSITORY_URI}'\/zcash-lwd:'${VERSION}'/g' $MANIFEST_FILE
    sed -i.bu 's/namespace:.*/namespace: '${NAMESPACE}'/g' $MANIFEST_FILE

	kubectl apply -f $MANIFEST_FILE
fi
