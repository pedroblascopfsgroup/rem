#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT NOMBRE ASUNTO $0"
echo "########################################################"
echo "#####    INICIO CJM_Inclusion_Bur_Doc_otros_estados.sql"
echo "########################################################"
echo "Inicio CJM_Inclusion_Bur_Doc_otros_estados.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_Inclusion_Bur_Doc_otros_estados.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_Inclusion_Bur_Doc_otros_estados.sql
   exit 1
fi


echo "Fin CJM_Inclusion_Bur_Doc_otros_estados. Revise el fichero de log"
exit 0
