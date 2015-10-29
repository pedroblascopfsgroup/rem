#!/bin/bash

LOCAL_PATH=`pwd`

cp scripts/shells/* /aplicaciones/recovecb/shells/
chmod a+x /aplicaciones/recovecb/shells/*.sh
cp etl/* /aplicaciones/recovecb/programas/etl/
cd /aplicaciones/recovecb/programas/etl/
for etl in `ls *.zip`
do
    ZIPNAME=`echo ${etl} | cut -d- -f1`
    mv ${etl} "${ZIPNAME}.zip"
    unzip -o ${ZIPNAME}.zip
done
for directory in `ls -d */`
do
    chmod -f a+x ${directory}/*.sh
done
rm *.zip
cd $LOCAL_PATH
