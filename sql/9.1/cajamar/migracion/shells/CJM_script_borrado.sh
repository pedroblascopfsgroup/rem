#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: >CM01_pass@host:puerto/ORACLE_SID (Pintor32@localhost:1521/orcl11g en local)>"
    exit
fi

ctl_dir="CTL/"
dat_dir="DAT/"
log_dir="LOG/"
bad_dir="BAD/"
sql_dir="SQL/"

export NLS_LANG=SPANISH_SPAIN.AL32UTF8

echo "INICIO DEL SCRIPT BORRADO_RECOVERY $0" 
echo "########################################################"  
echo "#####    INICIO BORRADO_RECOVERY.sql"  
echo "########################################################"  

$ORACLE_HOME/bin/sqlplus CM01/"$1" @"$sql_dir"CJM_MIG_Borrado_Recovery.sql  

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_MIG_Borrado_Recovery.sql ; 
   exit 1 ; 
fi

echo "Fin BORRADO_RECOVERY.sql. Revise el fichero de log"  
exit
