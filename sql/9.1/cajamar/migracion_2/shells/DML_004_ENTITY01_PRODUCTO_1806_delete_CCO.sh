#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi

sql_dir="sql/"

echo "INICIO DEL SCRIPT BORRADO RECOVERY CCO $0" 
echo "########################################################"  
echo "#####    INICIO DML_004_ENTITY01_PRODUCTO_1806_delete_CCO.sql"  
echo "########################################################"  

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_004_ENTITY01_PRODUCTO_1806_delete_CCO.sql  
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"DML_004_ENTITY01_PRODUCTO_1806_delete_CCO.sql
   exit 1
fi

echo "Fin DML_004_ENTITY01_PRODUCTO_1806_delete_CCO.sql. Revise el fichero de log"  
exit 0
