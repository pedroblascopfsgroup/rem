#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo ""
    echo "Uso: " $0 " <entorno>"
    echo ""
    echo "   <entorno>: val03, val04, pre, pro, formacion"
    echo "" 
    exit 1
fi

if [[ ! -f config/$1/devon.properties ]] ; then
    echo ""
    echo "ERROR: no existe el fichero config/$1/devon.properties"
    exit 1
fi

LOCAL_PATH=`pwd`
BASE_DIR=/recovery/rem/app-server

if [ "$1" == "val03" ] ; then
    BASE_DIR=/home/map017
fi

if [ "$1" == "val04" ] ; then
    BASE_DIR=/home/map019	
fi

if [ "$1" == "val06" ] ; then
    BASE_DIR=/home/map023
fi

if [ "$1" == "formacion" ] ; then
    BASE_DIR=/recovery/map018/app-server
fi

echo "Copiando fichero de configuración ..."
cp config/$1/devon.properties $BASE_DIR/

echo "Copiando ficheros WAR ..."
if [ -f war/pfs*.war ]; then
    cp war/pfs*.war $BASE_DIR/pfs-rec-web.war
fi

echo "Creando directorio para WSDL de SAREB y copiando ficheros ..."
if [[ $1 == 'pro' ]]; then
	cp -r wsdl/pro/* $BASE_DIR/wsdl/pro
elif [[ $1 == 'val03' ]]; then
	BASE_DIR=/recovery/rem/app-server
	cp -r wsdl/pre/* $BASE_DIR/wsdl/pre
elif [[ $1 == 'val06' ]]; then
	BASE_DIR=/recovery/map023/app-server
	cp -r wsdl/pre/* $BASE_DIR/wsdl/pre
else
	cp -r wsdl/pre/* $BASE_DIR/wsdl/pre
fi

cd $LOCAL_PATH
