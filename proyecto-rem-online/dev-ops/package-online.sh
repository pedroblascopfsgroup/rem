#!/bin/bash +x
set -e # Para errores

function createDirectory() {
	echo "Llamando a... ${FUNCNAME[0]} ($1)"
	if [ "$2" != "n" ] && [ -d $1 ]; then
		rm -rf $1/*
	fi
	mkdir -p $1
}

function findInputParam() {
    SEARCH_STRING="-$1:"
    REGEX_SEARCH_STRING="$SEARCH_STRING*"
    PARAMS=$*
    for var in ${PARAMS}
    do
        if [[ $var = ${REGEX_SEARCH_STRING} ]]; then
            echo $var | sed "s/$SEARCH_STRING//g"
            return
        fi
    done
}

function empaqueta() {
	echo "Llamando a... ${FUNCNAME[0]} ($1)"

	if [ "$1" == "val03" ]; then
		cp rem-web/target/pfs-${version}.war $WORKING_DIR/pfs-rec-web.war
	else
		cp rem-web/target/pfs-${version}.war $WORKING_DIR/pfs.war
	fi
}

function preparaConfigEntorno() {
	echo "Llamando a... ${FUNCNAME[0]}"
	ficheroACopiar=$BASEDIR/config/$entorno
	if [ -f $ficheroACopiar ]; then
		cp $ficheroACopiar $WORKING_DIR/$COMPONENTE.cnf
	else
		echo "ERROR: No existe el fichero de configuración de ENTORNO $ficheroACopiar"
		exit 1
	fi
}

#variables globales
version=`findInputParam version $*`
dir_salida=`findInputParam out-dir $*`
entorno=`findInputParam entorno $*`

if [ "$version" == "" ] || [ "$out-dir" == "" ] || [ "$entorno" == "" ]; then
	echo "Error llamando a $0 Uso correcto:"
	echo "  $0 -[opcion]:valor"
	echo "  version : versión para empaquetar"
	echo "  out-dir : directorio de salida del empaquetado"
	echo "  entorno : producto | pro | pre | inte | val"
	exit 1
fi

BASEDIR=$(dirname "$0")
CURRENT_DIR=$(pwd)
COMPONENTE=online
PACKAGE_DIR=$CURRENT_DIR/.package
WORKING_DIR=$PACKAGE_DIR/$COMPONENTE
OUPUT_FILE=$CURRENT_DIR/$dir_salida/$COMPONENTE.zip

createDirectory $WORKING_DIR
createDirectory $dir_salida n
rm -rf $OUPUT_FILE

empaqueta $entorno
preparaConfigEntorno

echo "Generando empaquetado... $OUPUT_FILE"
cp $BASEDIR/deploy-$COMPONENTE.sh $PACKAGE_DIR
cd $PACKAGE_DIR
zip -r $OUPUT_FILE $COMPONENTE deploy-$COMPONENTE.sh

exit 0;