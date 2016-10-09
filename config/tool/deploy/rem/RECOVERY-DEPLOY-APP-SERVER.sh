#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo ""
    echo "Uso: " $0 " <entorno>"
    echo ""
    echo "   <entorno>: val01, pre, pro"
    echo "" 
    exit 1
fi

if [[ ! -f config/$1/devon.properties ]] ; then
    echo ""
    echo "ERROR: no existe el fichero config/$1/devon.properties"
    exit 1
fi

LOCAL_PATH=`pwd`
BASE_DIR=/recovery/haya/app-server

if [ "$1" == "val01" ] ; then
    BASE_DIR=/home/map017/
fi

echo "Copiando fichero de configuración ..."
cp config/$1/devon.properties $BASE_DIR/

echo "Copiando ficheros WAR ..."
if [ -f war/pfs-rec-web.war ]; then
    cp war/pfs-rec-web.war $BASE_DIR/
fi

cd $LOCAL_PATH
