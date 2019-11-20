#!/bin/bash

ENTITY_CODE=0240
QUEUE_DIR_OUTPUT=/recovery/haya/transferencia/integration/messages/output
QUEUE_NAME=para.cajamar.ENTORNO

DAY=$(date +%d)
MONTH=$(date +%m)
YEAR=$(date +%Y)

if [ ! -d $QUEUE_DIR_OUTPUT/$QUEUE_NAME/error ]; then
    echo "[INFO] $QUEUE_DIR_OUTPUT/$QUEUE_NAME/error not exists"
    exit 0
fi

echo "[INFO] Revisando $QUEUE_DIR_OUTPUT/$QUEUE_NAME/error ..."
cd $QUEUE_DIR_OUTPUT/$QUEUE_NAME/error
for dir_error in `ls -tr`
do
    mv $QUEUE_DIR_OUTPUT/$QUEUE_NAME/error/$dir_error/* $QUEUE_DIR_OUTPUT/$QUEUE_NAME/
    rmdir $QUEUE_DIR_OUTPUT/$QUEUE_NAME/error/$dir_error
    echo "[INFO] Movido contenido de directorio $dir_error"
done
echo "[INFO] Finalizada revisión."
