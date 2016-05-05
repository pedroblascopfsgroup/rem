#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT INFORMA NOMBRE EXPEDIENTE PCO $0"
echo "########################################################"
echo "#####    INICIO CMREC_1866_update_nombre_expediente_PCO.sql"
echo "########################################################"
echo "Inicio CMREC_1866_update_nombre_expediente_PCO.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CMREC_1866_update_nombre_expediente_PCO.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"CMREC_1866_update_nombre_expediente_PCO.sql
   exit 1
fi


echo "Fin CMREC_1866_update_nombre_expediente_PCO. Revise el fichero de log"
exit 0
