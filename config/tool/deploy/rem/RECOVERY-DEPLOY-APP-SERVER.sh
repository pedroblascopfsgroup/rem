#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo ""
    echo "Uso: " $0 " <entorno>"
    echo ""
    echo "   <entorno>: val03, val04, pre, pro"
    echo "" 
    exit 1
fi

if [ $1 =! "val04" ] ; then
if [[ ! -f config/$1/devon.properties ]] ; then
    echo ""
    echo "ERROR: no existe el fichero config/$1/devon.properties"
    exit 1
fi
fi

LOCAL_PATH=`pwd`
BASE_DIR=/recovery/rem/app-server

if [ "$1" == "val03" ] ; then
    BASE_DIR=/home/map017/
fi

if [ "$1" == "val04" ] ; then
    BASE_DIR=/home/map019/	
fi

if [ $1 =! "val04" ] ; then
echo "Copiando fichero de configuración ..."
cp config/$1/devon.properties $BASE_DIR/
fi

echo "Copiando ficheros WAR ..."
if [ -f war/pfs*.war ]; then
    cp war/pfs*.war $BASE_DIR/pfs-rec-web.war
fi

cd $LOCAL_PATH
