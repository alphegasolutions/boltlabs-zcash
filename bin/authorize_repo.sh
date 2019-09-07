#!/bin/sh

if [ -z $1 ]; then
   PROFILE=default
else
   PROFILE=$1
fi

if [ ! -z $REPOSITORY_URI ]
then
	echo "Getting authentication token to AWS ECR => $REPOSITORY_URI"
	$(aws --profile ${PROFILE} ecr get-login --no-include-email)
else
	echo "REPO NOT SET"
fi


