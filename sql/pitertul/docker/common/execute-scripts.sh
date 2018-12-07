#!/bin/bash

CONTAINER_NAME=$1
DOCKER_INNER_ERROR_LOG=$2
CUSTOM_NLS_LANG=$3


PACKAGE_DIR=/setup/package
PACKAGE_TAGS_DIR=/setup/package-tags

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
		echo "<Docker [$CONTAINER_NAME]>: Ejecutando $sh"
		cd $(dirname $sh)
		rm -Rf *.log
		$sh admin@orcl admin@orcl admin@orcl admin@orcl
		err_code=$?
		log_script_output
		if [[ $err_code -ne 0 ]]; then
			echo "<Docker [$CONTAINER_NAME]>: Abortando por errores"
			exit 1
		fi

	done
}

if [[ -d /setup/pre-scripts ]]; then
	echo "<Docker [$CONTAINER_NAME] WARNING> Se han encontrado pre-scripts."
	run_scripts /setup/pre-scripts/*.sh
fi

if [[ -d $PACKAGE_TAGS_DIR ]]; then
	echo "<Docker [$CONTAINER_NAME] WARNING> Se van a ejecutar los scripts DxL por etapas."
	run_scripts $PACKAGE_TAGS_DIR/run-scripts-package.sh
elif [[ -d $PACKAGE_DIR ]]; then
	# Se elimina el zip de los logs, la compresion de los logs solo aplica a produccion
	sed -e 's@^zip --quiet@#zip --quiet@g' -i $PACKAGE_DIR/DB/DB-scripts.sh

	run_scripts $PACKAGE_DIR/DB/DB-scripts.sh
else
	echo "<Docker [$CONTAINER_NAME] ERROR> $PACKAGE_DIR no existe."
	exit 1
fi

if [[ -d /setup/post-scritps ]]; then
	echo "<Docker [$CONTAINER_NAME] WARNING> Se han encontrado post-scripts."
	run_scripts /setup/post-scripts/*.sh
fi
