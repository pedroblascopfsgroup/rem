#!/bin/bash
#
# Ejecución de scripts de los esquemas de operacional con los usuarios propietarios: master y entidad.
#

if [ "$#" -ne 3 ]; then
    echo "Es necesario indicar las contraseñas de cada uno de los usuarios seguidas de @host:port/sid, es decir:"
    echo "parametros: master_pass@sid bank01_pass@host:port/sid minirec_pass@host:port/sid"
    exit
fi

function run_scripts {
