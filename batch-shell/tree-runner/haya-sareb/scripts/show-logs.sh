#!/bin/bash

for logfile in `ls ../log/*`; do
    echo "-------------------------------"
    echo $logfile
    cat $logfile
done
