#!/bin/bash

cd $(dirname $0)

PID="$(ps aux | grep es.capgemini.pfs.batch.Main | grep -v grep | head -n 1 | awk '{print $2}')"

if [ "x$PID" == "x" ]; then
	echo "El batch ya esta paradp"
else
	echo "Parando el batch [PID=$PID]"
	kill -9 $PID
fi

