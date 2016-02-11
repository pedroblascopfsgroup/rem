#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT USUARIOS PROCURADORES $0" 
echo "########################################################"  
echo "#####    INICIO CJM_usuarios_procuradores.sql"  
echo "########################################################"  
echo "Inicio CJM_usuarios_procuradores.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_usuarios_procuradores.sql  

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_usuarios_procuradores.sql
   exit 1
fi

echo "Fin CJM_usuarios_procuradores.sql. Revise el fichero de log"
exit 0

