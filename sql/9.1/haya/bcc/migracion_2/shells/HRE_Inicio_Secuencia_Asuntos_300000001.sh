#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT HRE INICIO SECUENCIA $0"
echo "########################################################"
echo "#####    INICIO HRE_Inicio_Secuencia_Asuntos_300000001.sql"
echo "########################################################"
echo "Inicio HRE_Inicio_Secuencia_Asuntos_300000001.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"HRE_Inicio_Secuencia_Asuntos_300000001.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"HRE_Inicio_Secuencia_Asuntos_300000001.sql
   exit 1
fi


echo "Fin HRE_Inicio_Secuencia_Asuntos_300000001.sql Revise el fichero de log"
exit 0
