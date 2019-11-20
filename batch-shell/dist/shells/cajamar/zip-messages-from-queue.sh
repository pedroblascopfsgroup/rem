#!/bin/bash

ENTITY_CODE=0240
QUEUE_DIR_OUTPUT=/recovery/transferencia/integration/messages/output
ZIP_DIR_OUTPUT=/recovery/transferencia/integration/contingency/output
QUEUE_NAME=para.haya.ENTORNO

DAY=$(date +%d)
MONTH=$(date +%m)
YEAR=$(date +%Y)

if [ ! -d $QUEUE_DIR_OUTPUT/$QUEUE_NAME ]; then
    echo "[ERROR] $QUEUE_DIR_OUTPUT/$QUEUE_NAME not exists"
    exit 1
fi

# Copy
rm -rf $ZIP_DIR_OUTPUT/*
cp -r $QUEUE_DIR_OUTPUT/$QUEUE_NAME/*.msg $ZIP_DIR_OUTPUT/
cp -r $QUEUE_DIR_OUTPUT/$QUEUE_NAME/error/**/*.msg $ZIP_DIR_OUTPUT/

# Logging
mkdir -p $QUEUE_DIR_OUTPUT/$QUEUE_NAME/log/$YEAR/$MONTH/$DAY/manual/
mv $QUEUE_DIR_OUTPUT/$QUEUE_NAME/*.msg $QUEUE_DIR_OUTPUT/$QUEUE_NAME/log/$YEAR/$MONTH/$DAY/manual/
mv $QUEUE_DIR_OUTPUT/$QUEUE_NAME/error/**/*.msg $QUEUE_DIR_OUTPUT/$QUEUE_NAME/log/$YEAR/$MONTH/$DAY/manual/

# Compress
cd $ZIP_DIR_OUTPUT/
zip -j MESSAGES-$ENTITY_CODE.zip *.msg

# Cleaning
rm -rf $QUEUE_DIR_OUTPUT/$QUEUE_NAME/error/*
