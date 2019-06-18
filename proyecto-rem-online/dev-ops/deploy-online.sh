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

function stopAppServer() {
	header " DETENIENDO SERVIDOR APLICACIONES ..."
	if [ -f ~/stopAppServer.sh ]; then
		~/stopAppServer.sh ]
	else
		echo "ERROR GRAVE: no existe el script ~/stopAppServer.sh."
		echo "Este script debe existir en el directorio $HOME del usuario y debe PARAR el servidor de aplicaciones"
		echo "Asegurate que tiene permisos de ejecución." 
	fi
}

function startAppServer() {
	header " INICIANDO SERVIDOR APLICACIONES ..."
	if [ -f ~/startAppServer.sh ]; then
		~/startAppServer.sh ]
	else
		echo "ERROR GRAVE: no existe el script ~/startAppServer.sh."
		echo "Este script debe existir en el directorio $HOME del usuario y debe INICIAR el servidor de aplicaciones"
		echo "Asegurate que tiene permisos de ejecución." 
	fi
}

function creaEstructura() {

	if [ ! -e $FILES_TEMPORARYPATH ]; then
	    echo "Creando directorio de ficheros temporales"
	    mkdir -p $FILES_TEMPORARYPATH
	fi 

}

if [ -f ~/.bash_profile ]; then
 source ~/.bash_profile
fi

# Carga la configuración del entorno.
CURRENT_DIR=$(pwd)
COMPONENTE=online
DIR_SRC=$CURRENT_DIR/$COMPONENTE

CONFIG_FILE=$DIR_SRC/$COMPONENTE.cnf
if [ ! -f $CONFIG_FILE ]; then
	echo "ERROR: Fichero de configuración de ENTORNO: $CONFIG_FILE no encontrado!!!"
	echo ""
	exit 1
fi
cat $CONFIG_FILE
source $CONFIG_FILE

echo "Configuración de directorios ..."
FILES_TEMPORARYPATH=$BASE_DIR_APP/pfs/temporaryFiles

creaEstructura

stopAppServer

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

echo "Copiando ficheros WAR ..."
if [ -f $DIR_SRC/pfs.war ]; then
    cp $DIR_SRC/pfs.war $BASE_DIR_APP/
fi

echo "Copiando ficheros WAR ..."
if [ -f $DIR_SRC/pfs-rec-web.war ]; then
    cp $DIR_SRC/pfs-rec-web.war $BASE_DIR_APP/
fi

echo "Copiando Maestro de Unidades ..."
    cp $DIR_SRC/wsdl/pre/* $BASE_DIR_PLANTILLAS

startAppServer

exit 0