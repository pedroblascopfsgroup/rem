#!/bin/bash

if [ "$#" -ne 2 ] ; then
    echo "Parametros: <CM01/CM01_pass@host:puerto/ORACLE_SID> <fecha_datos YYYYMMDD>" 
    exit 1
fi

echo "#################################################################"
echo "#####    INICIO CJM_RECOVERY-2021_loader_migracion.sh"
echo "#################################################################"


echo "[INFO] Comienzo de la migración."

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

echo -e "\n[INFO] MIGRANDO MIG_EXPEDIENTES_LIQUIDACIONES..."
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"RECOVERY_2021_LIQUIDACIONES.ctl log="$log_dir"RECOVERY_2021_LIQUIDACIONES_"$fecha".log bad="$bad_dir"RECOVERY_2021_LIQUIDACIONES_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"RECOVERY_2021_LIQUIDACIONES.csv
if [ $? != 0 ] ; then 
   echo -e "[ERROR] MIG_EXPEDIENTES_LIQUIDACIONES"    
fi

echo -e "\n[INFO] PASANDO ESTADISTICAS..."
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_RECOVERY-2021_MIG_ESTADISTICAS.sql 
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> Error en @"$sql_dir"CJM_RECOVERY-2021_MIG_ESTADISTICAS.sql"
   exit 1
fi

echo "Fin de la carga de ficheros en MIG_EXPEDIENTES_LIQUIDACIONES. Revise directorio de logs y el directorio /bad."
exit 0
