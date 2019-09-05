#!/usr/bin/env bash

CMD=$1

curr_dir=$PWD

if [ -z $DOCKER_REPO ]
then
  DOCKER_REPO=localhost:3200
fi

#$(aws ecr get-login --no-include-email)

#EKS_KUBECTL_ROLE_ARN=$(aws iam get-role --role-name BoltlabsEKSClusterAdminRole | jq ".Role.Arn" | tr -d '"')
#AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq ".Account" | tr -d '"')
#AWS_REGION=$(aws configure get region)
#REPOSITORY_URI=$AWS_ACCOUNT_ID.ecr.$AWS_REGION.amazonaws.com

echo "EKS KUBECTL ROLE: ${EKS_KUBECTL_ROLE_ARN}"
echo "AWS ACCOUNT ID: ${AWS_ACCOUNT_ID}"
echo "ZCASHD: $REPOSITORY_URI/zcashd:${ZCASHD_TAG}"
#echo "ZCASH-UI: $REPOSITORY_URI/zcashd:${ZCASH_UI_TAG}"
#echo "ZCASH-LWD: $REPOSITORY_URI/zcashd:${ZCASH_LWD_TAG}"

if [ -z $CMD ]; then
	echo "No command provided!"
	
elif [ $CMD == "build" ]; then
	
#	bin/build_image.sh zcashd
#	bin/build_image.sh zcash-ui
	bin/build_image.sh zcash-lwd

elif [ $CMD == "push" ]; then

	bin/push_image.sh zcashd
#	bin/push_image.sh zcash-ui
#	bin/push_image.sh zcash-lwd

elif [ $CMD == "deploy" ]; then

#	ZCASHD_TAG=$(< app/zcashd/version.txt)
	#ZCASH_UI_TAG=$(< app/zcash-ui/version.txt)
	#ZCASH_LWD_TAG=$(< app/zcash-lwd/version.txt)

#  	sed -i.bu 's/testnet = false/testnet = true/g' manifests/app/zcashd.yaml

#	sed -i '/image/c\image: $REPOSITORY_URI/zcashd:$ZCASHD_TAG' manifests/app/zcashd.yaml
	
#    sed -i 's@CONTAINER_IMAGE@'"$REPOSITORY_URI/zcash-ui:$ZCASH_UI_TAG"'@' manifests/zcash-ui.yaml
#    sed -i 's@CONTAINER_IMAGE@'"$REPOSITORY_URI/zcash-lwd:$ZCASH_LWD_TAG"'@' manifests/zcash-lwd.yaml

	bin/deploy.sh zcashd $2
	bin/deploy.sh zcash-ui $2
	bin/deploy.sh zcash-lwd $2
fi
