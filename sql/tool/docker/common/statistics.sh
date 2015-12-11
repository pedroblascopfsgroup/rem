#!/bin/bash
CONTAINER_NAME=$1

if [[ "x$CONTAINER_NAME" == "x"  ]]; then
	echo "ERROR: No se puede continuar con el pase de estadísticas de la BD"
	echo "ERROR: Uso: $0 CONTAINER_NAME"
	exit 1
fi

# OUTSIDE DOCKER
if [[ "x$(hostname)" != "x$CONTAINER_NAME" ]]; then
	docker exec $CONTAINER_NAME /setup/statistics.sh $CONTAINER_NAME
	exit $?
fi

# INSIDE DOCKER
export PATH=$ORACLE_HOME/bin:$PATH
export ORACLE_SID=orcl
sqlplus / as sysdba @/setup/SQL-SCRIPTS/ddl_package_utiles.sql
sqlplus / as sysdba @/setup/SQL-SCRIPTS/run_statistics.sql