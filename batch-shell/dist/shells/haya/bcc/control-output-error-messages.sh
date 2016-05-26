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

cd $QUEUE_DIR_OUTPUT/$QUEUE_NAME/error
error_files=`find . -type f -cmin -60 -name *.msg > control-msg.tmp`
num_error_files=`cat control-msg.tmp | wc -l`
if [ $num_error_files -eq 0 ]; then
    rm control-msg.tmp
    exit 0
fi
echo "[ERROR] Creados ficheros de error en la última hora:"
cat control-msg.tmp
rm control-msg.tmp
exit 1
