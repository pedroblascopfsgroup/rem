#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="sql/"

echo "INICIO DEL SCRIPT INSERTA TABLA DESDE MIG_CCO A CCO $0"
echo "########################################################"
echo "#####    INICIO DML_002_ENTITY01_PRODUCTO_1806_insert_CCO.sql"
echo "########################################################"
echo "Inicio DML_002_ENTITY01_PRODUCTO_1806_insert_CCO.sql"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_002_ENTITY01_PRODUCTO_1806_insert_CCO.sql

if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"DML_002_ENTITY01_PRODUCTO_1806_insert_CCO.sql
   exit 1
fi


echo "Fin DML_002_ENTITY01_PRODUCTO_1806_insert_CCO. Revise el fichero de log"
exit 0
