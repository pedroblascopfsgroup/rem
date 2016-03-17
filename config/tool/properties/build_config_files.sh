#!/bin/bash

function print_banner() {
    echo "          .--."
    echo "::\'--._,'.::.'._.--'/::::"
    echo "::::.  ' __::__ '  .::::::"
    echo "::::::-:.''..''.:-:::::::: GENERADOR DE CONFIGURACIÓN ESPECÍFICA PARA CLIENTE"
    echo "::::::::\ '--' /::::::::::"
    echo ""
}

function print_use() {
    echo ""
    echo "Uso:"
    echo "      ./config/tool/properties/build_config_files.sh <cliente> <entorno>"
    echo ""
    echo "Parámetros:"
    echo "      <entorno>: desa, pre, pro01, pro02, etc."
    echo ""
}

if [[ `dirname $0` != './config/tool/properties' ]] ; then
    print_banner
    echo 'NO me ejecutes desde aquí que me electrocuto'
    print_use
    exit 1
fi

if [ "$#" -lt 2 ]; then
    print_banner
    print_use
    exit 1
fi 

print_banner
cliente=$1
entorno=$2


if [[ ! -f config/batch/${cliente}/devon.properties ]] ; then
    echo ""
    echo "No existe el fichero:" config/batch/${cliente}/devon.properties
    echo ""
    exit 1
fi

if [[ ! -f config/web/${cliente}/devon.properties ]] ; then
    echo ""
    echo "No existe el fichero:" config/web/${cliente}/devon.properties
    echo ""
    exit 1
fi

if [[ ! -f ./config/tool/properties/${cliente}/${entorno}.properties ]] ; then
    echo ""
    echo "No existe el fichero:" ./config/tool/properties/${cliente}/${entorno}.properties
    echo ""
    exit 1
fi

mkdir -p config/tmp/batch/$cliente/
mkdir -p config/tmp/web/$cliente/

cp config/batch/${cliente}/devon.properties config/tmp/batch/$cliente/devon.properties
cp config/batch/${cliente}/config.ini config/tmp/batch/$cliente/config.ini
cp config/web/${cliente}/devon.properties config/tmp/web/$cliente/devon.properties

source ./config/tool/properties/${cliente}/${entorno}.properties

while read line; do
    if [[ $line =~ ^.+=.+$ ]] ; then
        KEY=`echo $line | cut -d= -f1`
        VALUE=${!KEY//\//\\/}
        if [ $cliente == 'bankia' ]; then
            VALUE=${VALUE//:/\\\\:}
        fi
        sed -e "s/${KEY}/${VALUE}/g" -i config/tmp/batch/${cliente}/devon.properties
        sed -e "s/${KEY}/${VALUE}/g" -i config/tmp/batch/${cliente}/config.ini
        sed -e "s/${KEY}/${VALUE}/g" -i config/tmp/web/${cliente}/devon.properties
    fi 
done < ./config/tool/properties/${cliente}/${entorno}.properties

echo "Ficheros generados:"
echo ""
ls config/tmp/batch/${cliente}/devon.properties
ls config/tmp/batch/${cliente}/config.ini
ls config/tmp/web/${cliente}/devon.properties
echo ""
