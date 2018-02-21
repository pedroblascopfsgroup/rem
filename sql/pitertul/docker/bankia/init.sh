#!/bin/bash
$(pwd)/$(dirname $0)/../common/showbanner.sh
echo ""

PROJECT_BASE=$(pwd)/$(dirname $0)
ENV_FILE=$PROJECT_BASE/setDbDockerEnv.sh
cd $PROJECT_BASE

if [[ ! -f $ENV_FILE ]]; then
	echo "$(basename $0) [ERROR]: $ENV_FILE no se ha encontrado. Debes configurar el proyecto primero."
	exit 1
fi

source $ENV_FILE

GLOBAL_SET_ENV_FILE=~/setEnvGlobal$CLIENTE.sh
if [[ ! -f $GLOBAL_SET_ENV_FILE ]]; then
	echo "$(basename $0) [ERROR]: No se ha encontrado $GLOBAL_SET_ENV_FILE, no puedo continuar"
	exit 1
fi
# Extracción de las variables de setGlobalEnv
source $GLOBAL_SET_ENV_FILE
VARIABLES_SUSTITUCION=`echo -e "${VARIABLES_SUSTITUCION}" | tr -d '[[:space:]]'`
IFS=',' read -a array <<< "$VARIABLES_SUSTITUCION"
for index in "${!array[@]}"
do
    KEY=`echo ${array[index]} | cut -d\; -f1`
    VALUE=`echo ${array[index]} | cut -d\; -f2`
    case $KEY in
    	"#ESQUEMA#" )
			ENTITY_TABLESPACE=$VALUE
			ENTITY_USER=$VALUE
    		;;
    	"#ESQUEMA_MASTER#" )
			MASTER_TABLESPACE=$VALUE
			MASTER_USER=$VALUE
			;;
		"#TABLESPACE_INDEX#" )
			INDEXES_TABLESPACE=$VALUE
    esac
done
# Fin de Extracción de las variables de setGlobalEnv

finit=no


SCRIPTS_DEST=$PROJECT_BASE/SQL-SCRIPTS
TMP_DIR=$PROJECT_BASE/../common/sql-templates

mkdir -p $SCRIPTS_DEST

## Inicialización de tablespaces
tablespaces_file=$SCRIPTS_DEST/tablespaces-scripts.sql
tablespaces_tmpl=$TMP_DIR/tablespaces-scripts.sql
if [[ ! -f $tablespaces_file ]]; then
	if [[ -f $tablespaces_tmpl ]]; then
		if [[ "x$ENTITY_TABLESPACE" == "x" || "x$MASTER_TABLESPACE" == "x" || "x$INDEXES_TABLESPACE" == "x" ]]; then
			echo "$(basename $0) [ERROR]: falta la definición para los tablespaces: ENTITY_TABLESPACE, MASTER_TABLESPACE, INDEXES_TABLESPACE"
			exit 1
		fi
		cp $tablespaces_tmpl $tablespaces_file
		sed -i "s/ENTITY_TABLESPACE/$ENTITY_TABLESPACE/g" $tablespaces_file && \
			sed -i "s/MASTER_TABLESPACE/$MASTER_TABLESPACE/g" $tablespaces_file && \
			sed -i "s/INDEXES_TABLESPACE/$INDEXES_TABLESPACE/g" $tablespaces_file
		if [[ $? -eq 0 ]]; then
			echo "$(basename $0) [INFO]: $tablespaces_file - inicializado"
			finit=si
		else
			echo "$(basename $0) [ERROR]: $tablespaces_tmpl - error al inicializar"
			exit 1
		fi
	else
		echo "$(basename $0) [ERROR]: $tablespaces_tmpl - no existe el fichero"
		exit 1
	fi
else
	echo "$(basename $0) [WARNING]: $tablespaces_file - ya existe, no se va a sobreescribir"
fi

