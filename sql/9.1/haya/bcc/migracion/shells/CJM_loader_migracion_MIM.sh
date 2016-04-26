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

echo "[INFO] MIG_EXPEDIENTES_CABECERA"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"expedientes_cabeceraDataLoadMIM.ctl log="$log_dir"MIG_EXPTE_CABECERA_MIM_"$fecha".log bad="$bad_dir"MIG_EXPTE_CABECERA_MIM_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"EXPEDIENTES-CABECERA.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] MIG_EXPEDIENTES_CABECERA"
#   exit 1
fi


echo "PROCEDIMIENTOS-ACTORES"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_actoresDataLoadMIM.ctl log="$log_dir"PROCEDIMIENTOS-ACTORES_MIM_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS-ACTORES_MIM_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"PROCEDIMIENTOS-ACTORES.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] PROCEDIMIENTOS-ACTORES"
#   exit 1
fi


echo "PROCEDIMIENTOS-CABECERA"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_cabeceraDataLoadMIM.ctl log="$log_dir"PROCEDIMIENTOS_CABECERA_MIM_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_CABECERA_MIM_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"PROCEDIMIENTOS-CABECERA.dat  
if [ $? != 0 ] ; then 
   echo -e "[ERROR] PROCEDIMIENTOS-CABECERA"
#   exit 1
fi

echo "PROCEDIMIENTOS-DEMANDADOS"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_demandadosDataLoadMIM.ctl log="$log_dir"PROCEDIMIENTOS_DEMANDADOS_MIM_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_DEMANDADOS_MIM_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"PROCEDIMIENTOS-DEMANDADOS.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] PROCEDIMIENTOS-DEMANDADOS"
#   exit 1
fi


echo "MIG_PROCEDIMIENTOS_OPERACIONES"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_operacionesDataLoadMIM.ctl log="$log_dir"PROCEDIMIENTOS_OPERACIONES_MIM_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_OPERACIONES_MIM_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"PROCEDIMIENTOS-OPERACIONES.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] MIG_PROCEDIMIENTOS_OPERACIONES"
#   exit 1
fi


#echo "MIG_RGE_REL_GESTOR_EXPEDIENTE"
#$ORACLE_HOME/bin/sqlldr control="$ctl_dir"gestores_expedientesDataLoad.ctl log="$log_dir"EXPEDIENTES-GESTORES_"$fecha".log bad="$bad_dir"EXPEDIENTES-GESTORES_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"EXPEDIENTES-GESTORES.dat
#if [ $? != 0 ] ; then 
#   echo -e "[ERROR] MIG_RGE_REL_GESTOR_EXPEDIENTE"
#   exit 1
#fi


#$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_MiG_estadisticas.sql 
#
#if [ $? != 0 ] ; then 
#   echo -e "\n\n======>>> Error en @"$sql_dir"CJM_MiG_estadisticas.sql"
#   exit 1
#fi

echo "Fin de la carga de ficheros en Tablas MIG_. Revise directorio de logs y el directorio /bad."
exit 0
