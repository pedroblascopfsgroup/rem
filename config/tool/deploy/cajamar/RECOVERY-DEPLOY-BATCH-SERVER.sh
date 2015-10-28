#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo ""
    echo "Uso: " $0 " <entorno>"
    echo ""
    echo "   <entorno>: desa, pre, pro01, pro02"
    echo "" 
    exit 1
fi

if [[ ! -f config/$1/devon.properties ]] ; then
    echo ""
    echo "ERROR: no existe el fichero config/$1/devon.properties"
    exit 1
fi

LOCAL_PATH=`pwd`

cp config/$1/devon.properties /recovery/batch-server/
unzip zip/batch*.zip
rm -rf /recovery/batch-server/programas/batch/*
cp -r batch/* /recovery/batch-server/programas/batch/
chmod -R a+rw /recovery/batch-server/programas/batch/*
chmod a+x /recovery/batch-server/programas/batch/*.sh
cd $LOCAL_PATH
rm -f /recovery/batch-server/shells/*.sh
cp scripts/shells/* /recovery/batch-server/shells/
chmod a+x /recovery/batch-server/shells/*.sh
cp etl/* /recovery/batch-server/programas/etl/
cd /recovery/batch-server/programas/etl/
for etl in `ls *.zip`
do
    ZIPNAME=`echo ${etl} | cut -d- -f1`
    mv ${etl} "${ZIPNAME}.zip"
    unzip -o ${ZIPNAME}.zip
done
for directory in `ls -d */`
do
    chmod -f 777 ${directory}
    chmod -f a+x ${directory}/*.sh
done
rm *.zip
cd $LOCAL_PATH
