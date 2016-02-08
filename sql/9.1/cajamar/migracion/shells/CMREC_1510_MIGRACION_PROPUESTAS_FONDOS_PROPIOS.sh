#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT GESTION ASUNTO POR MARCA HAYA $0"
echo "########################################################"
echo "#####    INICIO CMREC_1510_MIGRACION_PROPUESTAS_FONDOS_PROPIOS.sql"
echo "########################################################"
echo "Inicio CMREC_1510_MIGRACION_PROPUESTAS_FONDOS_PROPIOS.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CMREC_1510_MIGRACION_PROPUESTAS_FONDOS_PROPIOS.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"CMREC_1510_MIGRACION_PROPUESTAS_FONDOS_PROPIOS.sql
   exit 1
fi


echo "Fin CMREC_1510_MIGRACION_PROPUESTAS_FONDOS_PROPIOS. Revise el fichero de log"
exit 0
