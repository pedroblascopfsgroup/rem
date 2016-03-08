#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <haya02_pass@host:puerto/ORACLE_SID>"
    exit
fi

sql_dir="sql/"

echo "INICIO DEL SCRIPT CJM_Analiza_haya02 $0" 
echo "########################################################"  
echo "#####    INICIO CJM_Analiza_haya02.sql"  
echo "########################################################"  

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_Analiza_haya02.sql  
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_Analiza_haya02.sql
   exit 1
fi

echo "Fin CJM_Analiza_haya02.sql. Revise el fichero de log"  
exit 0
