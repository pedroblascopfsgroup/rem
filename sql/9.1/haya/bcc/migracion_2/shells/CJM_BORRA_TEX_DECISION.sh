#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT $0"
echo "########################################################"
echo "#####    INICIO CJM_BORRA_TEX_DECISION.sql"
echo "########################################################"
echo "Inicio CJM_BORRA_TEX_DECISION.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_BORRA_TEX_DECISION.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_BORRA_TEX_DECISION.sql
   exit 1
fi


echo "Fin CJM_BORRA_TEX_DECISION. Revise el fichero de log"
exit 0
