#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT Transiciones_automaticas_HAYA02 $0"
echo "########################################################"
echo "#####    INICIO CMREC-2339_Transiciones_automaticas_HAYA02.sql"
echo "########################################################"
echo "Inicio CMREC-2339_Transiciones_automaticas_HAYA02.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CMREC-2339_Transiciones_automaticas_HAYA02.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"CMREC-2339_Transiciones_automaticas_HAYA02.sql
   exit 1
fi


echo "Fin CMREC-2339_Transiciones_automaticas_HAYA02. Revise el fichero de log"
exit 0
