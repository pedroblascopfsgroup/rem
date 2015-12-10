#!/bin/bash

CONTAINER_NAME=$1
DOCKER_INNER_ERROR_LOG=$2


PACKAGE_DIR=/setup/package
PACKAGE_TAGS_DIR=/setup/package-tags

if [[ "x$CONTAINER_NAME" == "x" || "x$DOCKER_INNER_ERROR_LOG" == "x" ]]; then
	echo "ERROR: No se puede continuar con la ejecución de scripts de la BD"
	echo "ERROR: Uso: $0 CONTAINER_NAME DOCKER_INNER_ERROR_LOG"
	exit 1
fi

# OUTSIDE DOCKER
if [[ "x$(hostname)" != "x$CONTAINER_NAME" ]]; then
	docker exec $CONTAINER_NAME /setup/execute-scripts.sh $CONTAINER_NAME $DOCKER_INNER_ERROR_LOG
	exit $?
fi

# INSIDE DOCKER

mkdir -p $(dirname $DOCKER_INNER_ERROR_LOG)
echo "STARTING: $(date)" > $DOCKER_INNER_ERROR_LOG

function log_script_output () {
	local c_dir=""
	for d in $(find . -type d | sort); do
		c_dir=$(pwd)
		cd $d
		if [[ $(ls *.log 2>/dev/null) ]]; then
			for log in $(ls -ltr *.log | awk '{print $9}'); do 
				echo "===============================" &>> $DOCKER_INNER_ERROR_LOG
				echo "$log" &>> $DOCKER_INNER_ERROR_LOG
				echo "===============================" &>> $DOCKER_INNER_ERROR_LOG
				cat $log &>> $DOCKER_INNER_ERROR_LOG
			done
		fi
		cd $c_dir
	done
}

##
# - $* scripts to run
function run_scripts() {
	echo "<Docker [$CONTAINER_NAME]>: Ejecutando scripts..."
	export PATH=$PATH:$ORACLE_HOME/bin
	export NLS_LANG=$CUSTOM_NLS_LANG
	echo "export NLS_LANG=$NLS_LANG" >> /home/oracle/.bashrc
	echo "<Docker [$CONTAINER_NAME]>: NLS_LANG=$NLS_LANG"
	for sh in $*; do
		cd $(dirname $sh)
		rm -Rf *.log
		$sh admin@orcl admin@orcl
		err_code=$?
		log_script_output
		if [[ $err_code -ne 0 ]]; then
			echo "<Docker [$CONTAINER_NAME]>: Abortando por errores"
			exit 1
		fi

	done
}

if [[ -d $PACKAGE_TAGS_DIR ]]; then
	echo "<Docker [$CONTAINER_NAME] WARNING> Se van a ejecutar los scripts DxL por etapas."
	run_scripts $PACKAGE_TAGS_DIR/run-scripts-package.sh
elif [[ -d $PACKAGE_DIR ]]; then
	run_scripts $PACKAGE_DIR/DDL/DDL-scripts.sh $PACKAGE_DIR/DML/DML-scripts.sh
else
	echo "<Docker [$CONTAINER_NAME] ERROR> $PACKAGE_DIR no existe."
	exit 1
fi
