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

function descomprimeETLs() {
	DIR_SHELLS=$BASE_DIR_BATCH/shells
	DIR_ETLS=$BASE_DIR_BATCH/programas/etl
	DIR_CONTROL_ETL=$BASE_DIR_BATCH/control/etl

	rm -rf $DIR_ETLS/apr_*
	rm -rf $DIR_ETLS/APR_*

	mkdir -p $DIR_SHELLS
	mkdir -p $DIR_SHELLS/ftp
	mkdir -p $DIR_ETLS

	mkdir -p $DIR_CONTROL_ETL/input/error
	mkdir -p $DIR_CONTROL_ETL/input/Logs
	mkdir -p $DIR_CONTROL_ETL/input/convivencia
	mkdir -p $DIR_CONTROL_ETL/input/burofax
	mkdir -p $DIR_CONTROL_ETL/output/error
	mkdir -p $DIR_CONTROL_ETL/output/Logs
	mkdir -p $DIR_CONTROL_ETL/output/convivencia
	mkdir -p $DIR_CONTROL_ETL/output/burofax
	mkdir -p $DIR_CONTROL_ETL/backup/error
	mkdir -p $DIR_CONTROL_ETL/backup/Logs
	mkdir -p $DIR_CONTROL_ETL/backup/convivencia
	mkdir -p $DIR_CONTROL_ETL/backup/burofax

	rm -f $DIR_SHELLS/*.sh
	cp -r $DIR_SRC/shells/* $DIR_SHELLS
	chmod a+rx $DIR_SHELLS/*.sh
	find $DIR_CONTROL_ETL -type d -exec chmod -fR a+rwx {} \;
	
	rm -rf $DIR_ETLS/apr_*
	rm -rf $DIR_ETLS/APR_*
	cp -r $DIR_SRC/etls/* $DIR_ETLS

	cd $DIR_ETLS
	for etl in `ls *.zip`
	do
	    ZIPNAME=`echo ${etl} | cut -d- -f1`
	    mv ${etl} "${ZIPNAME}.zip"
	    unzip -o ${ZIPNAME}.zip
	done
	find $DIR_SHELLS -type d -exec chmod -fR a+rwx {} \;
	rm *.zip
	find $DIR_SHELLS/ftp -name "*.sh" -type f -exec chmod -f a+rx {} \;
}

if [ -f ~/.bash_profile ]; then
 source ~/.bash_profile
fi

# Carga la configuración del entorno.
CURRENT_DIR=$(pwd)
COMPONENTE=procesos
DIR_SRC=$CURRENT_DIR/$COMPONENTE

#QUITADO BASE_DIR=/recovery/haya/app-server

CONFIG_FILE=$DIR_SRC/$COMPONENTE.cnf
if [ ! -f $CONFIG_FILE ]; then
	echo "ERROR: Fichero de configuración de ENTORNO: $CONFIG_FILE no encontrado!!!"
	echo ""
	exit 1
fi
cat $CONFIG_FILE
source $CONFIG_FILE

echo "Inicia despliegue de procesos..."
descomprimeETLs
cd $CURRENT_DIR

echo "Copiando fichero de configuración ..."
if [ -f $CURRENT_DIR/deploy-config.sh ]; then
	chmod +x $CURRENT_DIR/deploy-config.sh
	$CURRENT_DIR/deploy-config.sh -componente:$COMPONENTE
else
	echo "ERROR: Fichero de configuración: $CURRENT_DIR/deploy-config.sh no encontrado!!!"
	echo "Es necesario disponer de la configuración para realizar un despliegue del componente  [$COMPONENTE]"
	echo ""
	exit 1
fi

exit 0