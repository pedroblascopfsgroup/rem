#!/bin/bash
#
# Ejecución de scripts de los esquemas de operacional con los usuarios propietarios: master y entidad.
#

if [ "$#" -ne 2 ]; then
    echo "Parametros: master_pass@sid #ENTITY#"
    exit
fi

