#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT CARGA LIQUIDACIONES PRECONTENCIOSO $0"
echo "########################################################"
echo "#####    INICIO CMREC_1811_Carga_liquidaciones_precontencioso.sql"
echo "########################################################"
echo "Inicio CMREC_1811_Carga_liquidaciones_precontencioso.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CMREC_1811_Carga_liquidaciones_precontencioso.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"CMREC_1811_Carga_liquidaciones_precontencioso.sql
   exit 1
fi


echo "Fin CMREC_1811_Carga_liquidaciones_precontencioso. Revise el fichero de log"
exit 0
