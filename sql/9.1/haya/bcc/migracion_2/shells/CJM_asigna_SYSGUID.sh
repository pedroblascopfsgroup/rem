#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT ASIGNA CLAVES SYSGUID $0" 
echo "########################################################"  
echo "#####    INICIO CJM_asigna_SYSGUID.sh"  
echo "########################################################"  
echo "Inicio CJM_borra_SYSGUID_HRE.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_borra_SYSGUID_HRE.sql 

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_borra_SYSGUID_HRE.sql
   exit 1
fi
echo "Fin CJM_borra_SYSGUID_HRE.sql. Revise el fichero de log"

echo "Inicio CJM_asigna_SYSGUID_HRE.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_asigna_SYSGUID_HRE.sql 

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_asigna_SYSGUID_HRE.sql
   exit 1
fi
echo "Fin CJM_asigna_SYSGUID_HRE.sql. Revise el fichero de log"

exit 0
