#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT carterizacion LETRADOS PROCURADORES $0"
echo "########################################################"
echo "#####    INICIO Producto-1857_Carterizacion_LETRADOS_y_PROCURADORES_MIM.sql"
echo "########################################################"
echo "Inicio Producto-1857_Carterizacion_LETRADOS_y_PROCURADORES_MIM.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"Producto-1857_Carterizacion_LETRADOS_y_PROCURADORES_MIM.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"Producto-1857_Carterizacion_LETRADOS_y_PROCURADORES_MIM.sql
   exit 1
fi


echo "Fin Producto-1857_Carterizacion_LETRADOS_y_PROCURADORES_MIM. Revise el fichero de log"
exit 0
