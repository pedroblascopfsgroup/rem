#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT LAMINACION TAREAS PENDIENTES EN MIGRACION Y TAREAS PRERENTORIAS $0" 
echo "########################################################"  
echo "#####    CJM_LAMINACION_Y_MIG_TAREAS_PERENTORIAS.sql"
echo "########################################################"  


echo "Inicio CJM_LAMINACION_Y_MIG_TAREAS_PERENTORIAS.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_LAMINACION_Y_MIG_TAREAS_PERENTORIAS.sql

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_LAMINACION_Y_MIG_TAREAS_PERENTORIAS.sql
   exit 1
fi

echo "Fin CJM_LAMINACION_Y_MIG_TAREAS_PERENTORIAS.sql. Revise el fichero de log"
exit 0
