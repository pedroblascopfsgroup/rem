#!/bin/bash

ENTITY_CODE=0240
QUEUE_DIR_OUTPUT=/recovery/transferencia/integration/messages/output
TMP_DIR=/recovery/transferencia/tmp
QUEUE_NAME=para.haya.ENTORNO

DAY=$(date +%d)
MONTH=$(date +%m)
YEAR=$(date +%Y)

if [ ! -d $QUEUE_DIR_OUTPUT/$QUEUE_NAME ]; then
    echo "[ERROR] $QUEUE_DIR_OUTPUT/$QUEUE_NAME not exists"
    exit 1
fi

# Copy
mkdir -p $TMP_DIR
cp -r $QUEUE_DIR_OUTPUT/$QUEUE_NAME/*.msg $TMP_DIR/
cp -r $QUEUE_DIR_OUTPUT/$QUEUE_NAME/error/**/*.msg $TMP_DIR/

# Logging
mkdir -p $QUEUE_DIR_OUTPUT/$QUEUE_NAME/log/$YEAR/$MONTH/$DAY/manual/
mv $QUEUE_DIR_OUTPUT/$QUEUE_NAME/*.msg $QUEUE_DIR_OUTPUT/$QUEUE_NAME/log/$YEAR/$MONTH/$DAY/manual/
mv $QUEUE_DIR_OUTPUT/$QUEUE_NAME/error/**/*.msg $QUEUE_DIR_OUTPUT/$QUEUE_NAME/log/$YEAR/$MONTH/$DAY/manual/

# Compress
zip -j MESSAGES-$ENTITY_CODE-$YEAR$MONTH$DAY.zip $TMP_DIR/*.msg

# Cleaning
rm -rf $TMP_DIR
rm -rf $QUEUE_DIR_OUTPUT/$QUEUE_NAME/error/*
