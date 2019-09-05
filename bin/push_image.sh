#!/usr/bin/env bash

# name of app to build
APP=$1

curr_dir=$PWD
VERSION=$(< app/$APP/version.txt)

if [ -z $DOCKER_REPO ]
then
  DOCKER_REPO=localhost:3200
fi

if [ -z $IMAGE_PREFIX ]; then
  IMAGE_PREFIX=boltlabs
fi


#EKS_KUBECTL_ROLE_ARN=$(aws iam get-role --role-name BoltlabsEKSClusterAdminRole | jq ".Role.Arn" | tr -d '"')
#AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq ".Account" | tr -d '"')
#AWS_REGION=$(aws configure get region)
#REPOSITORY_URI=$AWS_ACCOUNT_ID.ecr.$AWS_REGION.amazonaws.com


echo "APP=$APP. VERSION=$VERSION"

if [ $APP == "zcashd" ]; then
   
	echo $REPOSITORY_URI/zcash-explorer:$VERSION
	
	docker push $REPOSITORY_URI/$APP:$VERSION
#	docker push $DOCKER_REPO/$APP:latest
      
elif [ $APP == "zcash-explorer" ]; then

	echo $REPOSITORY_URI/zcash-explorer:$VERSION

	docker push $REPOSITORY_URI/$APP:$VERSION
#	docker push $DOCKER_REPO/$APP:latest

elif [ $APP == "zcash-ui" ]; then

	echo $DOCKER_REPO/$APP:$VERSION
	docker push $REPOSITORY_URI/$APP:$VERSION
#	docker push $DOCKER_REPO/$APP:latest

elif [ $APP == "zcash-lwd" ]; then

	echo $REPOSITORY_URI/zcash-lwd:$VERSION

	docker push $REPOSITORY_URI/$APP:$VERSION
#	docker push $DOCKER_REPO/$APP:latest
fi