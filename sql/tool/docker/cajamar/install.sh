#!/bin/bash

CURRENT_DUMP_NAME=$1
STARTING_TAG=$2
CONTAINER_NAME=$3

if [[ "x$CURRENT_DUMP_NAME" == "x" || "x$STARTING_TAG" == "x" || "x$CONTAINER_NAME" == "x" ]]; then
	echo "ERROR: No se puede continuar con la instalación de la BBDD"
	echo "ERROR: Uso: $0 CURRENT_DUMP_NAME STARTING_TAG CONTAINER_NAME"
	exit 1
fi

CONTAINER_SETUP_DIR=/setup
INNER_DUMP_DIRECTORY=/DUMP


# OUTSIDE DOCKER
DUMP_FILE_OUT_DOCKER=DUMP/$CURRENT_DUMP_NAME
if [[ "x$(hostname)" != "x$CONTAINER_NAME" ]]; then
	docker exec -ti $CONTAINER_NAME /setup/install.sh $CURRENT_DUMP_NAME $STARTING_TAG $CONTAINER_NAME
	exit 0
fi

# INSIDE DOCKER
echo "<Docker [$CONTAINER_NAME]>: Instalador de la BBDD de Cajamar"

cd $(pwd)/$(dirname $0)

echo "<Docker [$CONTAINER_NAME]>: Esperando a ORACLE"

while true
do
	if [[ "x$($ORACLE_HOME/bin/lsnrctl status orcl | grep READY)" != "x" ]]; then
		break
	fi
  	echo "<Docker [$CONTAINER_NAME]>: Esperando a que la instancia ORACLE esté disponile, esto puede tardar aproximadamente 1 min"
  	sleep 5
done

while true
do
	if [[ "x$(echo '' | $ORACLE_HOME/bin/sqlplus system/admin@localhost:1521/orcl @/setup/SQL-SCRIPTS/showdbstatus.sql | grep OPEN)" != "x" ]]; then
		break
	fi
  	echo "<Docker [$CONTAINER_NAME]>: Esperando a que la BBDD esté levantada, esto puede tardar unos segundos"
  	sleep 5
done

echo "<Docker [$CONTAINER_NAME]>: BBDD disponible: OK"
DUMP_FILE_PATH=$INNER_DUMP_DIRECTORY/$CURRENT_DUMP_NAME

if [[ -f $DUMP_FILE_PATH  ]]; then
	echo "<Docker [$CONTAINER_NAME]>: Limpiando el contenido de /oradata..."
	rm -f /oradata/*
	echo "<Docker [$CONTAINER_NAME]>: creando tablespaces y directorios..."
	$ORACLE_HOME/bin/sqlplus system/admin@localhost:1521/orcl @/setup/SQL-SCRIPTS/script.sql
	chmod go+rw /oradata/*
	
	echo "<Docker [$CONTAINER_NAME]>: Importando dump de la bbdd.."
	$ORACLE_HOME/bin/impdp system/admin@localhost:1521/orcl DIRECTORY=scripts dumpfile=$CURRENT_DUMP_NAME logfile=SYSTMP:$CURRENT_DUMP_NAME.import.log schemas=CM01,CMMASTER remap_tablespace=BANK01:DRECOVERYONL8M,TEMPORAL:TEMP
	
	echo "<Docker [$CONTAINER_NAME]>: Asignando passwords a usuarios de Cajamar..."
	$ORACLE_HOME/bin/sqlplus system/admin@localhost:1521/orcl @/setup/SQL-SCRIPTS/cmpasswords.sql
	
	echo "<Docker [$CONTAINER_NAME]>: Configurando ENTIDADCONFIG..."
	$ORACLE_HOME/bin/sqlplus system/admin@localhost:1521/orcl @/setup/SQL-SCRIPTS/DML-00-CMMASTER-update.sql

	echo "<Docker [$CONTAINER_NAME]>: Ejecutando scripts..."
	export PATH=$PATH:$ORACLE_HOME/bin
	cd /sql-package/DDL
	./DDL-scripts.sh admin@orcl admin@orcl
	cd /sql-package/DML
	./DML-scripts.sh admin@orcl admin@orcl
else
	echo "*************************** WARNING *******************************"
	echo "<Docker [$CONTAINER_NAME]>: $DUMP_FILE_PATH: No existe el fichero no se va a importar el DUMP"
	echo "******************************************************************"
fi
