#!/bin/bash
set -e # Para errores

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

function upload() {
	echo "Llamando a... ${FUNCNAME[0]}"
	SRC_FILE=$DIR_SRC/$COMPONENTE.zip

	if [ ! -f $SRC_FILE ]; then
		echo "ERROR! El fichero $SRC_FILE no existe"
		exit 1
	fi

	ssh -o StrictHostKeyChecking=no $SSH_USER_HOST -p $SSH_PORT "rm -rf ${REMOTE_DIR_DESPLIEGUE}/$COMPONENTE*; mkdir -p ${REMOTE_DIR_DESPLIEGUE}"
	scp -o StrictHostKeyChecking=no -P $SSH_PORT $SRC_FILE $SSH_USER_HOST:${REMOTE_DIR_DESPLIEGUE}
	ssh -o StrictHostKeyChecking=no $SSH_USER_HOST -p $SSH_PORT "cd ${REMOTE_DIR_DESPLIEGUE} ; unzip -o $COMPONENTE.zip"

	if [ "$DEPLOY" == "true" ]; then
		echo "INICIANDO EL DESPLIEGUE DE [$COMPONENTE] ..."
		ssh -o StrictHostKeyChecking=no $SSH_USER_HOST -p $SSH_PORT "cd ${REMOTE_DIR_DESPLIEGUE} ; bash deploy-$COMPONENTE.sh"		
	fi

}

function mensajeError() {
	echo "Error llamando a $0 Uso correcto:"
	echo "  $0 -[opcion]=valor..."
	echo "  host : usuario@host"
	echo "  port : puerto (opcional, valor por defecto 22) "
	echo "  cliente : cliente (haya,cajamar,bankia)"
	echo "  componente : online, batch, procesos, config "
	echo "  src-dir : directorio origen de componente.zip (opcional, valor por defecto directorio actual)  "
	echo "  deploy : true/false indica si se realizará el deploy "
	echo "  custom-dir : Directorio personalizado para varios despliegues simultáneos "
}

SSH_USER_HOST=`findInputParam host $*`
SSH_PORT=`findInputParam port $*`
DIR_SRC=`findInputParam src-dir $*`
CLIENTE=`findInputParam cliente $*`
COMPONENTE=`findInputParam componente $*`
DEPLOY=`findInputParam deploy $*`
CUSTOM_DIR=`findInputParam custom-dir $*`

#variables globales
if [ "$SSH_USER_HOST" == "" ] || [ "$CLIENTE" == "" ] || [ "$COMPONENTE" == "" ]; then
	mensajeError
	exit 1
fi
if [ "$SSH_PORT" == "" ]; then SSH_PORT=22; fi
if [ "$DIR_SRC" == "" ]; then DIR_SRC=.; fi

CURRENT_DIR=$(pwd)
REMOTE_DIR_DESPLIEGUE=deploy/$CLIENTE

if [ "$CUSTOM_DIR" != "" ]; then REMOTE_DIR_DESPLIEGUE=$REMOTE_DIR_DESPLIEGUE/$CUSTOM_DIR; fi

#realiza la acción
upload

exit 0