#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01/CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi

echo "INICIO DEL SCRIPT MIGRACION_A_RECOVERY $0" 
echo "########################################################"  
echo "#####    INICIO MIGRACION_A_RECOVERY.sql"  
echo "########################################################"  
echo "Inicio MIGRACION_A_RECOVERY_CM.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_MIGRACION_A_RECOVERY.sql  

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_MIGRACION_A_RECOVERY_CM.sql
   exit 1
fi

echo "Fin MIGRACION_A_RECOVERY_CM.sql. Revise el fichero de log"
exit 0
