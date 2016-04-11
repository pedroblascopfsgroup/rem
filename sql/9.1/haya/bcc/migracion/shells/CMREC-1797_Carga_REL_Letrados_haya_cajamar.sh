#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT CARGA REL LETRADOS HAYA_CAJAMAR $0"
echo "########################################################"
echo "#####    INICIO CMREC-1797_Carga_REL_Letrados_haya_cajamar.sql"
echo "########################################################"
echo "Inicio CMREC-1797_Carga_REL_Letrados_haya_cajamar.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CMREC-1797_Carga_REL_Letrados_haya_cajamar.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"CMREC-1797_Carga_REL_Letrados_haya_cajamar.sql
   exit 1
fi


echo "Fin CMREC-1797_Carga_REL_Letrados_haya_cajamar. Revise el fichero de log"
exit 0
