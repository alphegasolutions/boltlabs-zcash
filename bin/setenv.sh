#!/bin/sh

if [ -z $1 ]; then
   PROFILE=default
else
   PROFILE=$1
fi

export PROJECT=boltlabs
export ENV=test

export EKS_STACK=${PROJECT}-eks-${ENV}
export ROLE_STACK=${PROJECT}-iam
export KUBECONFIG=~/.kube/${EKS_STACK}-config
export STORAGE_CLASS=aws-efs

export EKS_ADMIN_ROLE=$(eks-cf --action find --name ${ROLE_STACK} --profile ${PROFILE} | jq ".outputs.EKSClusterAdminRole" | tr -d '"')

export EKS_KUBECTL_ROLE_ARN=$(aws --profile ${PROFILE} iam get-role --role-name ${EKS_ADMIN_ROLE} | jq ".Role.Arn" | tr -d '"')
export AWS_ACCOUNT_ID=$(aws --profile ${PROFILE} sts get-caller-identity | jq ".Account" | tr -d '"')
export AWS_REGION=$(aws --profile ${PROFILE} configure get region)
export REPOSITORY_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

cat << EOF
**********************************************
  E N V I R O N M E N T  S E T T I N G S
**********************************************
PROJECT = ${PROJECT}
ENV = ${ENV}
EKS_STACK = ${EKS_STACK}
EKS_ADMIN_ROLE = ${EKS_ADMIN_ROLE}
EKS_KUBECTL_ROLE_ARN = ${EKS_KUBECTL_ROLE_ARN}
REPOSITORY_URL = ${REPOSITORY_URI}
**********************************************
EOF


#ZCASHD_TAG=$(< app/zcashd/version.txt)
#ZCASH_UI_TAG=$(< app/zcash-ui/version.txt)
#ZCASH_LWD_TAG=$(< app/zcash-lwd/version.txt)

#export EKS_KUBECTL_ROLE_ARN AWS_ACCOUNT_ID AWS_REGION REPOSITORY_URI ZCASHD_TAG ZCASH_UI_TAG ZCASH_LWD_TAG

#echo $EKS_KUBECTL_ROLE_ARN