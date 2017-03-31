#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi

sql_dir="post_migracion/"

echo "#################################################################"
echo "#####    INICIO GENERACION FICHERO STOCK ####################"
echo "#################################################################"

$ORACLE_HOME/bin/sqlplus REM01/"$1" @"$sql_dir"DML_3001_REM_SPOOL_GEN_FICHERO_PARES_STOCK.sql



echo "Fin GENERACION FICHERO PARES STOCK. Revise el fichero de log"
exit 0
