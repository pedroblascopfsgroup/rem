#!/bin/bash

ENTITY_CODE=0240
QUEUE_DIR_INPUT=/recovery/transferencia/integration/messages/input
ZIP_DIR_INPUT=/recovery/transferencia/integration/contingency/input
QUEUE_NAME=para.cajamar.ENTORNO

if [ ! -f $ZIP_DIR_INPUT/MESSAGES-$ENTITY_CODE.zip ]; then
    echo "[ERROR] MESSAGES-$ENTITY_CODE.zip not exists in "$ZIP_DIR_INPUT
    exit 1
fi

if [ ! -d $QUEUE_DIR_INPUT/$QUEUE_NAME ]; then
    echo "[ERROR] $QUEUE_DIR_INPUT/$QUEUE_NAME not exists"
    exit 1
fi

unzip -o $ZIP_DIR_INPUT/MESSAGES-$ENTITY_CODE.zip -d $QUEUE_DIR_INPUT/$QUEUE_NAME
