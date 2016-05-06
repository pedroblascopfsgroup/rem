#!/bin/bash

if [ -z ${DIR_DESTINO} ]; then
    echo "$(basename $0) Error: DIR_DESTINO no definido. Compruebe invocación previa a setBatchEnv.sh"
    exit 1
fi 
rm -f $DIR_DESTINO*
