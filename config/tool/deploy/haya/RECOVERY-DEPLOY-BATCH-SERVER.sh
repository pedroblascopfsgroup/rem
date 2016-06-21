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
BASE_DIR=/recovery/haya/batch-server

cp config/$1/devon.properties $BASE_DIR/
unzip zip/batch*.zip
rm -rf $BASE_DIR/batch/*
cp -r batch/* $BASE_DIR/batch/
chmod -R a+rwx $BASE_DIR/batch/*
cp scripts/batch/*.sh $BASE_DIR/
chmod a+rx $BASE_DIR/*.sh
cp jar/batch-shell*.jar $BASE_DIR/bcc/shells/batch-shell.jar
