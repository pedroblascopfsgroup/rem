#!/bin/bash

export BATCH_ON=false

cd $BATCH_INSTALL_DIR


echo "Esperando por el arranque del batch en $BATCH_INSTALL_DIR"

while [ $BATCH_ON = false ]; do
	status=$(cat $BATCH_INSTALL_DIR/nohup.out | grep 'JobExecutor started!')
	if [ "x$status" != "x" ]; then
		BATCH_ON=true
	else
		echo "."
	fi
	sleep 2
done

echo ""
echo "Batch arrancado"
exit 0
