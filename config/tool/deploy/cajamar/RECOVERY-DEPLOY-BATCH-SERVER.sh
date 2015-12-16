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
chmod -R a+rwx /recovery/batch-server/programas/batch/*
cd $LOCAL_PATH
rm -f /recovery/batch-server/shells/*.sh
cp scripts/shells/* /recovery/batch-server/shells/
sed -e 's/ENTORNO/$1/g' -i /recovery/batch-server/shells/unzip-messages-to-queue.sh
sed -e 's/ENTORNO/$1/g' -i /recovery/batch-server/shells/zip-messages-from-queue.sh
chmod a+x /recovery/batch-server/shells/*.sh
rm -rf /recovery/batch-server/programas/etl/apr_*
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
    chmod -fR a+rwx ${directory}
done
rm *.zip
cd $LOCAL_PATH
cp scripts/batch/*.sh /recovery/batch-server/programas/
