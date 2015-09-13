#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Parametros: master_pass@sid #ENTITY#"
    exit
fi
export NLS_LANG=.AL32UTF8

