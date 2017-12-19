#!/bin/bash +x
set -e # Para errores

function createDirectory() {
	echo "Llamando a... ${FUNCNAME[0]} ($1)"
	if [ ! -d $1 ]; then
		mkdir -p $1
	fi
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

function header() {
	TEXTO=$1
	echo ""
	echo "**************************************"
	echo -e $TEXTO
	echo "**************************************"
	echo ""
}

function despliegaBatch() {

	echo "Llamando a... ${FUNCNAME[0]}"
    mkdir -p $BASE_DIR_BATCH/programas/etl/config/
    mkdir -p $BASE_DIR_BATCH/shells/

    header "Desplegando BATCH : $BASE_DIR_BATCH/programas/etl/config/  $BASE_DIR_BATCH/shells/"

#    cp $DIR_SRC/batch/devon.properties $BASE_DIR_BATCH ##### NO APLICA EN REM
    cp $DIR_SRC/batch/rem/config.ini $BASE_DIR_BATCH/programas/etl/config/
    cp $DIR_SRC/batch/rem/setBatchEnv.sh $BASE_DIR_BATCH/shells/

    if [ -d $DIR_SRC/batch/rem/xml ]; then
        cp -rf $DIR_SRC/batch/rem/xml $BASE_DIR_BATCH/programas/etl/config/
    fi

}

function despliegaOnline() {
	echo "Llamando a... ${FUNCNAME[0]}"
    mkdir -p $BASE_DIR_APP
    header "Desplegando WEB: $DIR_APP_SERVER"

    cp $DIR_SRC/web/devon.properties $BASE_DIR_APP
}

if [ -f ~/.bash_profile ]; then
 source ~/.bash_profile
fi

# Carga la configuración del entorno.
CURRENT_DIR=$(pwd)
COMPONENTE=config
DIR_SRC=$CURRENT_DIR/$COMPONENTE

APP=`findInputParam componente $*`

if [ "$APP" == ""  ]; then
	echo "Error llamando a $0 Uso correcto:"
	echo "  $0 -[opcion]:valor"
	echo " componente : online | procesos | spring-batch"
	exit 1
fi

CONFIG_FILE=$DIR_SRC/$COMPONENTE.cnf
if [ ! -f $CONFIG_FILE ]; then
	echo "ERROR: Fichero de configuración de ENTORNO: $CONFIG_FILE no encontrado!!!"
	echo ""
	exit 1
fi
cat $CONFIG_FILE
source $CONFIG_FILE

# Si es BATCH, despliega batch.
if [ "$APP" == "procesos" ] || [ "$APP" == "spring-batch" ]; then
    despliegaBatch
fi

# Si es web despliega web.
if [ "$APP" == "online" ]; then
    despliegaOnline
fi

exit 0