#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: CM01_pass@sid (Pintor32@orcl11g en local)"
    exit
fi

#Rutas AMAZON
ctl_dir="../CTL/"
dat_dir="../DAT/"
log_dir="../LOG/"
bad_dir="../BAD/"
sql_dir="../SQL/"
puerto="1521"



export NLS_LANG=SPANISH_SPAIN.AL32UTF8
echo "INICIO DEL SCRIPT MIGRACION_A_TABLA_INTERMEDIA $0" > "$log_dir"$0.log
echo "########################################################"  >> "$log_dir"$0.log
echo "#####    INICIO MIGRACION_A_TABLA_INTERMEDIA.sql"  >> "$log_dir"$0.log
echo "########################################################"  >> "$log_dir"$0.log
echo "Migración en curso...."
$ORACLE_HOME/bin/sqlplus CM01/"$1":"$puerto"/"$ORACLE_SID" @"$sql_dir"SP_MIG_A_TABLA_INTERMEDIA_CM.sql  >> "$log_dir""$0".log
if [ $? != 0 ] ; then echo -e "\n\n======>>> "Error en @"$sql_dir"SP_MIG_A_TABLA_INTERMEDIA_CM.sql >> "$log_dir""$0".log ; exit 1 ; fi
echo "Fin MIGRACION_A_TABLA_INTERMEDIA.sql. Revise el fichero de log" >> "$log_dir"$0.log
exit
