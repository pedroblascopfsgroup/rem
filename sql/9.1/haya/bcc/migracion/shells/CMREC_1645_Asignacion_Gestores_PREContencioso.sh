#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit 1
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT CMREC_1645_Asignacion_Gestores_PREContencioso.sh $0" 
echo "########################################################"  
echo "#####    INICIO CMREC_1645_Asignacion_Gestores_PREContencioso.sql"  
echo "########################################################"  
echo "Inicio CMREC_1645_Asignacion_Gestores_PREContencioso.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CMREC_1645_Asignacion_Gestores_PREContencioso.sql  

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"CMREC_1645_Asignacion_Gestores_PREContencioso.sql
   exit 1
fi

echo "Fin CMREC_1645_Asignacion_Gestores_PREContencioso.sql. Revise el fichero de log"
exit 0

