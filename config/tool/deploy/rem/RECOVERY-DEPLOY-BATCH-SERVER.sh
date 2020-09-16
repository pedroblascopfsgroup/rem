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

if [[ "$1" == "val04" ]] ; then
    BASE_DIR=/recovery/mba027/batch-server
fi

if [[ "$1" == "val05" ]] ; then
	BASE_DIR=/recovery/map024/batch-server
fi

if [[ "$1" == "formacion" ]] ; then
	BASE_DIR=/recovery/map018/batch-server
fi

if [[ "$1" == "val06" ]] ; then
	BASE_DIR=/recovery/map023/batch-server
fi

if [[ "$1" == "val08" ]] ; then
	BASE_DIR=/recovery/map020/batch-server
fi

if [[ "$1" == "dwh" ]] ; then
    BASE_DIR=/recovery/map030/batch-server
fi

cp config/$1/config.ini $BASE_DIR/programas/etl/config/
cd $LOCAL_PATH
rm -f $BASE_DIR/shells/*.sh
rm -rf $BASE_DIR/shells/ftp

if [[ ! -d $BASE_DIR/control/etl/output/templates/ ]]; then
    echo "Se crea el directorio shells"
    mkdir $BASE_DIR/shells/
fi

cp config/$1/setBatchEnv.sh $BASE_DIR/shells/
cp -r scripts/shells/* $BASE_DIR/shells/
chmod a+rx $BASE_DIR/shells/*.sh
chmod -R 755 $BASE_DIR/shells/ftp
rm -rf $BASE_DIR/programas/etl/apr_*

if [[ ! -d $BASE_DIR/programas/etl/ ]]; then
    echo "Se crea el directorio etl"
    mkdir $BASE_DIR/programas/etl/
fi

cp etl/* $BASE_DIR/programas/etl/

if [[ ! -d $BASE_DIR/control/etl/output/templates/ ]]; then
    echo "Se crea el directorio templates"
    mkdir $BASE_DIR/control/etl/output/templates
fi
cp -r templates/* $BASE_DIR/control/etl/output/templates/

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
