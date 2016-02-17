#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT MIGRACION RESTO CONTRATOS MARCA HAYA $0"
echo "########################################################"
echo "#####    INICIO CJM_migracion_contratos_HRE_resto.sql"
echo "########################################################"
echo "Inicio CJM_migracion_contratos_HRE_resto.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_migracion_contratos_HRE_resto.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_migracion_contratos_HRE_resto.sql
   exit 1
fi

echo "Asignación de BPMs ...."

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_BMPs_Precontencioso.sql  
if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_BMPs_Precontencioso.sql
   exit 1
fi

echo "Gestores Precontencioso en curso...."

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_Gestores_PREContencioso.sql
if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_Gestores_PREContencioso.sql
   exit 1
fi

echo "Fin CJM_migracion_contratos_HRE_resto. Revise el fichero de log"
exit 0
