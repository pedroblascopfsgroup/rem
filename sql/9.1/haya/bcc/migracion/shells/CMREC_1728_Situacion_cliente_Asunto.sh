#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit 1
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT CMREC_1728_Situacion_cliente_Asunto.sh $0" 
echo "########################################################"  
echo "#####    INICIO CMREC_1728_Situacion_cliente_Asunto.sql"  
echo "########################################################"  
echo "Inicio CMREC_1728_Situacion_cliente_Asunto.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CMREC_1728_Situacion_cliente_Asunto.sql  

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"CMREC_1728_Situacion_cliente_Asunto.sql
   exit 1
fi

echo "Fin CMREC_1728_Situacion_cliente_Asunto.sql. Revise el fichero de log"
exit 0

