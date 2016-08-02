#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi

sql_dir="sql/"

echo "INICIO DEL SCRIPT BORRADO RECOVERY CCO $0" 
echo "########################################################"  
echo "#####    INICIO DML_240_ENTITY01_REMIGRACION_VALORES_LANZAMIENTOS_INFORME_S11.sql"  
echo "########################################################"  

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_240_ENTITY01_REMIGRACION_VALORES_LANZAMIENTOS_INFORME_S11.sql  
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"DML_240_ENTITY01_REMIGRACION_VALORES_LANZAMIENTOS_INFORME_S11.sql
   exit 1
fi

echo "Fin DML_240_ENTITY01_REMIGRACION_VALORES_LANZAMIENTOS_INFORME_S11.sql. Revise el fichero de log"  
exit 0
