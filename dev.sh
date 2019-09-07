#!/usr/bin/env bash

CMD=$1

curr_dir=$PWD

if [ -z $REPOSITORY_URI ]
then
  export REPOSITORY_URI=boltlabs
fi

if [ -z ${PROJECT} ]; then
  export PROJECT=boltlabs
fi

#EKS_KUBECTL_ROLE_ARN=$(aws iam get-role --role-name BoltlabsEKSClusterAdminRole | jq ".Role.Arn" | tr -d '"')
#AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq ".Account" | tr -d '"')
#AWS_REGION=$(aws configure get region)
#REPOSITORY_URI=$AWS_ACCOUNT_ID.ecr.$AWS_REGION.amazonaws.com

#echo "EKS KUBECTL ROLE: ${EKS_KUBECTL_ROLE_ARN}"
#echo "AWS ACCOUNT ID: ${AWS_ACCOUNT_ID}"
#echo "ZCASHD: $REPOSITORY_URI/zcashd:${ZCASHD_TAG}"
#echo "ZCASH-UI: $REPOSITORY_URI/zcashd:${ZCASH_UI_TAG}"
#echo "ZCASH-LWD: $REPOSITORY_URI/zcashd:${ZCASH_LWD_TAG}"

echo "Repository => ${REPOSITORY_URI}"
if [ -z $CMD ]; then
	echo "No command provided!"
	
elif [ $CMD == "build" ]; then

	echo "Starting docker build for zcashd"	
	time bin/build_image.sh zcashd
	
	echo "Starting docker build for zcash-ui"
	time bin/build_image.sh zcashd-ui
	
	echo "Starting docker build for zcash-lwd"
	time bin/build_image.sh zcashd-lwd

elif [ $CMD == "push" ]; then

	bin/push_image.sh zcashd
	bin/push_image.sh zcashd-ui
	bin/push_image.sh zcashd-lwd

elif [ $CMD == "deploy" ]; then

	if [ -z $NAMESPACE ]; then 
		NAMESPACE=zc-testnet
	fi

	cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: ${NAMESPACE}	
EOF

	bin/deploy.sh zcashd ${NAMESPACE}
	bin/deploy.sh zcashd-ui ${NAMESPACE}
	bin/deploy.sh zcashd-lwd ${NAMESPACE}
fi
