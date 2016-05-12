#!/bin/bash

ENTITY_CODE=0240
QUEUE_DIR_INPUT=/recovery/transferencia/integration/messages/input
QUEUE_NAME=para.cajamar.ENTORNO

DAY=$(date +%d)
MONTH=$(date +%m)
YEAR=$(date +%Y)

if [ ! -f MESSAGES-$ENTITY_CODE-$YEAR$MONTH$DAY.zip ]; then
    echo "[ERROR] MESSAGES-$ENTITY_CODE-$YEAR$MONTH$DAY.zip not exists in "$(pwd)
    exit 1
fi

if [ ! -d $QUEUE_DIR_INPUT/$QUEUE_NAME ]; then
    echo "[ERROR] $QUEUE_DIR_INPUT/$QUEUE_NAME not exists"
    exit 1
fi

unzip -o MESSAGES-$ENTITY_CODE-$YEAR$MONTH$DAY.zip -d $QUEUE_DIR_INPUT/$QUEUE_NAME
