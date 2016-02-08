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
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"expedientes_cabeceraDataLoad.ctl log="$log_dir"MIG_EXPTE_CABECERA_"$fecha".log bad="$bad_dir"MIG_EXPTE_CABECERA_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"EXPEDIENTES-CABECERA.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] MIG_EXPEDIENTES_CABECERA"
#   exit 1
fi

echo "EXPEDIENTES_CERTIFICADOS_SALDO"   
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"expedientes_certificados_saldosDataLoad.ctl log="$log_dir"EXPEDIENTES-CERTIFICADOS_SALDO_"$fecha".log bad="$bad_dir"EXPEDIENTES_CERTIFICADOS_SALDO_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"EXPEDIENTES-CERTIFICADOS_SALDO.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] EXPEDIENTES_CERTIFICADOS_SALDO"
#   exit 1
fi

echo "EXPEDIENTES-OPERACIONES"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"expedientes_operacionesDataLoad.ctl log="$log_dir"EXPEDIENTES_OPERACIONES_"$fecha".log bad="$bad_dir"EXPEDIENTES_OPERACIONES_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"EXPEDIENTES-OPERACIONES.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] EXPEDIENTES-OPERACIONES"
#   exit 1
fi

echo "EXPEDIENTES-OBSERVACIONES"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"expedientes_observacionesDataLoad.ctl log="$log_dir"EXPEDIENTES_OBSERVACIONES_"$fecha".log bad="$bad_dir"EXPEDIENTES_OBSERVACIONES_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"EXPEDIENTES-OBSERVACIONES.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] EXPEDIENTES-OBSERVACIONES"
#   exit 1
fi

echo "EXPEDIENTES-OBSERVACIONES-TROZOS"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"expedientes_observaciones_trozosDataLoad.ctl log="$log_dir"EXPEDIENTES_OBSERVACIONES_TROZOS"$fecha".log bad="$bad_dir"EXPEDIENTES_OBSERVACIONES_TROZOS"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"OBSERVACIONES-TROZOS.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] EXPEDIENTES-OBSERVACIONES-TROZOS"
#   exit 1
fi


echo "PROCEDIMIENTOS-ACTORES"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_actoresDataLoad.ctl log="$log_dir"PROCEDIMIENTOS-ACTORES_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS-ACTORES_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"PROCEDIMIENTOS-ACTORES.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] PROCEDIMIENTOS-ACTORES"
#   exit 1
fi

echo "PROCEDIMIENTOS-BIENES"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_bienesDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_BIENES_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_BIENES_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"PROCEDIMIENTOS-BIENES.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] PROCEDIMIENTOS-BIENES"
#   exit 1
fi

echo "PROCEDIMIENTOS-CABECERA"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_cabeceraDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_CABECERA_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_CABECERA_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"PROCEDIMIENTOS-CABECERA.dat  
if [ $? != 0 ] ; then 
   echo -e "[ERROR] PROCEDIMIENTOS-CABECERA"
#   exit 1
fi

echo "PROCEDIMIENTOS-DEMANDADOS"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_demandadosDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_DEMANDADOS_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_DEMANDADOS_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"PROCEDIMIENTOS-DEMANDADOS.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] PROCEDIMIENTOS-DEMANDADOS"
#   exit 1
fi

echo "MIG_PROCS_SUBASTAS_LOTES_BIEN"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_subastas_lotes_bienesDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_LOTES_BIENES_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_LOTES_BIENES_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"LOTES-BIENES.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] MIG_PROCS_SUBASTAS_LOTES_BIEN"
#   exit 1
fi

echo "MIG_PROCEDIMIENTOS_OPERACIONES"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_operacionesDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_OPERACIONES_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_OPERACIONES_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"PROCEDIMIENTOS-OPERACIONES.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] MIG_PROCEDIMIENTOS_OPERACIONES"
#   exit 1
fi

echo "PROCEDIMIENTOS-SUBASTAS"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_subastasDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_SUBASTAS_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_SUBASTAS_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"PROCEDIMIENTOS-SUBASTAS.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] PROCEDIMIENTOS-SUBASTAS"
#   exit 1
fi

echo "CONCURSOS-CABECERA"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"concursos_cabeceraDataLoad.ctl log="$log_dir"CONCURSOS_CABECERA_"$fecha".log bad="$bad_dir"CONCURSOS_CABECERA_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"CONCURSOS-CABECERA.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] CONCURSOS-CABECERA"
#   exit 1
fi

