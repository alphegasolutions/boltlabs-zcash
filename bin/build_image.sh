#!/usr/bin/env bash

# name of app to build
APP=$1

curr_dir=$PWD
VERSION=$(< app/$APP/version.txt)


#EKS_KUBECTL_ROLE_ARN=$(aws iam get-role --role-name BoltlabsEKSClusterAdminRole | jq ".Role.Arn" | tr -d '"')
#AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq ".Account" | tr -d '"')
#AWS_REGION=$(aws configure get region)
#REPOSITORY_URI=$AWS_ACCOUNT_ID.ecr.$AWS_REGION.amazonaws.com

#ZCASHD_TAG=$(< app/zcashd/version.txt)
#ZCASH_UI_TAG=$(< app/zcash-ui/version.txt)
#ZCASH_LWD_TAG=$(< app/zcash-lwd/version.txt)


echo "APP=$APP. VERSION=$VERSION"

if [ $APP == "zcashd" ]; then
	mkdir -p target/$APP
   	cd target/$APP
   
   	cp $curr_dir/app/$APP/Dockerfile .
   	cp $curr_dir/app/$APP/entrypoint.sh .

	echo "Retrieving git resources from $GIT_REPO"
	git clone https://github.com/zcash/zcash.git
	cd zcash
  	git checkout $VERSION
	cd ..

	IMAGE=${PROJECT}/$APP:$VERSION
	echo "Building $IMAGE"

	docker image build --tag $IMAGE --memory-swap -1 .
	#docker tag $IMAGE $REPOSITORY_URI/zcashd:latest

      
elif [ $APP == "zcashd-ui" ]; then

	ZCASHD_TAG=$(< app/zcashd/version.txt)

   	mkdir -p target/$APP
   	cd target/$APP

   	echo $PWD

   	cp $curr_dir/app/$APP/Dockerfile .
   	cp $curr_dir/app/$APP/entrypoint.sh .
	cp $curr_dir/app/$APP/bitcore-node.json .

	IMAGE=${PROJECT}/$APP:$VERSION
	echo "Building $IMAGE from base ${PROJECT}/zcashd:$ZCASHD_TAG"

	docker image build --build-arg REPOSITORY_URI=${PROJECT} --build-arg ZCASH_VERSION=$ZCASHD_TAG --tag $IMAGE --memory-swap -1 .
	#docker tag $IMAGE $REPOSITORY_URI/zcash-ui:latest

elif [ $APP == "zcashd-ui2" ]; then

   	mkdir -p target/$APP
   	cd target/$APP

   	echo $PWD

   	cp $curr_dir/app/$APP/Dockerfile .
   	cp $curr_dir/app/$APP/entrypoint.sh .
	cp $curr_dir/app/$APP/bitcore-node.json .

	IMAGE=${PROJECT}/$APP:$VERSION
	echo "Building $IMAGE"

	docker image build --tag $IMAGE --memory-swap -1 .
	#docker tag $REPOSITORY_URI/zcash-ui2:$VERSION $REPOSITORY_URI/zcash-ui2:latest

elif [ $APP == "zcashd-lwd" ]; then

	ZCASHD_TAG=$(< app/zcashd/version.txt)

   	mkdir -p target/$APP
   	cd target/$APP
   
   	cp $curr_dir/app/$APP/Dockerfile .
   	cp $curr_dir/app/$APP/entrypoint.sh .
   	cp $curr_dir/app/$APP/zcash.conf .

	if [ -z $LWD_GIT_REPO ]; then
		LWD_GIT_REPO=https://github.com/zcash-hackworks/lightwalletd.git
	fi

	echo $LWD_GIT_REPO
	git clone $LWD_GIT_REPO

#	no known releases yet
#	cd lightwalletd
#	git checkout $VERSION	
#	cd ..
	
	IMAGE=${PROJECT}/$APP:$VERSION
	echo "Building $IMAGE from base $REPOSITORY_URI/zcashd:$ZCASHD_TAG"
 
 	docker image build --build-arg REPOSITORY_URI=${PROJECT} --build-arg ZCASH_VERSION=$ZCASHD_TAG --tag $IMAGE --memory-swap -1 .
	#docker tag $IMAGE $REPOSITORY_URI/zcash-lwd:latest
   
fi