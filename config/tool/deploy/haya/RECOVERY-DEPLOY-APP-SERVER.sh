#!/bin/bash

#if [ "$#" -lt 1 ]; then
#    echo ""
#    echo "Uso: " $0 " <entorno>"
#    echo ""
#    echo "   <entorno>: desa, pre, pro"
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
SAREB_DIR_BUROFAX=/recovery/haya/app-server/sareb/output/burofax
SAREB_DIR_PLANTILLAS=/recovery/haya/app-server/sareb/plantillas/
BCC_DIR_BUROFAX=/recovery/haya/app-server/bcc/output/burofax
BCC_DIR_PLANTILLAS=/recovery/haya/app-server/bcc/plantillas/

#echo "Copiando fichero de configuración ..."
#cp config/$1/devon.properties /recovery/app-server/

echo "Creando directorio para salida de burofax ..."

mkdir -p $SAREB_DIR_BUROFAX
mkdir -p $BCC_DIR_BUROFAX
chmod -R og+rwx $SAREB_DIR_BUROFAX
chmod -R og+rwx $BCC_DIR_BUROFAX

echo "Creando directorio de plantillas y copiando ficheros ..."
mkdir -p $SAREB_DIR_PLANTILLAS
mkdir -p $BCC_DIR_PLANTILLAS
cp -r plantillas/sareb/* $SAREB_DIR_PLANTILLAS
cp -r plantillas/bcc/* $BCC_DIR_PLANTILLAS
chmod -R og+rwx $SAREB_DIR_PLANTILLAS
chmod -R og+rwx $BCC_DIR_PLANTILLAS

#echo "Copiando ficheros WAR ..."
#if [ -f war/pfs.war ]; then
#    cp war/pfs.war /wlapps/applications/PFS/
#fi

cd $LOCAL_PATH
