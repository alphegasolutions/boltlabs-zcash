#!/bin/sh

export EKS_KUBECTL_ROLE_ARN=$(aws iam get-role --role-name BoltlabsEKSClusterAdminRole | jq ".Role.Arn" | tr -d '"')
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq ".Account" | tr -d '"')
export AWS_REGION=$(aws configure get region)
export REPOSITORY_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

#ZCASHD_TAG=$(< app/zcashd/version.txt)
#ZCASH_UI_TAG=$(< app/zcash-ui/version.txt)
#ZCASH_LWD_TAG=$(< app/zcash-lwd/version.txt)

#export EKS_KUBECTL_ROLE_ARN AWS_ACCOUNT_ID AWS_REGION REPOSITORY_URI ZCASHD_TAG ZCASH_UI_TAG ZCASH_LWD_TAG

#echo $EKS_KUBECTL_ROLE_ARN