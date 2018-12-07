#!/bin/bash

. ./sql/pitertul/commons/configuration.sh

export DESCRIPCION="EMPAQUETO LOS SCRIPTS DE BD DESDE UN LISTADO DE SQLs DETERMINADO \n                   (Tengo en cuenta si soy multientidad)"

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

if [ "$#" -lt 1 ]; then
    print_banner
    print_banner_description "$DESCRIPCION"
    echo "   Uso: $0 CLIENTE"
    echo ""
    echo "Debes tener el listado de scripts con las rutas completas en el fichero SQLs-list.txt"
    echo ""
    echo "Si deseas que incluya .bat, indica lo siguiente en el fichero setEnvGlobal<CLIENTE>.sh:"
    echo ""
    echo "      export GENERATE_BAT='true'"
    echo ""
    echo "******************************************************************************************"
    echo "******************************************************************************************"
    exit
fi

./sql/pitertul/run-scripts-from-tag.sh null $1 null package!
