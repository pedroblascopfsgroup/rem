#!/bin/bash

DIR_SHELLS=/recovery/batch-server/shells

BASE_DIR=`dirname $0`
while read line; do
    SHELL=`echo $line | sed -e 's/ //g'`
    source $DIR_SHELLS/setBatchEnv.sh
    echo "## Running: "$line
    $DIR_SHELLS/$line $2 > $BASE_DIR/../log/$SHELL.log 2> $BASE_DIR/../log/$SHELL.error
    if [ $? != 0 ]; then
        echo "## Failed: " $line
        exit 1
    else
        echo "## Success: " $line
    fi
done < ./lists/$1
