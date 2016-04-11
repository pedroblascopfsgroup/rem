#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT CMREC_1449_ARREGLA_LETRADOS_y_PROCURADORES.sh $0" 
echo "########################################################"  
echo "#####    INICIO CMREC_1449_ARREGLA_LETRADOS_y_PROCURADORES.sql"  
echo "########################################################"  
echo "Inicio CMREC_1449_ARREGLA_LETRADOS_y_PROCURADORES.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CMREC_1449_ARREGLA_LETRADOS_y_PROCURADORES.sql  

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"CMREC_1449_ARREGLA_LETRADOS_y_PROCURADORES.sql
   exit 1
fi

echo "Fin CMREC_1449_ARREGLA_LETRADOS_y_PROCURADORES.sql. Revise el fichero de log"
exit 0

