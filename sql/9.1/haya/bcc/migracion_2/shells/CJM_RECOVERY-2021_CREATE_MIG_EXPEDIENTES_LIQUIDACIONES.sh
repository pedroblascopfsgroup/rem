#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "###############################################################################"
echo "#####    INICIO CJM_RECOVERY-2021_CREATE_MIG_EXPEDIENTES_LIQUIDACIONES.sql"
echo "###############################################################################"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_RECOVERY-2021_CREATE_MIG_EXPEDIENTES_LIQUIDACIONES.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_RECOVERY-2021_CREATE_MIG_EXPEDIENTES_LIQUIDACIONES.sql
   exit 1
fi


echo "Fin CJM_RECOVERY-2021_CREATE_MIG_EXPEDIENTES_LIQUIDACIONES. Revise el fichero de log"
exit 0
