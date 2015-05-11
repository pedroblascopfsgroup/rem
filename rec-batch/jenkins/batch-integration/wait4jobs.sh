#!/bin/bash

cd $(dirname $0)

if [ ! -f setEnv.sh ]; then
        echo "ERROR: setEnv.sh no existe y no se puede configurar el entorno de ejecucion"
        exit 1
fi

. setEnv.sh

for arg in $*; do

		while [ -z "$(cat $LOG_FILE | grep "Fin COMPLETED de job \[$arg\]")" ]; do
			if [ ! -z "$(cat $LOG_FILE | grep "Fin FAILED de job \[$arg\]")" ] \
					|| [ ! -z "$(cat $LOG_FILE | grep "Error en la ejecución del Job \[$arg")" ]; 
			then
				echo "ERROR  en el job $arg."
				exit 2
			else
				echo "El job $arg no ha terminado aún, esperando."
				sleep 3
			fi
		done
		
		echo "El job $arg ha finalizado"
done
