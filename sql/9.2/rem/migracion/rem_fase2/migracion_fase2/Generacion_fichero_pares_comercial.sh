#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi

sql_dir="post_migracion/"

echo "#################################################################"
echo "#####    INICIO GENERACION FICHERO COMERCIAL ####################"
echo "#################################################################"

$ORACLE_HOME/bin/sqlplus REM01/"$1" @"$sql_dir"DML_3000_REM_SPOOL_GEN_FICHERO_PARES_COMERCIAL.sql



echo "Fin GENERACION FICHERO PARES COMERCIAL. Revise el fichero de log"
exit 0
