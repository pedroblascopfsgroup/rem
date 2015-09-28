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
}

print_banner
echo "En construcción..."
echo ""
exit

clear

if [[ "$#" -ne 1 ]] && [[ "$#" -ne 2 ]]; then
    print_banner
    echo "Uso 1: $0 <numeroPeticion>"
    echo "Uso 2: $0 <numeroPeticion> [BANKIA|HAYA]"
    echo ""
    echo "******************************************************************************************"
    echo "******************************************************************************************"
    exit
fi

if [[ "$2" != "" ]] && [[ "$2" != "BANKIA" ]] && [[ "$2" != "HAYA" ]] ; then
    print_banner
    echo "Uso 1: $0 <numeroPeticion>"
    echo "Uso 2: $0 <numeroPeticion> [BANKIA|HAYA]"
    echo "El segundo parámetro debe tener uno de estos valores: BANKIA o HAYA"
    echo ""
    echo "******************************************************************************************"
    echo "******************************************************************************************"
    exit  
fi

function generar_fichero() {
   numero=$1
   tipo=$2
   nombre=$3
   proyecto=$4

   fichero=$numero-$nombre-$tipo.sh

   echo -e ".\nGenerando $fichero para el proyecto $proyecto"
   $BASEDIR/scripts/create-run-scripts.sh $tipo $proyecto > $BASEDIR/tmp/$fichero
   chmod +x $BASEDIR/tmp/$fichero
   longitud=`cat $BASEDIR/tmp/$fichero | grep ^./ | wc -l`
   if [ $longitud -le 0 ] ; then
      echo "--- Fichero $fichero no generado porque no hay scripts de tipo $tipo"
      #rm tmp/$fichero
   fi

}

print_banner
echo "Comenzando generación de todos los scripts de la petición $1"

BASEDIR=$(dirname $0)

generar_fichero 01 DDL $1 $2
generar_fichero 02 DML $1 $2
generar_fichero 03 Grant $1 $2
generar_fichero 04 DML_PFSRECOVERY $1 $2

echo "Generados todos los scripts de la petición $1 para el proyecto $2"
