#!/bin/bash

if [ -z "$1" ]; then
    echo "Indica la fecha de los ficheros a procesar como parámetro (formato YYYYMMDD)"
    exit 1
fi

DIR_SHELLS=/recovery/batch-server/shells

#LINEAL
BASE_DIR=`dirname $0`
mkdir -p $BASE_DIR/log
while read line; do
    SHELL=`echo $line | sed -e 's/ //g'`
    source $DIR_SHELLS/setBatchEnv.sh
    echo "## Running: "$line
    $DIR_SHELLS/$line $1 > $BASE_DIR/log/$SHELL.log 2> $BASE_DIR/log/$SHELL.error
    if [ $? != 0 ]; then
        echo "## Failed: " $line
        exit 1
    else
        echo "## Success: " $line
    fi
done < ./$BASE_DIR/lists/processes-list.txt

#PARALELO
while read line; do
    nohup $BASE_DIR/scripts/run-parallel.sh $BASE_DIR/$line.txt $1 > $BASE_DIR/log/$line.log 2> $BASE_DIR/log/$line.error &
    sleep 900
done < ./$BASE_DIR/lists/processes-parallel.txt
