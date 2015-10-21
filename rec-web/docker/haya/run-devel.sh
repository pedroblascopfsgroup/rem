#!/bin/bash

BASEDIR=$(pwd)/$(dirname $0)
SHAPSHOT_WAR="$(pwd)/../../target/pfs-9.1-SNAPSHOT.war"
CONTAINER=haya-web-dev

. $BASEDIR/docker-common.sh

docker run --rm -ti -p=22 -p=8080 -p=1044 \
	-v ${HOME}/container-info:/container-info \
	-v $BASEDIR/tomcat-intehaya-ibd011-server.xml:/recovery/app-server/tomcat/conf/server.xml \
	-v $BASEDIR/devon-intehaya-ibd011.properties:/recovery/app-server/devon.properties \
	-v $SHAPSHOT_WAR:/recovery/app-server/pfs.war \
	-h $CONTAINER --name  $CONTAINER $PLATFORM_N3
