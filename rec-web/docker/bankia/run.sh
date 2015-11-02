#!/bin/bash

BASEDIR=$(pwd)/$(dirname $0)
CONTAINER=bankia-web

. $BASEDIR/docker-common.sh

docker run --rm -ti -p=22 -p=8080 -p=1044 \
	-v ${HOME}/container-info:/container-info \
	-v $BASEDIR/../../src/main/config/Bankia/INTE/devon.properties:/recovery/app-server/devon.properties \
	-h $CONTAINER --name  $CONTAINER $PLATFORM_N3
