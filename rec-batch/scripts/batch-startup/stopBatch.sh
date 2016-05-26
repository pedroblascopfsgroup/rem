#!/bin/bash

function getRunnigBatchPID() {
    ps aux | grep appname=batch  | grep -v grep | head -n 1 | awk '{print $2}'
}

cd $(dirname $0)

PID=$(getRunnigBatchPID)
errorCode=false
if [ "x$PID" == "x" ]; then
	echo "El batch ya esta parado"
    exit 0
fi

echo "Parando el batch [PID=$PID]"
kill -9 $PID
PID=$(getRunnigBatchPID)
while [ "x$PID" != "x" ]; do
    errorCode=true
    echo "Parando el batch [PID=$PID]"
    kill -9 $PID
    PID=$(getRunnigBatchPID)
done
if [ $errorCode == true ]; then
    echo "Detenido más de un servicio BATCH"
    exit 1
fi
