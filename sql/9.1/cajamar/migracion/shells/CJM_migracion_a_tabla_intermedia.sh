#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01/CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi

sql_dir="sql/"

echo "INICIO DEL SCRIPT MIGRACION_A_TABLA_INTERMEDIA $0" 
echo "########################################################"  
echo "#####    INICIO MIGRACION_A_TABLA_INTERMEDIA.sql"  
echo "########################################################"  
echo "Migración en curso...."

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"SP_MIG_A_TABLA_INTERMEDIA.sql  
if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"SP_MIG_A_TABLA_INTERMEDIA.sql
   exit 1
fi

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"INSERTs_en_MIG_MAESTRA_HITOS_SOLO_CAJAMAR.sql  
if [ $? != 0 ] ; then
   echo -e "\n\n======>>> "Error en @"$sql_dir"INSERTs_en_MIG_MAESTRA_HITOS_SOLO_CAJAMAR.sql
   exit 1
fi

echo "Fin MIGRACION_A_TABLA_INTERMEDIA.sql. Revise el fichero de log" 
exit 0
