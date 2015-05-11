#!/bin/bash
if [ "$ORACLE_HOME" == "" ] ; then
    echo "Debe ejecutar este shell desde un usuario que tenga permisos de ejecución de Oracle. Este usuario tiene ORACLE_HOME vacío"
    exit
fi
if [ "$#" -ne 5 ]; then
    echo "Parametros: bankmaster_pass@sid bank01_pass@sid minirec_pass@sid recovery_bankia_dwh@sid recovery_bankia_datastage_pass@sid"
    exit
fi
export NLS_LANG=.AL32UTF8
echo "INICIO DEL SCRIPT DE ACTUALIZACION $0"
echo "########################################################"
echo "####### FICHEROS LOG COMPRIMIDOS EN EL FICHERO "$0.zip
echo "########################################################"
zip -r -q $0.zip *DML*.log batch-2_10_11-pr-SQLs/*DML*.log
