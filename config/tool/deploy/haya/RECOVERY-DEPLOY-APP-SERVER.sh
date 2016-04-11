#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo ""
    echo "Uso: " $0 " <entorno>"
    echo ""
    echo "   <entorno>: val01, pre, pro"
    echo "" 
    exit 1
fi

if [[ ! -f config/$1/devon.properties ]] ; then
    echo ""
    echo "ERROR: no existe el fichero config/$1/devon.properties"
    exit 1
fi

LOCAL_PATH=`pwd`
BASE_DIR=/recovery/haya/app-server
FILES_BASE_DIR=/recovery/haya/transferencia

SAREB_DIR_BUROFAX=$BASE_DIR/sareb/output/burofax
SAREB_DIR_PLANTILLAS=$BASE_DIR/sareb/plantillas/
BCC_DIR_BUROFAX=$BASE_DIR/bcc/output/burofax
BCC_DIR_PLANTILLAS=$BASE_DIR/bcc/plantillas/

INTEGRATION_INPUT=$FILES_BASE_DIR/integration/messages/input
INTEGRATION_OUTPUT=$FILES_BASE_DIR/integration/messages/output

echo "Copiando fichero de configuración ..."
cp config/$1/devon.properties $BASE_DIR/

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

echo "Creando directorios para mensajería"
mkdir -p $INTEGRATION_INPUT
mkdir -p $INTEGRATION_OUTPUT
chmod -R og+rwx $INTEGRATION_INPUT
chmod -R og+rwx $INTEGRATION_OUTPUT

echo "Copiando ficheros WAR ..."
if [ -f war/pfs.war ]; then
    cp war/pfs.war $BASE_DIR/
fi

cd $LOCAL_PATH
