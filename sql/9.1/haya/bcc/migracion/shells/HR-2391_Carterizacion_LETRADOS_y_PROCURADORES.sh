#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT CARTERIZACIÓN GESTORES PRECONTENCIOSO $0"
echo "########################################################"
echo "#####    INICIO HR-2391_Carterizacion_LETRADOS_y_PROCURADORES.sql"
echo "########################################################"
echo "Inicio HR-2391_Carterizacion_LETRADOS_y_PROCURADORES.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"HR-2391_Carterizacion_LETRADOS_y_PROCURADORES.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"HR-2391_Carterizacion_LETRADOS_y_PROCURADORES.sql
   exit 1
fi


echo "Fin HR-2391_Carterizacion_LETRADOS_y_PROCURADORES. Revise el fichero de log"
exit 0
