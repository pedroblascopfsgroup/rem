#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Parametros: <CM01/CM01_pass@host:puerto/ORACLE_SID> <YYYYMMDD>"
    exit
fi

sql_dir="sql/"

echo "INICIO DEL SCRIPT MIGRACION_A_RECOVERY_PRECONTENCIOSO $0" 
echo "########################################################"  
echo "#####    INICIO MIGRACION_A_RECOVERY_PRECONTENCIOSO.sql"  
echo "########################################################"  

echo "Migración en curso...."

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_MIGRACION_A_RECOVERY_PRECONTENCIOSO.sql  
if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_MIGRACION_A_RECOVERY_PRECONTENCIOSO.sql
   exit 1
fi

echo "Gestores Precontencioso en curso...."

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_Gestores_PREContencioso.sql
if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_Gestores_PREContencioso.sql
   exit 1
fi

echo "Fin CJM_migracion_a_recovery_precontencioso.sh. Revise el fichero de log" 
exit 0
