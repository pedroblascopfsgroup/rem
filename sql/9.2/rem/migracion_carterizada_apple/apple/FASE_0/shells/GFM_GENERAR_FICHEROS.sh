#!/bin/bash

if [ "$#" -ne 3 ] ; then
    echo "Parametros: <REM01/REM01_pass@host:puerto/ORACLE_SID> <fecha_datos YYYYMMDD> <INTERFAZ>" 
    #echo "$1-$1-$3"
    exit 1
fi

echo "[INFO] ########################################################"  
echo "[INFO] #####    GFM_GENERA_FICHEROS_MIGRACION.sh($3)"  
echo "[INFO] ########################################################"  

fecha="$2"

ctl_dir="ctl/"
dat_dir="dat/"
log_dir="log/"
bad_dir="bad/"
sql_dir="sql/"

#Inicializaciones
file_base=$(grep ^$3, mapeo.csv |cut -d ',' -f 3)
ctl_file=$file_base".ctl"
dat_file=$file_base".dat"
pla_file=$file_base".plan"
ddl_file=$(grep ^$3, mapeo.csv |cut -d ',' -f 6)
tabla=$(grep ^$3, mapeo.csv |cut -d ',' -f 4 |cut -d '.' -f 2)

#Comprovaciones
if [ ! -f $ORACLE_HOME/bin/sqlldr ]; then
    echo "[ERROR] No se encuentra SQL Loader. Compruebe la instalación de cliente Oracle y variable de entorno ORACLE_HOME"
    exit 1
fi

#Preparar CSV
if [ -e GFM_GENERA_FICHEROS_MIGRACION.csv ]; then
#Moviendo ficheros dat.
	echo "Moviendo DAT:"
	sed -e 's/\DATE (YYYYMMDD)/DATE/g' GFM_GENERA_FICHEROS_MIGRACION.csv > $dat_dir"GFM_GENERA_FICHEROS_MIGRACION.dat"
	rm GFM_GENERA_FICHEROS_MIGRACION.csv
else
	echo "No existe Archivo CSV"
fi

##CARGA FICHERO GFM_GENERA_FICHEROS_MIGRACION
echo "Carga fichero CSV $3"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"GFM_GENERA_FICHEROS_MIGRACION.ctl log="$log_dir"GFM_GENERA_FICHEROS_MIGRACION_"$fecha".log bad="$bad_dir"GFM_GENERA_FICHEROS_MIGRACION_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"GFM_GENERA_FICHEROS_MIGRACION.dat
echo "resultado $?"
if [ $? -gt 0 ] ; then 
   echo -e "[ERROR] GFM_GENERA_FICHEROS_MIGRACION "    
fi

#ESTADISTICAS
echo "[INFO] Comienza ejecución de: ""$sql_dir""GFM_GENERA_FICHEROS_MIGRACION_02_ESTADISTICAS.sql"                      
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"GFM_GENERA_FICHEROS_MIGRACION_02_ESTADISTICAS.sql 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sql_dir"GFM_GENERA_FICHEROS_MIGRACION_02_ESTADISTICAS.sql"
    exit 1           
fi
echo "[OK] ""$sql_dir""GFM_GENERA_FICHEROS_MIGRACION_02_ESTADISTICAS.sql ejecutado correctamente" 


#PROCESOS#
#DAT
echo "FICHERO DAT{" $file_base"} - ["$dat_file
echo "[INFO] Comienza ejecución de: ""$sql_dir""GFM_GENERA_FICHEROS_MIGRACION_04_GENERA_DAT.sql"                      
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"GFM_GENERA_FICHEROS_MIGRACION_04_GENERA_DAT.sql > ./tempo.dat 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sql_dir"GFM_GENERA_FICHEROS_MIGRACION_04_GENERA_DAT.sql"
    exit 1           
fi

sed ':a;N;$!ba;s/\[SL\]\n//g' tempo.dat > tempo2.dat
grep -r "FILADAT" ./tempo2.dat | sed -e 's/\[FILADAT\]//g'| sed -e 's/\// /g' > $dat_file

rm ./tempo.dat 
rm ./tempo2.dat 

echo "[OK] ""$sql_dir""GFM_GENERA_FICHEROS_MIGRACION_04_GENERA_DAT.sql ejecutado correctamente" 

#CTL
echo "[INFO] Comienza ejecución de: ""$sql_dir""GFM_GENERA_FICHEROS_MIGRACION_05_GENERA_CTL.sql"
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"GFM_GENERA_FICHEROS_MIGRACION_05_GENERA_CTL.sql > ./tempo.ctl 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sql_dir"GFM_GENERA_FICHEROS_MIGRACION_05_GENERA_CTL.sql"
    exit 1           
fi

sed '1,10d' ./tempo.ctl | sed '/Procedimiento PL\/SQL terminado correctamente./d' | sed '/Desconectado de Oracle Database 11g Enter/d' | sed '/With the Partitioning, Automatic Stor/d' | sed '/and Real Application Testing options/d'| sed -e 's/\[MAPEO\]/'$file_base'/g' | sed -e 's/\[TABLA\]/'$tabla'/g' > CTL.ctl

mv CTL.ctl $ctl_file
rm ./tempo.ctl


echo "[OK] ""$sql_dir""GFM_GENERA_FICHEROS_MIGRACION_05_GENERA_CTL.sql ejecutado correctamente" 


#DDL
echo "[INFO] Comienza ejecución de: ""$sql_dir""GFM_GENERA_FICHEROS_MIGRACION_06_GENERA_DDL.sql"
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"GFM_GENERA_FICHEROS_MIGRACION_06_GENERA_DDL.sql > ./tempo.ddl 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sql_dir"GFM_GENERA_FICHEROS_MIGRACION_06_GENERA_DDL.sql"
    exit 1           
fi

sed '1,10d' ./tempo.ddl | sed '/Procedimiento PL\/SQL terminado correctamente./d' | sed '/Desconectado de Oracle Database 11g Enter/d' | sed '/With the Partitioning, Automatic Stor/d' | sed '/and Real Application Testing options/d' | sed -e 's/\[TABLA\]/'$tabla'/g' > DDL.ddl
echo -e 'END; \n / \n EXIT;' >> DDL.ddl


mv DDL.ddl $ddl_file
rm ./tempo.ddl
echo "[OK] ""$sql_dir""GFM_GENERA_FICHEROS_MIGRACION_06_GENERA_DDL.sql ejecutado correctamente" 

#PLAN
echo "FICHERO PLA{" $file_base"} - ["$pla_file
echo "[INFO] Comienza ejecución de: ""$sql_dir""GFM_GENERA_FICHEROS_MIGRACION_07_GENERA_PLA.sql"                      
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"GFM_GENERA_FICHEROS_MIGRACION_07_GENERA_PLA.sql > ./tempo.pla 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sql_dir"GFM_GENERA_FICHEROS_MIGRACION_07_GENERA_PLA.sql"
    exit 1           
fi

sed ':a;N;$!ba;s/\[SL\]\n//g' tempo.pla > tempo2.pla
grep -r "FILADAT" ./tempo2.pla | sed -e 's/\[FILADAT\]//g' > $pla_file

rm ./tempo.pla 
rm ./tempo2.pla 

echo "[OK] ""$sql_dir""GFM_GENERA_FICHEROS_MIGRACION_07_GENERA_PLA.sql ejecutado correctamente" 



exit 0
