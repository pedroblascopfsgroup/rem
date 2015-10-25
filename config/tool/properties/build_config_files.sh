#!/bin/bash

function print_banner() {
    echo "          .--."
    echo "::\'--._,'.::.'._.--'/::::"
    echo "::::.  ' __::__ '  .::::::"
    echo "::::::-:.''..''.:-:::::::: GENERADOR DE CONFIGURACIÓN ESPECÍFICA PARA CLIENTE"
    echo "::::::::\ '--' /::::::::::"
    echo ""
}

if [[ `dirname $0` != './config/tool/properties' ]] ; then
    print_banner
    echo 'NO me ejecutes desde aquí que me electrocuto'
    echo ""
    echo "Uso:"
    echo "      ./config/tool/properties/build_config_files.sh <cliente> <entorno>"
    echo ""
    exit 1
fi

if [ "$#" -lt 2 ]; then
    print_banner
    echo ""
    echo "Uso:"
    echo "      ./config/tool/properties/build_config_files.sh <cliente> <entorno>"
    echo ""
    exit 1
fi 

print_banner
cliente=$1
entorno=$2

mkdir -p config/tmp/batch/$cliente/
mkdir -p config/tmp/web/$cliente/
cp config/batch/${cliente}/devon.properties config/tmp/batch/$cliente/devon.properties
cp config/web/${cliente}/devon.properties config/tmp/web/$cliente/devon.properties

while read line; do
    if [[ $line =~ ^.+=.+$ ]] ; then
        KEY=`echo $line | cut -d= -f1`
        VALUE=`echo $line | cut -d= -f2`
        VALUE=${VALUE//\//\\/}
        sed -e "s/${KEY}/${VALUE}/g" -i config/tmp/batch/${cliente}/devon.properties
        sed -e "s/${KEY}/${VALUE}/g" -i config/tmp/web/${cliente}/devon.properties
    fi 
done < ./config/tool/properties/${cliente}/${entorno}.properties

echo "Ficheros generados:"
echo ""
ls config/tmp/batch/${cliente}/devon.properties
ls config/tmp/web/${cliente}/devon.properties
echo ""
