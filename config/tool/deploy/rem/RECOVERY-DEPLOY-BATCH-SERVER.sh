#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo ""
    echo "Uso: " $0 " <entorno>"
    echo ""
    echo "   <entorno>: inte, pre, val, pro"
    echo "" 
    exit 1
fi

if [[ ! -f config/$1/config.ini ]] ; then
    echo ""
    echo "ERROR: no existe el fichero config/$1/config.ini"
    exit 1
fi

LOCAL_PATH=`pwd`
BASE_DIR=/recovery/rem/batch-server
if [[ "$1" == "val03" ]] ; then
BASE_DIR=/recovery/rem/batch-server-val03
fi

if [[ "$1" == "val06" ]] ; then
BASE_DIR=/recovery/map023/batch-server
fi

cp config/$1/config.ini $BASE_DIR/programas/etl/config/
cd $LOCAL_PATH
rm -f $BASE_DIR/shells/*.sh
rm -rf $BASE_DIR/shells/ftp
cp config/$1/setBatchEnv.sh $BASE_DIR/shells/
cp -r scripts/shells/* $BASE_DIR/shells/
chmod a+rx $BASE_DIR/shells/*.sh
chmod -R 755 $BASE_DIR/shells/ftp
rm -rf $BASE_DIR/programas/etl/apr_*
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
