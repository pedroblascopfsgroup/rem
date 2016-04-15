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
cp config/$1/config.ini $BASE_DIR/bcc/programas/etl/config/
unzip zip/batch*.zip
rm -rf $BASE_DIR/batch/*
cp -r batch/* $BASE_DIR/batch/
chmod -R a+rwx $BASE_DIR/batch/*
cd $LOCAL_PATH
rm -f $BASE_DIR/bcc/shells/*.sh
cp scripts/shells/* $BASE_DIR/bcc/shells/
sed -e 's/ENTORNO/$1/g' -i $BASE_DIR/shells/unzip-messages-to-queue.sh
sed -e 's/ENTORNO/$1/g' -i $BASE_DIR/shells/zip-messages-from-queue.sh
chmod a+rx $BASE_DIR/bcc/shells/*.sh
rm -rf $BASE_DIR/bcc/programas/etl/apr_*
rm -rf $BASE_DIR/bcc/programas/etl/APR_*
cp etl/* $BASE_DIR/bcc/programas/etl/
cd $BASE_DIR/bcc/programas/etl/
for etl in `ls *.zip`
do
    ZIPNAME=`echo ${etl} | cut -d- -f1`
    mv ${etl} "${ZIPNAME}.zip"
    unzip -o ${ZIPNAME}.zip
done
for directory in `ls -d */`
do
    chmod -fR a+rwx ${directory}
done
rm *.zip
cd $LOCAL_PATH
cp scripts/batch/*.sh $BASE_DIR/
chmod a+rx $BASE_DIR/*.sh
cp jar/batch-shell*.jar $BASE_DIR/bcc/shells/batch-shell.jar
