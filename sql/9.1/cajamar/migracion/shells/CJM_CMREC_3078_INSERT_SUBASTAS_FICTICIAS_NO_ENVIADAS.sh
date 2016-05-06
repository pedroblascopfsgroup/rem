#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT MIGRACION SUBASTAS FICTICIAS NO ENVIADAS $0" 
echo "########################################################"  
echo "#####    INICIO CJM_CMREC_3078_INSERT_SUBASTAS_FICTICIAS_NO_ENVIADAS.sql"  
echo "########################################################"  


echo "Inicio CJM_CMREC_3078_INSERT_SUBASTAS_FICTICIAS_NO_ENVIADAS.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_CMREC_3078_INSERT_SUBASTAS_FICTICIAS_NO_ENVIADAS.sql  

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_CMREC_3078_INSERT_SUBASTAS_FICTICIAS_NO_ENVIADAS.sql
   exit 1
fi

echo "Fin CJM_CMREC_3078_INSERT_SUBASTAS_FICTICIAS_NO_ENVIADAS.sql. Revise el fichero de log"
exit 0
