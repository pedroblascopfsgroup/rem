#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Parametros: <CM01/CM01_pass@host:puerto/ORACLE_SID> <YYYYMMDD>"
    exit
fi

sql_dir="sql/"

echo "INICIO DEL SCRIPT MIGRACION_VOLUMETRIA_CARGA $0" 
echo "########################################################"  
echo "#####    INICIO MIGRACION_VOLUMETRIA_CARGA.sql"  
echo "########################################################"  
echo "Migración en curso...."

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_migracion_volumetria_carga.sql  
if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_migracion_volumetria_carga.sql
   exit 1
fi

echo "Fin MIGRACION_VOLUMETRIA_CARGA.sql. Revise el fichero de log" 
exit 0
