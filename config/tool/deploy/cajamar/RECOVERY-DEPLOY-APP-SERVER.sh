#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo ""
    echo "Uso: " $0 " <entorno>"
    echo ""
    echo "   <entorno>: desa, pre, pro"
    echo "" 
    exit 1
fi

if [[ ! -f config/$1/devon.properties ]] ; then
    echo ""
    echo "ERROR: no existe el fichero config/$1/devon.properties"
    exit 1
fi

LOCAL_PATH=`pwd`

echo "Copiando fichero de configuración ..."
cp config/$1/devon.properties /recovery/app-server/

echo "Copiando plantillas ..."
mkdir -p /recovery/app-server/plantillas
cp -r plantillas/* /recovery/app-server/plantillas
chmod -R og+rwx /recovery/app-server/plantillas

echo "Copiando ficheros WAR ..."
if [ -f war/pfs.war ]; then
    cp war/pfs.war /wlapps/applications/PFS/
fi
if [ -f war/MicroStrategy.war ]; then
    cp war/MicroStrategy.war /wlapps/applications/MS/
fi

cd $LOCAL_PATH
