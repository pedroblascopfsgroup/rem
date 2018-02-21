#!/bin/bash

function print_banner() {
    echo '******************************************************************************************'
    echo '******************************************************************************************'
    echo ''
    echo '   .-------. .-./`) ,---------.    .----.  .-------. ,---------.   ___    _   .---.'
    echo '   \  _(`)_ \\ .-.`)\          \ .`_ _   \ |  _ _   \\          \.`   |  | |  | ,_|'
    echo '   | (_ o._)|/ `-` \ `--.  ,---`/ ( ` )   `| ( ` )  | `--.  ,--- |   .|  | |,-./  )'
    echo '   |  (_,_) / `-``-`    |   \  . (_ o _)  ||(_ o _) /    |   \   .`  `_  | |\   _  `)'
    echo '   |   |-.-   .---.     :_ _:  |  (_,_)___|| (_,_).  __  :_ _:   |   ( \.-.| > (_)  )'
    echo '   |   |      |   |     (_I_)  |  \   .---.|  |\ \  |  | (_I_)   | (`. _` /|(  .  .-'
    echo '   |   |      |   |    (_(=)_)  \  `--    /|  | \ `-   /(_(=)_)  | (_ (_) _) `- `-`|___'
    echo '   /   )      |   |     (_I_)    \       / |  |  \    /  (_I_)    \ /  . \ /  |        \'
    echo '   `---`      `---`     `---`     ``-..-`  ``-`   ``-`   `---`     ``- `-`    `--------`'
    echo ""
    echo ""
    echo "******************************************************************************************"
    echo "******************************************************************************************"
    echo ""
    echo "              EMPAQUETO LOS SCRIPTS DE BD DESDE UN LISTADO DE SQLs DETERMINADO"
    echo "                          (Tengo en cuenta si soy multientidad ;))"
    echo ""
    echo "******************************************************************************************"
}

clear

if [ "$0" != "./sql/pitertul/$(basename $0)" ]; then
    print_banner
    echo ""
    echo "AUCH!! No me ejecutes desde aquí, por favor, que me electrocuto... sal a la raiz del repositorio RECOVERY y ejecútame como:"
    echo ""
    echo "    ./sql/pitertul/$(basename $0)"
    echo ""
    exit
fi

if [ "$#" -lt 1 ]; then
    print_banner
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
