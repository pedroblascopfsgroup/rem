#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <haya02_pass@host:puerto/ORACLE_SID>"
    exit
fi

sql_dir="sql/"

echo "INICIO DEL SCRIPT HRE_INSERT_TEV_VALORES_PRECONTENCIOSO $0" 
echo "########################################################"  
echo "#####    INICIO HRE_INSERT_TEV_VALORES_PRECONTENCIOSO.sql"  
echo "########################################################"  

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"HRE_INSERT_TEV_VALORES_PRECONTENCIOSO.sql  
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"HRE_INSERT_TEV_VALORES_PRECONTENCIOSO.sql
   exit 1
fi

echo "Fin HRE_INSERT_TEV_VALORES_PRECONTENCIOSO.sql. Revise el fichero de log"  
exit 0
