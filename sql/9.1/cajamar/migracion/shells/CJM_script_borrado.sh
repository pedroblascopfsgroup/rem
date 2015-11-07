#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi

echo "INICIO DEL SCRIPT BORRADO_RECOVERY $0" 
echo "########################################################"  
echo "#####    INICIO BORRADO_RECOVERY.sql"  
echo "########################################################"  

$ORACLE_HOME/bin/sqlplus CM01/"$1" @"$sql_dir"CJM_MIG_Borrado_Recovery.sql  
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_MIG_Borrado_Recovery.sql
   exit 1
fi

echo "Fin BORRADO_RECOVERY.sql. Revise el fichero de log"  
exit 0
