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
FILES_TEMPORARYPATH=$BASE_DIR/pfs/temporaryFiles

echo "Copiando fichero de configuración ..."
cp config/$1/devon.properties $BASE_DIR/

echo "Creando directorio para salida de burofax ..."
mkdir -p $SAREB_DIR_BUROFAX
mkdir -p $BCC_DIR_BUROFAX
chmod -R og+rwx $SAREB_DIR_BUROFAX
chmod -R og+rwx $BCC_DIR_BUROFAX

echo "Creando directorio para WSDL de SAREB y copiando ficheros ..."
mkdir -p $BASE_DIR/sareb/wsdl
cp -r wsdl/sareb/* $BASE_DIR/sareb/wsdl/
if [[ $1 == 'pro' ]]; then
    sed -e 's/HRE_SAREB_WS_DOC_IP/10.126.128.132/g' -i $BASE_DIR/sareb/wsdl/MAESTRO_PERSONAS.wsdl
    sed -e 's/HRE_SAREB_WS_DOC_IP/10.126.128.132/g' -i $BASE_DIR/sareb/wsdl/MAESTRO_ACTIVOS.wsdl
else
    sed -e 's/HRE_SAREB_WS_DOC_IP/10.126.128.4/g' -i $BASE_DIR/sareb/wsdl/MAESTRO_PERSONAS.wsdl
    sed -e 's/HRE_SAREB_WS_DOC_IP/10.126.128.4/g' -i $BASE_DIR/sareb/wsdl/MAESTRO_ACTIVOS.wsdl
fi

echo "Creando directorio de plantillas y copiando ficheros ..."
mkdir -p $SAREB_DIR_PLANTILLAS
mkdir -p $BCC_DIR_PLANTILLAS
cp -r plantillas/sareb/* $SAREB_DIR_PLANTILLAS
cp -r plantillas/bcc/* $BCC_DIR_PLANTILLAS
chmod -R og+rwx $SAREB_DIR_PLANTILLAS
chmod -R og+rwx $BCC_DIR_PLANTILLAS

if [ ! -e $FILES_TEMPORARYPATH ]; then
    echo "Creando directorio de ficheros temporales"
    mkdir -p $FILES_TEMPORARYPATH
fi 

if [ ! -e $INTEGRATION_INPUT ]; then
    echo "Creando directorios para mensajería"
    mkdir -p $INTEGRATION_INPUT
    mkdir -p $INTEGRATION_OUTPUT
    chmod -R og+rwx $INTEGRATION_INPUT
    chmod -R og+rwx $INTEGRATION_OUTPUT
fi

echo "Copiando ficheros WAR ..."
if [ -f war/pfs.war ]; then
    cp war/pfs.war $BASE_DIR/
fi

cd $LOCAL_PATH
