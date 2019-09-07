#!/usr/bin/env bash

# name of app to build
APP=$1

NAMESPACE=$2

curr_dir=$PWD
VERSION=$(< app/$APP/version.txt)
MANIFEST_FILE=manifests/app/$APP.yaml
BACKUP_FILE=manifests/app/$APP.yaml.bu

echo "APP=$APP VERSION=$VERSION NAMESPACE=$NAMESPACE"

if [ $APP == "zcashd" ]; then

    sed -i.bu 's/image:.*/image: '${REPOSITORY_URI}'\/zcashd:'${VERSION}'/g' $MANIFEST_FILE
    sed -i.bu 's/namespace:.*/namespace: '${NAMESPACE}'/g' $MANIFEST_FILE
    sed -i.bu 's/storageClassName:.*/storageClassName: '${STORAGE_CLASS}'/g' ${MANIFEST_FILE}
	rm $BACKUP_FILE
	
	kubectl apply -f $MANIFEST_FILE
	      
elif [ $APP == "zcashd-ui" ]; then

    sed -i.bu 's/image:.*/image: '${REPOSITORY_URI}'\/zcashd-ui:'${VERSION}'/g' $MANIFEST_FILE
    sed -i.bu 's/namespace:.*/namespace: '${NAMESPACE}'/g' $MANIFEST_FILE
    sed -i.bu 's/storageClassName:.*/storageClassName: '${STORAGE_CLASS}'/g' ${MANIFEST_FILE}
	rm $BACKUP_FILE

	kubectl apply -f $MANIFEST_FILE

elif [ $APP == "zcashd-ui2" ]; then

    sed -i.bu 's/image:.*/image: '${REPOSITORY_URI}'\/zcashd-ui2:'${VERSION}'/g' $MANIFEST_FILE
    sed -i.bu 's/namespace:.*/namespace: '${NAMESPACE}'/g' $MANIFEST_FILE
    sed -i.bu 's/storageClassName:.*/storageClassName: '${STORAGE_CLASS}'/g' ${MANIFEST_FILE}
	rm $BACKUP_FILE

#	kubectl apply -f $MANIFEST_FILE

elif [ $APP == "zcashd-lwd" ]; then

    sed -i.bu 's/image:.*/image: '${REPOSITORY_URI}'\/zcashd-lwd:'${VERSION}'/g' $MANIFEST_FILE
    sed -i.bu 's/namespace:.*/namespace: '${NAMESPACE}'/g' $MANIFEST_FILE
    sed -i.bu 's/storageClassName:.*/storageClassName: '${STORAGE_CLASS}'/g' ${MANIFEST_FILE}
	rm $BACKUP_FILE

	kubectl apply -f $MANIFEST_FILE
fi
