#!/bin/bash

if [ "$#" -ne 2 ] ; then
    echo "Parametros: <REM01/REM01_pass@host:puerto/ORACLE_SID> <fecha_datos YYYYMMDD>" 
    exit 1
fi

echo "[INFO] ########################################################"  
echo "[INFO] #####    ASIGNACION_GESTORES_ACTIVO.sh"  
echo "[INFO] ########################################################"  

fecha="$2"

ctl_dir="ctl/"
dat_dir="dat/"
log_dir="log/"
bad_dir="bad/"
sql_dir="sql/"

echo "[INFO] Datos de aprovisionamiento de fecha "$fecha
echo "[INFO] Directorio CTL: "$ctl_dir
echo "[INFO] Directorio DAT: "$dat_dir

if [ ! -f $ORACLE_HOME/bin/sqlldr ]; then
    echo "[ERROR] No se encuentra SQL Loader. Compruebe la instalación de cliente Oracle y variable de entorno ORACLE_HOME"
    exit 1
fi
#CREAR TABLA            
echo "[INFO] Comienza ejecución de: ""$sh_dir""ASIGNACION_GESTORES_ACTIVO_01_CREATE_TABLE.sql"                      
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"ASIGNACION_GESTORES_ACTIVO_01_CREATE_TABLE 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"ASIGNACION_GESTORES_ACTIVO_01_CREATE_TABLE.sql"
    exit 1           
fi
echo "[OK] ""$sh_dir""ASIGNACION_GESTORES_ACTIVO_01_CREATE_TABLE ejecutado correctamente" 

##CARGA FICHERO ASIGNACION_GESTORES_ACTIVO
echo "Carga fichero CSV"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"ASIGNACION_GESTORES_ACTIVO.ctl log="$log_dir"ASIGNACION_GESTORES_ACTIVO_"$fecha".log bad="$bad_dir"ASIGNACION_GESTORES_ACTIVO_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"ASIGNACION_GESTORES_ACTIVO.csv
echo "resultado $?"
if [ $? -gt 0 ] ; then 
   echo -e "[ERROR] ASIGNACION_GESTORES_ACTIVO "    
fi

#ESTADISTICAS
echo "[INFO] Comienza ejecución de: ""$sql_dir""ASIGNACION_GESTORES_ACTIVO_02_ESTADISTICAS.sql"                      
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"ASIGNACION_GESTORES_ACTIVO_02_ESTADISTICAS.sql 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sql_dir"ASIGNACION_GESTORES_ACTIVO_02_ESTADISTICAS.sql"
    exit 1           
fi
echo "[OK] ""$sql_dir""ASIGNACION_GESTORES_ACTIVO_02_ESTADISTICAS.sql ejecutado correctamente" 

#PROCESOS#
#INSERT
echo "[INFO] Comienza ejecución de: ""$sql_dir""ASIGNACION_GESTORES_ACTIVO_03_INSERT.sql"                      
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"ASIGNACION_GESTORES_ACTIVO_03_INSERT.sql
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sql_dir"ASIGNACION_GESTORES_ACTIVO_03_INSERT.sql"
    exit 1           
fi
echo "[OK] ""$sql_dir""ASIGNACION_GESTORES_ACTIVO_03_INSERT.sql ejecutado correctamente" 

exit 0
