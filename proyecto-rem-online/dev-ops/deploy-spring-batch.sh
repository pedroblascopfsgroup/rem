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

function creaEstructura() {

	mkdir -p $SHELLS
	mkdir -p $DIR_PROGRAMAS

	if [ ! -e $INTEGRATION_MSG_DIR ]; then
	    echo "Creando directorios para mensajería"
	    mkdir -p $INTEGRATION_MSG_DIR
	    chmod -R og+rwx $INTEGRATION_MSG_DIR
	fi

}

if [ -f ~/.bash_profile ]; then
 source ~/.bash_profile
fi

# Carga la configuración del entorno.
CURRENT_DIR=$(pwd)
COMPONENTE=spring-batch
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

echo "Configuración de directorios ..."
INTEGRATION_MSG_DIR=$BASE_DIR_TRANSFERENCIA/integration/messages
SHELLS=$BASE_DIR_BATCH/shells
DIR_PROGRAMAS=$BASE_DIR_BATCH/programas

creaEstructura

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

#chmod -R a+rwx $BASE_DIR/batch/*
cp $DIR_SRC/*.sh $DIR_PROGRAMAS
chmod a+rx $DIR_PROGRAMAS/*.sh

cp $DIR_SRC/jar/batch-shell*.jar $SHELLS/batch-shell.jar

header "Detiene el batch.."
$DIR_PROGRAMAS/stopBatch.sh

header "Descomprime batch ..."
rm -rf $DIR_PROGRAMAS/batch
unzip $DIR_SRC/batch*.zip -d $DIR_PROGRAMAS

# Prepara run para ser ejecutado con menos memoria
sed -e 's/128M/512m/g' -i $DIR_PROGRAMAS/batch/run.sh

sed -i 's:1024:512:g' $DIR_PROGRAMAS/batch/run.sh
sed -i 's:3072:1024:g' $DIR_PROGRAMAS/batch/run.sh

header "Inicia el batch.."
$DIR_PROGRAMAS/startBatch.sh

exit 0