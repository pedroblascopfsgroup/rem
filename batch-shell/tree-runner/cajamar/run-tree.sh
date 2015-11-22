#!/bin/bash

DIR_SHELLS=/recovery/batch-server/shells

#LINEAL
BASE_DIR=`dirname $0`
while read line; do
    SHELL=`echo $line | sed -e 's/ //g'`
    source $DIR_SHELLS/setBatchEnv.sh
    echo "## Running: "$line
    $DIR_SHELLS/$line > $BASE_DIR/log/$SHELL.log
    if [ $? != 0 ]; then
        echo "## Failed: " $line
        exit 1
    fi
done < ./$BASE_DIR/lists/processes-list.txt

#PARALELO
while read line; do
    nohup $BASE_DIR/scripts/run-parallel.sh $BASE_DIR/$line.txt > $BASE_DIR/log/$line.log &
done < ./$BASE_DIR/lists/processes-parallel.txt
