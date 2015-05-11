#!/bin/bash

cd $(dirname $0)

if [ ! -f setEnv.sh ]; then
	echo "ERROR: setEnv.sh no existe y no se puede configurar el entorno de ejecucion"
	exit 1
fi

. setEnv.sh

if [ -z $BATCH_INSTALL_DIR ]; then
	echo "ERROR: No conozco donde esta el batch"
	exit 2
fi

if [ -x $BATCH_INSTALL_DIR/run.sh ]; then
	cd $BATCH_INSTALL_DIR
	rm nohup.out
	rm -Rf $LOG_FILE
	nohup ./run.sh > $BATCH_INSTALL_DIR/nohup.out
	cd ..
	./wait4batch.sh
else
	echo "ERROR: El batch no es ejecutable"
	exit 3
fi

