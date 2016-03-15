#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT INFORMA TIPO EXPEDIENTE PRECONTENCIOSO $0"
echo "########################################################"
echo "#####    INICIO CMREC_2718_update_tipo_expediente_Precontencioso.sql"
echo "########################################################"
echo "Inicio CMREC_2718_update_tipo_expediente_Precontencioso.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CMREC_2718_update_tipo_expediente_Precontencioso.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"CMREC_2718_update_tipo_expediente_Precontencioso.sql
   exit 1
fi


echo "Fin CMREC_2718_update_tipo_expediente_Precontencioso. Revise el fichero de log"
exit 0
