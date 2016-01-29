#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT EXTRACCION CLAVES SYSGUID $0" 
echo "########################################################"  
echo "#####    INICIO CJM_extrae_SYSGUID_BCC.sql"  
echo "########################################################"  
echo "Inicio CJM_extrae_SYSGUID_BCC.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_extrae_SYSGUID_BCC.sql 

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_extrae_SYSGUID_BCC.sql
   exit 1
fi
echo "Fin CJM_extrae_SYSGUID_BCC.sql. Revise el fichero de log"

echo "Inicio CJM_spool_SYSGUID_BCC.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_spool_SYSGUID_BCC.sql 

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_spool_SYSGUID_BCC.sql
   exit 1
fi

echo "Fin CJM_spool_SYSGUID_BCC.sql. Revise el fichero de log"
exit 0