echo "CONCURSOS-OPERACIONES"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"concursos_operacionesDataLoad.ctl log="$log_dir"CONCURSOS_OPERACIONES_"$fecha".log bad="$bad_dir"CONCURSOS_OPERACIONES_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"CONCURSOS-OPERACIONES.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] CONCURSOS-OPERACIONES"
#   exit 1
fi

echo "PROCEDIMIENTOS-OBSERVACIONES"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_observacionesDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_OBSERVACIONES_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_OBSERVACIONES_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"PROCEDIMIENTOS-OBSERVACIONES.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] PROCEDIMIENTOS-OBSERVACIONES"
#   exit 1
fi

echo "PROCEDIMIENTOS-OBSERVACIONES-TROZOS"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"observaciones_trozosDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_OBSERVACIONES_TROZOS_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_OBSERVACIONES_TROZOS_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"PROCEDIMIENTOS-OBSER-TROZOS.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] PROCEDIMIENTOS-OBSERVACIONES-TROZOS"
#   exit 1
fi

echo "PROCEDIMIENTOS-SUBASTAS-LOTES"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_subastas_lotesDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_SUBASTAS_LOTES_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_SUBASTAS_LOTES_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"SUBASTAS-LOTES.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] PROCEDIMIENTOS-SUBASTAS-LOTES"
#   exit 1
fi

echo "PROCEDIMIENTOS-SUBASTAS-LOTES-BIEN"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_subastas_lotes_bienesDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_SUBASTAS_LOTES_BIEN_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_SUBASTAS_LOTES_BIEN_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"LOTES-BIENES.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] PROCEDIMIENTOS-SUBASTAS-LOTES-BIEN"
#   exit 1
fi

echo "MIG_PROCEDIMIENTOS_EMBARGOS"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_embargosDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_EMBARGOS_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_EMBARGOS_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"PROCEDIMIENTOS-EMBARGOS.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] MIG_PROCEDIMIENTOS_EMBARGOS"
#   exit 1
fi


echo "MIG_ANOTACIONES"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"anotaciones_expedientes_DataLoad.ctl log="$log_dir"ANOTACIONES_CLIENTES_"$fecha".log bad="$bad_dir"ANOTACIONES_CLIENTES_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"ANOTACIONES-CLIENTES.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] MIG_ANOTACIONES"
#   exit 1
fi

echo "MIG_EXPEDIENTES_NOTIFICACIONES"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"expedientes_notificacionesDataLoad.ctl log="$log_dir"EXPEDIENTES-NOTIFICACIONES_"$fecha".log bad="$bad_dir"EXPEDIENTES-NOTIFICACIONES_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"EXPEDIENTES-NOTIFICACIONES.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] MIG_EXPEDIENTES_NOTIFICACIONES"
#   exit 1
fi


echo "MIG_PROPUESTAS_CABECERA"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"propuestas_cabeceraDataLoad.ctl log="$log_dir"PROPUESTAS-CABECERA_"$fecha".log bad="$bad_dir"PROPUESTAS-CABECERA_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"PROPUESTAS-CABECERA.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] MIG_PROPUESTAS_CABECERA"
#   exit 1
fi


echo "MIG_PROPUESTAS_TERMINO_ACUERDO"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"propuestas_terminos_acuerdosDataLoad.ctl log="$log_dir"PROPUESTAS-TERMINOSACUERDO_"$fecha".log bad="$bad_dir"PROPUESTAS-TERMINOSACUERDO_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"PROPUESTAS-TERMINOSACUERDO.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] MIG_PROPUESTAS_TERMINO_ACUERDO"
#   exit 1
fi


echo "MIG_PROPUESTAS_TERMI_OPERAC"
$ORACLE_HOME/bin/sqlldr control="$ctl_dir"propuestas_terminos_acuerdos_operacionesDataLoad.ctl log="$log_dir"TERMINOS-OPERACIONES_"$fecha".log bad="$bad_dir"TERMINOS-OPERACIONES_"$fecha".bad userid="$1" DIRECT=TRUE data="$dat_dir"TERMINOS-OPERACIONES.dat
if [ $? != 0 ] ; then 
   echo -e "[ERROR] MIG_PROPUESTAS_TERMI_OPERAC"
#   exit 1
fi


$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"CJM_MiG_estadisticas.sql 

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> Error en @"$sql_dir"CJM_MiG_estadisticas.sql"
   exit 1
fi

echo "Fin de la carga de ficheros en Tablas MIG_. Revise directorio de logs y el directorio /bad."
exit 0
