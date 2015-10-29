#!/bin/bash
#
# Ejecución de scripts de los esquemas de operacional con un único usuario que tiene acceso a ambos (master y entidad)
#

if [ "$#" -ne 1 ]; then
    echo "Parametro: user/pass@sid"
    echo "Parametro: user/pass@host:port/sid"
    exit
fi
export NLS_LANG=.AL32UTF8

