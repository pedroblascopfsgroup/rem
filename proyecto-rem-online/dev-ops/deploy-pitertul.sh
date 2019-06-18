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

function asignar_grants() {

	if [ "$ENTORNO" == "val03" ]; then 
		source ~/.bash_profile
		
		echo "Llamando a... ${FUNCNAME[0]}"
		echo "begin
		systempfs.refresh_grants_rem;
		end;
		/
		exit" > grants.sql
		header "Asignando GRANTS [$ENTORNO - $DB_PRODUCTO]..."
		source ~/PITERTUL-config.sh
 		sqlplus SYSTEMPFS/$PW_SYSTEMPFS @grants.sql
		header "GRANTS asignados en [$ENTORNO] !!"
	else
		echo "Llamando a... ${FUNCNAME[0]}"
		echo "begin
		systempfs.refresh_grants_rem;
		end;
		/
		exit" > grants.sql
		header "Asignando GRANTS [$ENTORNO - $DB_PRODUCTO]..."
 		sqlplus SYSTEMPFS/$PW_SYSTEMPFS@${DB_PRODUCTO} @grants.sql
		header "GRANTS asignados en [$ENTORNO] !!"
	fi
}

function deployScripts() {
	TIPO_SCRIPT=$1

	echo "Llamando a... ${FUNCNAME[0]} (${RUN_SCRIPT})"

	if [ "$PW_MASTER" == "" ] || [ "$PW_ENTITY01" == "" ]; then
		echo "ERROR: Es necesario proporcionar estos parámetros a $0:"
		echo "  Pmaster, Pentity01"
		exit 1
	fi

	if [ "$ENTORNO" == "val03" ]; then
		source ~/.bash_profile

		header "Desplegando entorno [$ENTORNO - $DB_PRODUCTO] ..."
		sed -e "s/| tee output.log//g" -i ${TIPO_SCRIPT}-scripts.sh

		~/PITERTUL-run.sh ${TIPO_SCRIPT}-scripts.sh

		resultado=$?

		if [ $resultado -ne 0 ]; then exit $resultado; fi
		header "Entorno [$ENTORNO - $DB_PRODUCTO] desplegado!"

	else

		header "Desplegando entorno [$ENTORNO - $DB_PRODUCTO] ..."
		sed -e "s/| tee output.log//g" -i ${TIPO_SCRIPT}-scripts.sh
		./${TIPO_SCRIPT}-scripts.sh ${PW_MASTER}@${DB_PRODUCTO} \
					${PW_ENTITY01}@${DB_PRODUCTO}
		resultado=$?
		if [ $resultado -ne 0 ]; then exit $resultado; fi
		header "Entorno [$ENTORNO - $DB_PRODUCTO] desplegado!"
	fi
}

if [ -f ~/.bash_profile ]; then
 source ~/.bash_profile
fi

PW_SYSTEMPFS=`findInputParam Psystempfs $*`
PW_MASTER=`findInputParam Pmaster $*`
PW_ENTITY01=`findInputParam Pentity01 $*`

FLAG_GRANTS=`findInputParam Xgrants $*`
FLAG_APP=`findInputParam Xapp $*`
ENTORNO=`findInputParam entorno $*`

CURRENT_DIR=$(pwd)
if [ -f ~/.bash_profile ];then
	source ~/.bash_profile
fi

if [ "$ENTORNO" == "" ]; then
	echo "ERROR: El parámetro -entorno: es necesario para localizar el fichero de configuración $ENTORNO.cnf!!!"
	echo ""
	exit 1
fi

CONFIG_FILE=$CURRENT_DIR/$ENTORNO.cnf
if [ ! -f $CONFIG_FILE ]; then
	echo "ERROR: Fichero de configuración de entorno: $CONFIG_FILE no encontrado!!!"
	echo ""
	exit 1
fi
cat $CONFIG_FILE
source $CONFIG_FILE

header "Ejecutando deploy.\n\nDB_PRODUCTO:$DB_PRODUCTO\nDB_BI:$DB_BI\nFLAG_GRANTS:$FLAG_GRANTS\nAPP: $FLAG_APP\nCONFIG_FILE: $CONFIG_FILE"

if [ "$FLAG_APP" == "si" ]; then
	header "Ejecutando APP ..."
	if [ ! -d $CURRENT_DIR/app ]; then
		echo "No hay scrips APP !!!!"
	else 
		cd $CURRENT_DIR/app
		deployScripts DB	
	fi
	cd $CURRENT_DIR
fi

if [ "$FLAG_GRANTS" == "si" ]; then
	cd $CURRENT_DIR
	asignar_grants
fi

exit 0
