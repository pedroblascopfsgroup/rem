#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo ""
    echo "Uso: " $0 " <entorno>"
    echo ""
    echo "   <entorno>: val02, pre, pro"
    echo "" 
    exit 1
fi

if [[ ! -f config/$1/config.ini ]] ; then
    echo ""
    echo "ERROR: no existe el fichero config/$1/config.ini"
    exit 1
fi

LOCAL_PATH=`pwd`
DIR_BASE=/recovery/haya

cp config/$1/config.ini $DIR_BASE/batch-server/sareb/programas/etl/config/
rm -f $DIR_BASE/batch-server/sareb/shells/*.sh
cp config/$1/setBatchEnv.sh $DIR_BASE/batch-server/sareb/shells/
cp -r scripts/shells/* $DIR_BASE/batch-server/sareb/shells/
chmod a+rx $DIR_BASE/batch-server/sareb/shells/*.sh
rm -rf $DIR_BASE/batch-server/sareb/programas/etl/apr_*
rm -rf $DIR_BASE/batch-server/sareb/programas/etl/APR_*
cp etl/* $DIR_BASE/batch-server/sareb/programas/etl/
cd $DIR_BASE/batch-server/sareb/programas/etl/
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
chmod a+rx $DIR_BASE/batch-server/sareb/shells/ftp/*.sh
