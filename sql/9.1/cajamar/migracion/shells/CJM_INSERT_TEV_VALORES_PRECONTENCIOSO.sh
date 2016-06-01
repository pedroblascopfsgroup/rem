#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi

sql_dir="sql/"

echo "INICIO DEL SCRIPT CJM_INSERT_TEV_VALORES_PRECONTENCIOSO $0" 
echo "########################################################"  
echo "#####    INICIO CJM_INSERT_TEV_VALORES_PRECONTENCIOSO.sql"  
echo "########################################################"  

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_INSERT_TEV_VALORES_PRECONTENCIOSO.sql  
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_INSERT_TEV_VALORES_PRECONTENCIOSO.sql
   exit 1
fi

echo "Fin CJM_INSERT_TEV_VALORES_PRECONTENCIOSO.sql. Revise el fichero de log"  
exit 0
