#!/usr/bin/env bash

# name of app to build
APP=$1

curr_dir=$PWD

if [ $APP == "zcashd" ] || [ $APP == "zcashd-ui" ] || [ $APP == "zcashd-ui2" ] || [ $APP == "zcashd-lwd" ]; then

	VERSION=$(< app/$APP/version.txt)
	echo "APP=$APP. VERSION=$VERSION"

	APP_IMAGE=${PROJECT}/${APP}:${VERSION}
	APP_TAG=${REPOSITORY_URI}/${APP}:${VERSION}
	
	docker tag ${APP_IMAGE} ${APP_TAG}
	docker push ${APP_TAG}
#	docker rmi ${APP_TAG}
else
	echo "Unknown application => $APP"
fi

#docker tag $IMAGE $REPOSITORY_URI/$APP:latest


#if [ $APP == "zcashd" ]; then
#   
#	echo $IMAGE
#	
#	docker tag $IMAGE $REPOSITORY_URI/zcash-lwd:latest
#
#	docker push $IMAGE:$VERSION
#	docker push $IMAGE:latest
      
#elif [ $APP == "zcashd-ui" ]; then

#	IMAGE=${PROJECT}/$APP
#	echo $IMAGE
	
#	docker push $IMAGE:$VERSION
#	docker push $IMAGE:latest

#elif [ $APP == "zcashd-ui2" ]; then

#	IMAGE=$REPOSITORY_URI/$APP
#	echo $IMAGE
	
#	docker push $IMAGE:$VERSION
#	docker push $IMAGE:latest

#elif [ $APP == "zcashd-lwd" ]; then

#	IMAGE=$REPOSITORY_URI/$APP
#	echo $IMAGE
	
#	docker push $IMAGE:$VERSION
#	docker push $IMAGE:latest
#fi