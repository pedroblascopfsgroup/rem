#!/bin/bash

ENTITY_CODE=0240
QUEUE_DIR_OUTPUT=/recovery/transferencia/integration/messages/output
QUEUE_NAME=para.haya

DAY=$(date +%d)
MONTH=$(date +%m)
YEAR=$(date +%Y)

if [ ! -d $QUEUE_DIR_OUTPUT/$QUEUE_NAME ]; then
    echo "[ERROR] $QUEUE_DIR_OUTPUT/$QUEUE_NAME not exists"
    exit 1
fi

zip -j MESSAGES-$ENTITY_CODE-$YEAR$MONTH$DAY.zip $QUEUE_DIR_OUTPUT/$QUEUE_NAME/log/$YEAR/$MONTH/$DAY/*.msg $QUEUE_DIR_OUTPUT/$QUEUE_NAME/error/**/*.msg
