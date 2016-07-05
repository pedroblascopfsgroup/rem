#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT CARGA PARAM_HITOS_VALORES MIG2 $0"
echo "########################################################"
echo "#####    INICIO DML_MIG2_DATGMN-MIG_PARAM_HITOS_VALORES.sql"
echo "########################################################"
echo "Inicio DML_MIG2_DATGMN-MIG_PARAM_HITOS_VALORES.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_MIG2_DATGMN-MIG_PARAM_HITOS_VALORES.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"DML_MIG2_DATGMN-MIG_PARAM_HITOS_VALORES.sql
   exit 1
fi


echo "Fin DML_MIG2_DATGMN-MIG_PARAM_HITOS_VALORES. Revise el fichero de log"
exit 0
