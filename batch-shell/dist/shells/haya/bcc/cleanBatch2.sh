#!/bin/bash

/usr/bin/sudo -u recbatch /recovery/batch-server/programas/stopBatch.sh
echo "*** Batch detenido"
/usr/bin/sudo -u recbatch /recovery/batch-server/programas/startBatch.sh
if [ $? -ne 0 ] ; then
	echo "*** Fallo al poner en marcha el BATCH. Consultar log."
	exit 1
fi
echo "*** Batch arrancado de nuevo"
exit 0