## Inicialización de database passwords
dbpwd_file=$SCRIPTS_DEST/database-passwords.sql
dbpwd_tmpl=$TMP_DIR/database-passwords.sql
if [[ ! -f $dbpwd_file ]]; then
	if [[ -f $dbpwd_tmpl ]]; then
		if [[ "x$ENTITY_USER" == "x" || "x$MASTER_USER" == "x" ]]; then
			echo "$(basename $0) [ERROR]: falta la definición de los usuarios de la BD: ENTITY_USER, MASTER_USER"
			exit 1
		fi
		cp $dbpwd_tmpl $dbpwd_file
		sed -i "s/ENTITY_USER/$ENTITY_USER/g" $dbpwd_file && \
			sed -i "s/MASTER_USER/$MASTER_USER/g" $dbpwd_file 
		if [[ $? -eq 0 ]]; then
			echo "$(basename $0) [INFO]: $dbpwd_file - inicializado"
			finit=si
		else
			echo "$(basename $0) [ERROR]: $dbpwd_tmpl - error al inicializar"
			exit 1
		fi
	else
		echo "$(basename $0) [ERROR]: $dbpwd_tmpl - no existe el fichero"
		exit 1
	fi
else
	echo "$(basename $0) [WARNING]: $dbpwd_file - ya existe, no se va a sobreescribir"
fi

## DML de configuración de ENTIDADCONFIG
dml_file=$SCRIPTS_DEST/dml-entidadconfig-update.sql
dml_tmpl=$TMP_DIR/dml-entidadconfig-update.sql
if [[ ! -f $dml_file ]]; then
	if [[ -f $dml_tmpl ]]; then
		if [[ "x$ENTITY_USER" == "x" || "x$CONTAINER_NAME" == "x" || "x$MASTER_USER" == "x" ]]; then
			echo "$(basename $0) [ERROR]: faltan datos la actualización de ENTIDADCONFIG de los usuarios de la BD: ENTITY_USER, CONTAINER_NAME, MASTER_USER"
			exit 1
		fi
		cp $dml_tmpl $dml_file
		sed -i "s/ENTITY_USER/$ENTITY_USER/g" $dml_file && \
			sed -i "s/CONTAINER_NAME/$CONTAINER_NAME/g" $dml_file  && \
			sed -i "s/MASTER_USER/$MASTER_USER/g" $dml_file
		if [[ $? -eq 0 ]]; then
			echo "$(basename $0) [INFO]: $dml_file - inicializado"
			finit=si
		else
			echo "$(basename $0) [ERROR]: $dml_tmpl - error al inicializar"
			exit 1
		fi
	else
		echo "$(basename $0) [ERROR]: $dml_tmpl - no existe el fichero"
		exit 1
	fi
else
	echo "$(basename $0) [WARNING]: $dml_file - ya existe, no se va a sobreescribir"
fi

## DML de configuración del pase de estadísticas
runstats_file=$SCRIPTS_DEST/run_statistics.sql
runstats_tmpl=$TMP_DIR/run_statistics.sql
if [[ ! -f $runstats_file ]]; then
	if [[ -f $runstats_tmpl ]]; then
		if [[ "x$ENTITY_USER" == "x" || "x$MASTER_USER" == "x" ]]; then
			echo "$(basename $0) [ERROR]: faltan datos para el pase de estadísticas a la BD: ENTITY_USER, MASTER_USER"
			exit 1
		fi
		cp $runstats_tmpl $runstats_file
		sed -i "s/ENTITY_USER/$ENTITY_USER/g" $runstats_file && \
			sed -i "s/MASTER_USER/$MASTER_USER/g" $runstats_file
		if [[ $? -eq 0 ]]; then
			echo "$(basename $0) [INFO]: $runstats_file - inicializado"
			finit=si
		else
			echo "$(basename $0) [ERROR]: $runstats_tmpl - error al inicializar"
			exit 1
		fi
	else
		echo "$(basename $0) [ERROR]: $runstats_tmpl - no existe el fichero"
		exit 1
	fi
else
	echo "$(basename $0) [WARNING]: $runstats_file - ya existe, no se va a sobreescribir"
fi

if [[ "x$finit" == "xsi" ]]; then
	echo ""
	echo "------------------------- ATENCIÓN ----------------------------------"
	echo "Los ficheros anteriores deben revisarse manualmente para verificar si su contenido es"
	echo " correcto y completo."
fi
