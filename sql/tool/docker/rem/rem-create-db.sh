#!/bin/bash
export PROJECT_BASE=$(pwd)/$(dirname $0)
source $PROJECT_BASE/setDbDockerEnv.sh

if [[ -z "$DOCKER_DB_DUMPS_DIR" ]]; then
	echo "[ERROR] DOCKER_DB_DUMPS_DIR: variable de entorno no definida."
	exit 1
fi

if [[ -z "$DOCKER_DB_DATA_DIR" ]]; then
	echo "[ERROR] DOCKER_DB_DATA_DIR: variable de entorno no definida."
	exit 1
fi

DUMP_FILE=$DOCKER_DB_DUMPS_DIR/$CURRENT_DUMP_NAME

if [[ ! -f $DUMP_FILE ]]; then
	echo "[ERROR] $DUMP_FILE: no existe el fichero."
	exit 1
fi

chmod go+r $DUMP_FILE

DATA_DIR=$DOCKER_DB_DATA_DIR/$CONTAINER_NAME
ORADATA_DIR=$DATA_DIR/oradata
WORKSPACE_DIR=$DATA_DIR/workspace

if [[ ! -d "$ORADATA_DIR" ]]; then
	mkdir -p $ORADATA_DIR
	mkdir -p $WORKSPACE_DIR

	chmod -R 777 $DATA_DIR

fi

cd $PROJECT_BASE/../common
./run.sh -remove -ignoredmp -impdp=$DUMP_FILE \
		-oradata=$ORADATA_DIR \
		-workspace=$WORKSPACE_DIR $@