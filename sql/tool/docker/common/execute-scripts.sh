#!/bin/bash

CONTAINER_NAME=$1
DOCKER_INNER_ERROR_LOG=$2
CUSTOM_NLS_LANG=$3


PACKAGE_DIR=/setup/package

if [[ "x$CONTAINER_NAME" == "x" || "x$DOCKER_INNER_ERROR_LOG" == "x"
			|| "x$CUSTOM_NLS_LANG" == "x" ]]; then
	echo "ERROR: No se puede continuar con la ejecución de scripts de la BD"
	echo "ERROR: Uso: $0 CONTAINER_NAME DOCKER_INNER_ERROR_LOG CUSTOM_NLS_LANG"
	exit 1
fi

# OUTSIDE DOCKER
if [[ "x$(hostname)" != "x$CONTAINER_NAME" ]]; then
	docker exec $CONTAINER_NAME /setup/execute-scripts.sh $CONTAINER_NAME $DOCKER_INNER_ERROR_LOG $CUSTOM_NLS_LANG
	exit $?
fi

# INSIDE DOCKER

mkdir -p $(dirname $DOCKER_INNER_ERROR_LOG)
echo "STARTING: $(date)" > $DOCKER_INNER_ERROR_LOG

function log_script_output () {
	if [[ $(ls *.log 2>/dev/null) ]]; then
		for log in $(ls -ltr *.log | awk '{print $9}'); do 
			echo "===============================" &>> $DOCKER_INNER_ERROR_LOG
			echo "$log" &>> $DOCKER_INNER_ERROR_LOG
			echo "===============================" &>> $DOCKER_INNER_ERROR_LOG
			cat $log &>> $DOCKER_INNER_ERROR_LOG
		done
	fi
}

if [[ -d $PACKAGE_DIR ]]; then
	echo "<Docker [$CONTAINER_NAME]>: Ejecutando scripts..."
	export PATH=$PATH:$ORACLE_HOME/bin
	export NLS_LANG=$CUSTOM_NLS_LANG
	echo "export NLS_LANG=$NLS_LANG" >> /home/oracle/.bashrc
	echo "<Docker [$CONTAINER_NAME]>: NLS_LANG=$NLS_LANG"
	if [[ -d $PACKAGE_DIR/DDL ]]; then
		cd $PACKAGE_DIR/DDL
		rm -Rf *.log
		if [[ -f DDL-scripts.sh ]]; then
			./DDL-scripts.sh admin@orcl admin@orcl
			err_code=$?
			log_script_output
			if [[ $err_code -ne 0 ]]; then
				echo "<Docker [$CONTAINER_NAME]>: Abortando por errores"
				exit 1
			fi
		fi
	fi
	if [[ -d $PACKAGE_DIR/DML ]]; then
		cd $PACKAGE_DIR/DML
		rm -Rf *.log
		if [[ -f DML-scripts.sh ]]; then
			./DML-scripts.sh admin@orcl admin@orcl
			err_code=$?
			log_script_output
			if [[ $err_code -ne 0 ]]; then
				echo "<Docker [$CONTAINER_NAME]>: Abortando por errores"
				exit 1
			fi
		fi
	fi
else
	echo "<Docker [$CONTAINER_NAME] ERROR> $PACKAGE_DIR no existe."
	exit 1
fi