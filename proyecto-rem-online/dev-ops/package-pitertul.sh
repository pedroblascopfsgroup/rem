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

function moverScriptsAWorkingDir() {
	echo "Llamando a... ${FUNCNAME[0]} ($1)"
	DESTINO=$1
	PITERTUL_PACKAGE=./sql/pitertul/tmp/package/DB
	if [ -d $PITERTUL_PACKAGE ] && [ `ls $PITERTUL_PACKAGE/scripts | wc -l` != "0" ]; then
	    mv $PITERTUL_PACKAGE $WORKING_DIR/$DESTINO
	fi
}

function mensajeError() {
	echo "Error llamando a $0 Uso correcto:"
	echo "  $0 -[opcion]=valor..."
	echo "  tagAnterior : Tag anterior a partir del cual se generan los scripts"
	echo "  out-dir : directorio de salida de los scripts "
	echo "  entornos : bases de datos de entornos donde se desplegará separados por coma, debe tener configuracion en el dir ./config (producto,inte,ibd03,pre,val,pro) "
}

function preparaConfigEntorno() {
	echo "Llamando a... ${FUNCNAME[0]}"
	echo $ENTORNOS | tr ',' '\n' | while read entorno; do
		ficheroACopiar=$BASEDIR/config/$entorno
		if [ -f $ficheroACopiar ]; then
			cp $ficheroACopiar $WORKING_DIR/$entorno.cnf
		else
			echo "ERROR: No existe el fichero de configuración de ENTORNO $ficheroACopiar"
			exit 1
		fi
	done
}

VERSION_ANTERIOR=`findInputParam tagAnterior $*`
DIR_SALIDA=`findInputParam out-dir $*`
ENTORNOS=`findInputParam entornos $*`

#variables globales
if [ "$ENTORNOS" == "" ] || [ "$VERSION_ANTERIOR" == "" ] || [ "$DIR_SALIDA" == "" ]; then
	mensajeError
	exit 1
fi

BASEDIR=$(dirname "$0")
CURRENT_DIR=$(pwd)
COMPONENTE=pitertul
PACKAGE_DIR=$CURRENT_DIR/.package
WORKING_DIR=$PACKAGE_DIR/$COMPONENTE
OUPUT_FILE=$CURRENT_DIR/$DIR_SALIDA/$COMPONENTE.zip

createDirectory $WORKING_DIR
createDirectory $DIR_SALIDA n
rm -rf $OUPUT_FILE

# Cargar variables de entorno como ORACLE_HOME
export ORACLE_HOME="para-package-pitertul"

#Carga el fichero de BD para configurar el deploy
preparaConfigEntorno

cp sql/pitertul/templates/set*.sh .

echo "Empaquetando APP..."
./sql/pitertul/package-scripts-from-tag.sh ${VERSION_ANTERIOR} REEM
moverScriptsAWorkingDir app

#Empaqueta el archivo de deploy
echo "Generando empaquetado... $OUPUT_FILE"
cp $BASEDIR/deploy-$COMPONENTE.sh $WORKING_DIR
cd $PACKAGE_DIR
zip -r $OUPUT_FILE $COMPONENTE/*

exit 0;