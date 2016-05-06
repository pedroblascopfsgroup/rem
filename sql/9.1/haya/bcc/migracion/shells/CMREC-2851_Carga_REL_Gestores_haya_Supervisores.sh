#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT CARTERIZACIÓN GESTORES PRECONTENCIOSO $0"
echo "########################################################"
echo "#####    INICIO CMREC-2851_Carga_REL_Gestores_haya_Supervisores.sql"
echo "########################################################"
echo "Inicio CMREC-2851_Carga_REL_Gestores_haya_Supervisores.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CMREC-2851_Carga_REL_Gestores_haya_Supervisores.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"CMREC-2851_Carga_REL_Gestores_haya_Supervisores.sql
   exit 1
fi


echo "Fin CMREC-2851_Carga_REL_Gestores_haya_Supervisores. Revise el fichero de log"
exit 0
