#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT CARGA DD LETRADOS PROCURADORES $0"
echo "########################################################"
echo "#####    INICIO CMREC-1797_Carga_DD_Letrados_procuradores.sql"
echo "########################################################"
echo "Inicio CMREC-1797_Carga_DD_Letrados_procuradores.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CMREC-1797_Carga_DD_Letrados_procuradores.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"CMREC-1797_Carga_DD_Letrados_procuradores.sql
   exit 1
fi


echo "Fin CMREC-1797_Carga_DD_Letrados_procuradores. Revise el fichero de log"
exit 0
