#!/bin/bash
CONTAINER_NAME=$1
FLASHBACK_OPTION=$2

if [[ "x$CONTAINER_NAME" == "x" || "x$FLASHBACK_OPTION" == "x"  ]]; then
	echo "ERROR: No se puede realizar la operación sobre la BD"
	echo "ERROR: Uso: $0 CONTAINER_NAME FLASHBACK_OPTION"
	exit 1
fi

# OUTSIDE DOCKER
if [[ "x$(hostname)" != "x$CONTAINER_NAME" ]]; then
	docker exec $CONTAINER_NAME /setup/flashback.sh $CONTAINER_NAME $FLASHBACK_OPTION
	exit $?
fi

# INSIDE DOCKER
export PATH=$ORACLE_HOME/bin:$PATH
export ORACLE_SID=orcl
case $FLASHBACK_OPTION in
	create)
		sqlplus / as sysdba @/setup/SQL-SCRIPTS/create_restore_point.sql
		;;
	restore)
		sqlplus / as sysdba @/setup/SQL-SCRIPTS/do_restore_point.sql
		rm -Rf /oradata/flash/*
		;;
	confirm)
		sqlplus / as sysdba @/setup/SQL-SCRIPTS/do_confirm_flashback.sql
		rm -Rf /oradata/flash/*
		;;
	*)
		echo "[ERROR] $FLASHBACK_OPTION: No se reconoce la operación"
		exit 1
esac