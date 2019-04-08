#!/bin/bash
if [ "$#" -ne 1 ] ; then
    echo "Parametros:  <USU/PASS@host:puerto/ORACLE_SID> " 
    exit 1
fi
export NLS_LANG=SPANISH_SPAIN.AL32UTF8
DATE='date +"%Y%m%d"'
Prueba=0
ctl_dir="ctl/"
dat_dir="dat/"
log_dir="log/"
bad_dir="bad/"
sql_dir="sql/"
sh_dir="shells/"
echo "[INFO] INICIO EJECUCION GFM_GENERA_FICHEROS_MIGRACION $0" `date` 
echo "[INFO] ########################################################"  
echo "[INFO] #####    INICIO GFM_GENERA_FICHEROS_MIGRACION.sh"  
echo "[INFO] ########################################################"  

#CREAR TABLA MAPEO      
echo "[INFO] Comienza ejecución de: ""$sh_dir""GFM_GENERA_FICHEROS_MIGRACION_00_CREATE_TABLE_MAPEO.sql"                      
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"GFM_GENERA_FICHEROS_MIGRACION_00_CREATE_TABLE_MAPEO.sql
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"GFM_GENERA_FICHEROS_MIGRACION_00_CREATE_TABLE_MAPEO.sql"
    exit 1           
fi
echo "[OK] ""$sh_dir""GFM_GENERA_FICHEROS_MIGRACION_00_CREATE_TABLE_MAPEO ejecutado correctamente" 

##CARGA FICHERO GFM_MAPEO
echo "Carga fichero CSV"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"GFM_MAPEO.ctl log="$log_dir"GFM_GENERA_FICHEROS_MIGRACION_"$fecha".log bad="$bad_dir"GFM_GENERA_FICHEROS_MIGRACION_"$fecha".bad userid="$1" DIRECT=TRUE data=mapeo.csv
echo "resultado $?"
if [ $? -gt 0 ] ; then 
   echo -e "[ERROR] GFM_GENERA_FICHEROS_MIGRACION "    
fi

#ESTADISTICAS MAPEO
echo "[INFO] Comienza ejecución de: ""$sql_dir""GFM_GENERA_FICHEROS_MIGRACION_02_ESTADISTICAS.sql"                      
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"GFM_GENERA_FICHEROS_MIGRACION_02_ESTADISTICAS.sql 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sql_dir"GFM_GENERA_FICHEROS_MIGRACION_02_ESTADISTICAS.sql"
    exit 1           
fi
echo "[OK] ""$sql_dir""GFM_GENERA_FICHEROS_MIGRACION_02_ESTADISTICAS.sql ejecutado correctamente" 

#CREAR TABLA GFM_TMP_INTERFAZ            
echo "[INFO] Comienza ejecución de: ""$sh_dir""GFM_GENERA_FICHEROS_MIGRACION_01_CREATE_TABLE.sql"                      
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"GFM_GENERA_FICHEROS_MIGRACION_01_CREATE_TABLE.sql
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"GFM_GENERA_FICHEROS_MIGRACION_01_CREATE_TABLE.sql"
    exit 1           
fi
echo "[OK] ""$sh_dir""GFM_GENERA_FICHEROS_MIGRACION_01_CREATE_TABLE ejecutado correctamente" 

exit 0



  
