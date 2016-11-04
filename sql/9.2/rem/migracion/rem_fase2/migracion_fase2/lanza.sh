#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="PRE_MIGRACION/"

echo "#################################################################"
echo "#####    INICIO CJM_RECOVERY-2021_MIGRACION_LIQUIDACIONES.sql"
echo "#################################################################"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_3101_REM_MIG2_ACT_NOT_EXISTS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_3102_REM_MIG2_OFR_NOT_EXISTS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_3103_REM_MIG2_AGR_NOT_EXISTS.sql


echo "Fin CJM_RECOVERY-2021_MIGRACION_LIQUIDACIONES. Revise el fichero de log"
exit 0
