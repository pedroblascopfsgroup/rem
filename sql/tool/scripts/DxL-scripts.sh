#!/bin/bash
#
# Ejecución de scripts de los esquemas de operacional con los usuarios propietarios: master y entidad.
#

if [ "$#" -ne 2 ]; then
    echo "Es necesario indicar las contraseñas de cada uno de los usuarios seguidas de @host:port/sid, es decir:"
    echo "Parametros: master_pass@host:port/sid #ENTITY#"
    exit
fi

