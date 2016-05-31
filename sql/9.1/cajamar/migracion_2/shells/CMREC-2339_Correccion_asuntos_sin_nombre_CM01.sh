#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT Correccion_asuntos_sin_nombre_CM01 $0"
echo "########################################################"
echo "#####    INICIO CMREC-2339_Correccion_asuntos_sin_nombre_CM01.sql"
echo "########################################################"
echo "Inicio CMREC-2339_Correccion_asuntos_sin_nombre_CM01.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CMREC-2339_Correccion_asuntos_sin_nombre_CM01.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"CMREC-2339_Correccion_asuntos_sin_nombre_CM01.sql
   exit 1
fi


echo "Fin CMREC-2339_Correccion_asuntos_sin_nombre_CM01. Revise el fichero de log"
exit 0
