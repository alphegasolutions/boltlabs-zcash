#!/usr/bin/env bash

# name of app to build
APP=$1

curr_dir=$PWD
VERSION=$(< app/$APP/version.txt)

if [ -z $DOCKER_REPO ]
then
  DOCKER_REPO=alphegasolutions
fi

if [ -z $IMAGE_PREFIX ]; then
  IMAGE_PREFIX=boltlabs
fi


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

	echo $IMAGE_PREFIX/zcash-explorer:$VERSION
#	docker build -t $IMAGE_PREFIX/zcashd:$VERSION --memory-swap -1 .
	docker image build --tag $REPOSITORY_URI/zcashd:$VERSION --memory-swap -1 .

      
elif [ $APP == "zcash-explorer" ]; then

   	mkdir -p target/$APP
   	cd target/$APP

   	echo $PWD

   	cp $curr_dir/app/$APP/Dockerfile .
   	cp $curr_dir/app/$APP/entrypoint.sh .
	cp $curr_dir/app/$APP/bitcore-node.json .

	echo $IMAGE_PREFIX/zcash-explorer:$VERSION
#	docker build -t $IMAGE_PREFIX/zcash-explorer:$VERSION --memory-swap -1 .	
	docker image build --tag $REPOSITORY_URI/zcash-explorer:$VERSION --memory-swap -1 .

elif [ $APP == "zcash-ui" ]; then

   	mkdir -p target/$APP
   	cd target/$APP

   	echo $PWD

   	cp $curr_dir/app/$APP/Dockerfile .
   	cp $curr_dir/app/$APP/entrypoint.sh .
	cp $curr_dir/app/$APP/bitcore-node.json .

	echo $IMAGE_PREFIX/$APP:$VERSION
#	docker build -t $IMAGE_PREFIX/$APP:$VERSION --memory-swap -1 .	

	docker image build --tag $REPOSITORY_URI/zcash-ui:$VERSION --memory-swap -1 .

elif [ $APP == "zcash-lwd" ]; then


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
	
	echo $IMAGE_PREFIX/zcash-lwd:$VERSION
	#docker build -t $IMAGE_PREFIX/zcash-lwd:$VERSION --memory-swap -1 .	
 
 	docker image build --tag $REPOSITORY_URI/zcash-lwd:$VERSION --memory-swap -1 .
   
fi