#!/bin/bash
source $(pwd)/$(dirname $0)/setDbDockerEnv.sh

BASE=$HOME/$CONTAINER_NAME
WS_DIR=$BASE/workspace
DATA_DIR=$BASE/oradata
DMP_DIR=$BASE/dumps

if [[ ! -d $WS_DIR ]]; then
	mkdir -p $WS_DIR
	chmod 777 $WS_DIR
fi

if [[ ! -d $DATA_DIR ]]; then
	mkdir -p $DATA_DIR
	chmod 777 $DATA_DIR
fi

if [[ ! -d $DMP_DIR ]]; then
	mkdir -p $DMP_DIR
	chmod 777 $DMP_DIR
fi

./run.sh -remove -statistics -ignoredmp -dmpdir=$DMP_DIR -oradata=$DATA_DIR -workspace=$WS_DIR -errorlog=$BASE/error.log
