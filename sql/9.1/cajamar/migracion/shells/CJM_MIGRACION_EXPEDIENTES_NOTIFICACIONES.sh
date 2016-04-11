#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT CJM_MIGRACION_EXPEDIENTES_NOTIFICACIONES.sh $0" 
echo "########################################################"  
echo "#####    INICIO CJM_MIGRACION_EXPEDIENTES_NOTIFICACIONES.sql"  
echo "########################################################"  
echo "Inicio CJM_MIGRACION_EXPEDIENTES_NOTIFICACIONES.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_MIGRACION_EXPEDIENTES_NOTIFICACIONES.sql  

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_MIGRACION_EXPEDIENTES_NOTIFICACIONES.sql
   exit 1
fi

echo "Fin CJM_MIGRACION_EXPEDIENTES_NOTIFICACIONES.sql. Revise el fichero de log"
exit 0
