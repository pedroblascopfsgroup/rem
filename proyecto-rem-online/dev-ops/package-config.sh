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

function packageConfig() {
	echo "Llamando a... ${FUNCNAME[0]} ($1)"
	cliente=$1
	
	web_dir=$WORKING_DIR/web

	# Limpia el temporal por si hubieran ficheros
	if [ -d config/tmp ]; then 	rm -rf config/tmp; fi
	./config/tool/properties/build_config_files.sh $cliente $entorno
	
	createDirectory $web_dir
	cp -rf config/tmp/web/*/devon.properties $web_dir

	batch_dir=$WORKING_DIR/batch/$cliente
	createDirectory $batch_dir
#	cp config/tmp/batch/*/devon.properties $WORKING_DIR/batch ##### NO APLICA EN REM
	cp config/tmp/batch/$cliente/* $batch_dir

	if [ -d config/batch/$cliente/xml ]; then
		echo "Empaquetamos metadata-QA"
		cp -rf config/batch/$cliente/xml $batch_dir
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

dir_salida=`findInputParam out-dir $*`
entorno=`findInputParam entorno $*`

if [ "$dir_salida" == ""  ] || [ "$entorno" == ""  ]; then
	echo "Error llamando a $0 Uso correcto:"
	echo "  $0 -[opcion]:valor"
	echo " out-dir : directorio de salida donde se generará el empaquetado"
	echo " entorno : producto | inte | pro | ibd03 ...."
	exit 1
fi


BASEDIR=$(dirname "$0")
CURRENT_DIR=$(pwd)
COMPONENTE=config
PACKAGE_DIR=$CURRENT_DIR/.package
WORKING_DIR=$PACKAGE_DIR/$COMPONENTE
OUPUT_FILE=$CURRENT_DIR/$dir_salida/$COMPONENTE.zip

createDirectory $WORKING_DIR
createDirectory $dir_salida n
rm -rf $OUPUT_FILE

packageConfig rem

preparaConfigEntorno

echo "Generando empaquetado... $OUPUT_FILE"
cp $BASEDIR/deploy-$COMPONENTE.sh $PACKAGE_DIR
cd $PACKAGE_DIR
zip -r $OUPUT_FILE $COMPONENTE deploy-$COMPONENTE.sh

exit 0;