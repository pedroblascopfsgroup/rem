#!/bin/bash

if [ "$#" -ne 2 ] ; then
    echo "Parametros: <CM01/CM01_pass@host:puerto/ORACLE_SID> <fecha_datos YYYYMMDD>" 
    exit 1
fi

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

echo "[INFO] TMP_GUID_HRE."
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"CJM_load_SYSGUID_HRE.ctl log="$log_dir"TMP_GUID_HRE_"$fecha".log bad="$bad_dir"TMP_GUID_HRE_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"sysguid_pks_BCC.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] TMP_GUID_HRE."
#   exit 1
fi


echo "Fin de la carga del fichero de traspaso de SYSGUID en la tabla TMP_GUID_HRE. Revise directorio de logs y el directorio /bad."
exit 0
