#!/bin/bash

#if [ "$#" -lt 1 ]; then
#    echo ""
#    echo "Uso: " $0 " <entorno>"
#    echo ""
#    echo "   <entorno>: desa, pre, pro01, pro02"
#    echo "" 
#    exit 1
#fi
#
#if [[ ! -f config/$1/devon.properties ]] ; then
#    echo ""
#    echo "ERROR: no existe el fichero config/$1/devon.properties"
#    exit 1
#fi

LOCAL_PATH=`pwd`
BASE_DIR=/recovery/haya/batch-server/bcc

#cp config/$1/devon.properties $BASE_DIR/
#cp config/$1/config.ini $BASE_DIR/programas/etl/config/
#unzip zip/batch*.zip
#rm -rf $BASE_DIR/programas/batch/*
#cp -r batch/* $BASE_DIR/programas/batch/
#chmod -R a+rwx $BASE_DIR/programas/batch/*
#cd $LOCAL_PATH
rm -f $BASE_DIR/shells/*.sh
cp scripts/shells/* $BASE_DIR/shells/
#sed -e 's/ENTORNO/$1/g' -i $BASE_DIR/shells/unzip-messages-to-queue.sh
#sed -e 's/ENTORNO/$1/g' -i $BASE_DIR/shells/zip-messages-from-queue.sh
chmod a+rx $BASE_DIR/shells/*.sh
rm -rf $BASE_DIR/programas/etl/apr_*
rm -rf $BASE_DIR/programas/etl/APR_*
cp etl/* $BASE_DIR/programas/etl/
cd $BASE_DIR/programas/etl/
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
#cd $LOCAL_PATH
#cp scripts/batch/*.sh $BASE_DIR/programas/
