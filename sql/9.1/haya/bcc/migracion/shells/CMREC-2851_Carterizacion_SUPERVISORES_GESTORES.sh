#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT CARTERIZACIÓN GESTORES PRECONTENCIOSO $0"
echo "########################################################"
echo "#####    INICIO CMREC-2851_Carterizacion_SUPERVISORES_GESTORES.sql"
echo "########################################################"
echo "Inicio CMREC-2851_Carterizacion_SUPERVISORES_GESTORES.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CMREC-2851_Carterizacion_SUPERVISORES_GESTORES.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"CMREC-2851_Carterizacion_SUPERVISORES_GESTORES.sql
   exit 1
fi


echo "Fin CMREC-2851_Carterizacion_SUPERVISORES_GESTORES. Revise el fichero de log"
exit 0
