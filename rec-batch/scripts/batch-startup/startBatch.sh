#!/bin/bash

cd $(dirname $0)
CURRENT=$(pwd)

if [ -z $BATCH_INSTALL_DIR ]; then
	echo "ERROR: No conozco donde esta el batch"
	exit 2
fi

PID="$(ps aux | grep batch.Main | grep -v grep | head -n 1 | grep $BATCH_USER | awk '{print $2}')"

if [ "x$PID" != "x" ]; then
	echo "PFS-BATCH [Arrancado]"
	exit 0
fi

if [ -x $BATCH_INSTALL_DIR/run.sh ]; then
	BATCH_ON=false
	cd $BATCH_INSTALL_DIR
	rm nohup.out
	nohup ./run.sh >$BATCH_INSTALL_DIR/nohup.out 2>&1 &
	echo -n "PFS-BATCH | "
	while [ $BATCH_ON = false ]; do
	        status=$(cat $BATCH_INSTALL_DIR/nohup.out | grep 'JobExecutor started!')
	        if [ "x$status" != "x" ]; then
	        	status=$(cat $BATCH_INSTALL_DIR/nohup.out | grep 'JobExecutor ignored!')
	        fi
	        if [ "x$status" != "x" ]; then
        	        BATCH_ON=true
	        else
	                echo -n "."
	        fi
	        sleep 2
	done

	echo " | Batch arrancado"


else
	echo "ERROR: El batch no es ejecutable"
	exit 3
fi

