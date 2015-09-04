#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Parametros: master_pass@sid entity01_pass@sid"
    exit
fi
export NLS_LANG=.AL32UTF8

