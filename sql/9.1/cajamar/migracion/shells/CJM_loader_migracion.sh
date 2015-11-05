#!/bin/bash

if [ "$#" -ne 2 ] ; then
    echo "Uso $0 <pass_CM01@SID> <fecha_datos YYYYMMDD> "
    exit 1
fi

if [ "$ORACLE_HOME" == "" ] ; then
        export ORACLE_HOME=/opt/app/oracle/product/11.2.0/dbhome_1    
        echo "Se ha establecido el valor de ORACLE_HOME=$ORACLE_HOME"
fi

if [ "$ORACLE_SID" == "" ] ; then
        ORACLE_SID=orcl11g; export ORACLE_SID        
        echo "Se ha establecido el valor de ORACLE_SID=$ORACLE_SID"
fi

export NLS_LANG=SPANISH_SPAIN.WE8ISO8859P1

echo "Se ha establecido la variable de entorno NLS_LANG=SPANISH_SPAIN.WE8ISO8859P1"
echo "Comienzo de la migración."


fecha="$2"

#Rutas AMAZON
ctl_dir="../CTL/"
dat_dir="../DAT/"
log_dir="../LOG/"
bad_dir="../BAD/"
sql_dir="../SQL/"
#puerto="1521"
puerto="1522"

echo "Datos de aprovisionamiento de fecha "$fecha
echo "Directorio CTL: "$ctl_dir
echo "Directorio DAT: "$dat_dir


echo "MIG_EXPEDIENTES_CABECERA"
   $ORACLE_HOME/bin/sqlldr control="$ctl_dir"expedientes_cabeceraDataLoad.ctl log="$log_dir"MIG_EXPTE_CABECERA_"$fecha".log bad="$bad_dir"MIG_EXPTE_CABECERA_"$fecha".bad userid=CM01/"$1":"$puerto"/"$ORACLE_SID" DIRECT=TRUE data="$dat_dir""$fecha"/EXPEDIENTES-CABECERA.dat
echo "EXPEDIENTES_CERTIFICADOS_SALDO"   
   $ORACLE_HOME/bin/sqlldr control="$ctl_dir"expedientes_certificados_saldosDataLoad.ctl log="$log_dir"EXPEDIENTES-CERTIFICADOS_SALDO_"$fecha".log bad="$bad_dir"EXPEDIENTES_CERTIFICADOS_SALDO_"$fecha".bad userid=CM01/"$1":"$puerto"/"$ORACLE_SID" DIRECT=TRUE data="$dat_dir""$fecha"/EXPEDIENTES-CERTIFICADOS_SALDO.dat
echo "EXPEDIENTES-OPERACIONES"
   $ORACLE_HOME/bin/sqlldr control="$ctl_dir"expedientes_operacionesDataLoad.ctl log="$log_dir"EXPEDIENTES_OPERACIONES_"$fecha".log bad="$bad_dir"EXPEDIENTES_OPERACIONES_"$fecha".bad userid=CM01/"$1":"$puerto"/"$ORACLE_SID" DIRECT=TRUE data="$dat_dir""$fecha"/EXPEDIENTES-OPERACIONES.dat
echo "PROCEDIMIENTOS-ACTORES"
   $ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_actoresDataLoad.ctl log="$log_dir"PROCEDIMIENTOS-ACTORES_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS-ACTORES_"$fecha".bad userid=CM01/"$1":"$puerto"/"$ORACLE_SID" DIRECT=TRUE data="$dat_dir""$fecha"/PROCEDIMIENTOS-ACTORES.dat
echo "PROCEDIMIENTOS-BIENES"
   $ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_bienesDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_BIENES_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_BIENES_"$fecha".bad userid=CM01/"$1":"$puerto"/"$ORACLE_SID" DIRECT=TRUE data="$dat_dir""$fecha"/PROCEDIMIENTOS-BIENES.dat
echo "PROCEDIMIENTOS-CABECERA"
   $ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_cabeceraDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_CABECERA_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_CABECERA_"$fecha".bad userid=CM01/"$1":"$puerto"/"$ORACLE_SID" DIRECT=TRUE data="$dat_dir""$fecha"/PROCEDIMIENTOS-CABECERA.dat  
echo "PROCEDIMIENTOS-DEMANDADOS"
   $ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_demandadosDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_DEMANDADOS_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_DEMANDADOS_"$fecha".bad userid=CM01/"$1":"$puerto"/"$ORACLE_SID" DIRECT=TRUE data="$dat_dir""$fecha"/PROCEDIMIENTOS-DEMANDADOS.dat
