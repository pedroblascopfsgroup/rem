#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT CJM_instancia_BPMs_concursal.sh $0" 
echo "########################################################"  
echo "#####    INICIO CJM_instancia_BPMs_concursal.sql"  
echo "########################################################"  
echo "Inicio CJM_instancia_BPMs_concursal.sql"


$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_crea_TMP_BPMs_concursal.sql  

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_crea_TMP_BPMs_concursal.sql
   exit 1
fi

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_instancia_BPMs_concursal.sql  

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_instancia_BPMs_concursal.sql
   exit 1
fi

echo "Fin CJM_instancia_BPMs_concursal.sql. Revise el fichero de log"
exit 0
