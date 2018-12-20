#!/bin/bash

. ./sql/pitertul/commons/configuration.sh

export DESCRIPCION="EMPAQUETO LOS SCRIPTS DE BD DESDE UN TAG DETERMINADO"

clear

if [ "$0" != "./sql/pitertul/$(basename $0)" ]; then
    print_banner
    print_banner_description "$DESCRIPCION"
    echo ""
    echo "AUCH!! No me ejecutes desde aquí, por favor, que me electrocuto... sal a la raiz del repositorio RECOVERY y ejecútame como:"
    echo ""
    echo "    ./sql/pitertul/$(basename $0)"
    echo ""
    exit
fi

if [ "$#" -lt 3 ]; then
    print_banner
    print_banner_description "$DESCRIPCION"
    echo "   Uso: $0 <tag> CLIENTE nombre_directorio"
    echo ""
    echo "******************************************************************************************"
    echo "******************************************************************************************"
    exit
fi

./sql/pitertul/run-scripts-from-tag.sh $1 $2 $3 package! $*
