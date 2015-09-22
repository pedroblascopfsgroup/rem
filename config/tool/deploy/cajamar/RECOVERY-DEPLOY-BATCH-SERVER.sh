#!/bin/bash

LOCAL_PATH=`pwd`

rm /recovery/batch-server/shells/*.sh
cp scripts/shells/* /recovery/batch-server/shells/
chmod u+x /recovery/batch-server/shells/*.sh
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
    chmod 755 ${directory}
    chmod u+x ${directory}/*.sh
done
rm *.zip
cd $LOCAL_PATH