echo "MIG_PROCS_SUBASTAS_LOTES_BIEN"
   $ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_subastas_lotes_bienesDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_LOTES_BIENES_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_LOTES_BIENES_"$fecha".bad userid=CM01/"$1":"$puerto"/"$ORACLE_SID" DIRECT=TRUE data="$dat_dir""$fecha"/LOTES-BIENES.dat
echo "MIG_PROCEDIMIENTOS_OPERACIONES"
   $ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_operacionesDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_OPERACIONES_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_OPERACIONES_"$fecha".bad userid=CM01/"$1":"$puerto"/"$ORACLE_SID" DIRECT=TRUE data="$dat_dir""$fecha"/PROCEDIMIENTOS-OPERACIONES.dat
echo "PROCEDIMIENTOS-SUBASTAS"
   $ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_subastasDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_SUBASTAS_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_SUBASTAS_"$fecha".bad userid=CM01/"$1":"$puerto"/"$ORACLE_SID" DIRECT=TRUE data="$dat_dir""$fecha"/PROCEDIMIENTOS-SUBASTAS.dat
echo "CONCURSOS-CABECERA"
   $ORACLE_HOME/bin/sqlldr control="$ctl_dir"concursos_cabeceraDataLoad.ctl log="$log_dir"CONCURSOS_CABECERA_"$fecha".log bad="$bad_dir"CONCURSOS_CABECERA_"$fecha".bad userid=CM01/"$1":"$puerto"/"$ORACLE_SID" DIRECT=TRUE data="$dat_dir""$fecha"/CONCURSOS-CABECERA.dat
echo "CONCURSOS-OPERACIONES"
   $ORACLE_HOME/bin/sqlldr control="$ctl_dir"concursos_operacionesDataLoad.ctl log="$log_dir"CONCURSOS_OPERACIONES_"$fecha".log bad="$bad_dir"CONCURSOS_OPERACIONES_"$fecha".bad userid=CM01/"$1":"$puerto"/"$ORACLE_SID" DIRECT=TRUE data="$dat_dir""$fecha"/CONCURSOS-OPERACIONES.dat
echo "PROCEDIMIENTOS-OBSERVACIONES"
   $ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_observacionesDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_OBSERVACIONES_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_OBSERVACIONES_"$fecha".bad userid=CM01/"$1":"$puerto"/"$ORACLE_SID" DIRECT=TRUE data="$dat_dir""$fecha"/PROCEDIMIENTOS-OBSERVACIONES.dat
echo "PROCEDIMIENTOS-OBSERVACIONES-TROZOS"
   $ORACLE_HOME/bin/sqlldr control="$ctl_dir"observaciones_trozosDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_OBSERVACIONES_TROZOS_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_OBSERVACIONES_TROZOS_"$fecha".bad userid=CM01/"$1":"$puerto"/"$ORACLE_SID" DIRECT=TRUE data="$dat_dir""$fecha"/PROCEDIMIENTOS-OBSER-TROZOS.dat
echo "PROCEDIMIENTOS-SUBASTAS-LOTES"
   $ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_subastas_lotesDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_SUBASTAS_LOTES_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_SUBASTAS_LOTES_"$fecha".bad userid=CM01/"$1":"$puerto"/"$ORACLE_SID" DIRECT=TRUE data="$dat_dir""$fecha"/SUBASTAS-LOTES.dat
echo "PROCEDIMIENTOS-SUBASTAS-LOTES-BIEN"
   $ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_subastas_lotes_bienesDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_SUBASTAS_LOTES_BIEN_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_SUBASTAS_LOTES_BIEN_"$fecha".bad userid=CM01/"$1":"$puerto"/"$ORACLE_SID" DIRECT=TRUE data="$dat_dir""$fecha"/LOTES-BIENES.dat
echo "MIG_PROCEDIMIENTOS_EMBARGOS"
   $ORACLE_HOME/bin/sqlldr control="$ctl_dir"procedimientos_embargosDataLoad.ctl log="$log_dir"PROCEDIMIENTOS_EMBARGOS_"$fecha".log bad="$bad_dir"PROCEDIMIENTOS_EMBARGOS_"$fecha".bad userid=CM01/"$1":"$puerto"/"$ORACLE_SID" DIRECT=TRUE data="$dat_dir""$fecha"/PROCEDIMIENTOS-EMBARGOS.dat

   $ORACLE_HOME/bin/sqlplus CM01/"$1":"$puerto"/"$ORACLE_SID" @"$sql_dir"CJM_MiG_estadisticas.sql >> "$log_dir""$0"_"$fecha".log
if [ $? != 0 ] ; then echo -e "\n\n======>>> "Error en @"$sql_dir"CJM_MiG_estadisticas.sql >> "$log_dir""$0"_"$fecha".log ; exit 1 ; fi


echo "Fin de la carga de ficheros en Tablas MIG_. Revise directorio de logs y el directorio /bad."
exit
