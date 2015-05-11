#!/bin/bash

cd $(dirname $0)

if [ ! -f setEnv.sh ]; then
	echo "ERROR: setEnv.sh no se encuentra, no se puede configurar el entorno"
	exit 1
fi

. setEnv.sh

PID="$(ps -aux | grep batch.Main | grep -v grep | head -n 1 | grep $BATCH_USER | awk '{print $2}')"

if [ "x$PID" == "x" ]; then
	echo "El batch ya esta paradp"
else
	echo "Parando el batch [PID=$PID]"
	kill -9 $PID
fi

