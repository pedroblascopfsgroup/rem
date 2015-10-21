#!/bin/bash

LOCAL_PATH=`pwd`


unzip zip/batch*.zip
rm -rf /recovery/batch-server/programas/batch/*
cp -r batch/* /recovery/batch-server/programas/batch/
chmod -R g+rw /recovery/batch-server/programas/batch/*
cd $LOCAL_PATH
rm -f /recovery/batch-server/shells/*.sh
cp scripts/shells/* /recovery/batch-server/shells/
chmod ug+x /recovery/batch-server/shells/*.sh
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
    chmod -f 775 ${directory}
    chmod -f ug+x ${directory}/*.sh
done
rm *.zip
cd $LOCAL_PATH
