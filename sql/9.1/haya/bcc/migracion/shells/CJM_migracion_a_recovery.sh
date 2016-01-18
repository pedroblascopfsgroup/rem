#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT MIGRACION_A_RECOVERY $0" 
echo "########################################################"  
echo "#####    INICIO HRE_MIGRACION_A_RECOVERY.sql"  
echo "########################################################"  
echo "Inicio inserta arquetipos migración.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_MIG_inserta_ARQ_ARQUETIPOS.sql  

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_MIG_inserta_ARQ_ARQUETIPOS.sql
   exit 1
fi
echo "Fin CJM_MIG_inserta_ARQ_ARQUETIPOS.sql. Revise el fichero de log"

echo "Inicio HRE_MIGRACION_A_RECOVERY.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"HRE_MIGRACION_A_RECOVERY.sql  

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"HRE_MIGRACION_A_RECOVERY.sql
   exit 1
fi

echo "Fin HRE_MIGRACION_A_RECOVERY.sql. Revise el fichero de log"
exit 0
