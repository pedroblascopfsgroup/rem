#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT CARACTERIZACION DE VALIDADORES $0" 
echo "########################################################"  
echo "#####    INICIO CJM_migracion_caracteriza_validadores.sql"  
echo "########################################################"  
echo "Inicio CJM_migracion_caracteriza_validadores.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_carterizacion_validadores.sql

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_carterizacion_validadores.sql
   exit 1
fi

echo "Fin CJM_migracion_caracteriza_validadores.sql. Revise el fichero de log"
exit 0
