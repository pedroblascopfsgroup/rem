#!/bin/bash

inicio=`date +%s`
export NLS_LANG=SPANISH_SPAIN.UTF8

mkdir -p Logs/backup/
mv -f Logs/*.log Logs/backup/
fecha_log=`date +%Y%m%d_%H%M%S`
log_completo="Logs/migracion_completo_"$fecha_log".log"

hora=`date +%H:%M:%S`
echo "################################################################"
echo "####### [START] Comienza la migración: $hora"
echo "################################################################"
echo " "
##############################################################################################
echo "	-------------------------------------------------------"
echo "	------ [INFO] Creando tablas"
echo "	-------------------------------------------------------"
fecha_ini=`date +%Y%m%d_%H%M%S`
inicioparte=`date +%s`
salida=Logs/001_creacion_tablas_$fecha_ini.log 
./DDL/mig_lanza_DDL.sh $1 > $salida
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error creando tablas
   exit 1
fi
cat $salida >> $log_completo
fin=`date +%s`
let total=($fin-$inicioparte)/60
echo "	Tablas creadas en $total minutos."
##############################################################################################
echo " "
echo "	-------------------------------------------------------"
echo "	------ [INFO] Descomprimiendo y reubicando ficheros"
echo "	-------------------------------------------------------"
fecha=`date +%Y%m%d_%H%M%S`
inicioparte=`date +%s`
salida=Logs/002_despliegue_ficheros_$fecha.log
./Ficheros_entrada/cambia_nombre_ficheros.sh $salida > $salida
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error descomprimiendo y/o reubicando ficheros
   exit 1
fi
cat $salida >> $log_completo
fin=`date +%s`
let total=($fin-$inicioparte)/60
echo "	Ficheros reubicados y renombrados en $total minutos."
##############################################################################################
echo " "
echo "	-------------------------------------------------------"
echo "	------ [INFO] Rellenando tablas MIG"
echo "	-------------------------------------------------------"
fecha=`date +%Y%m%d_%H%M%S`
inicioparte=`date +%s`
salida=Logs/003_carga_migs_$fecha.log
./CTLs_DATs/mig_lanza_CTL.sh $1 > $salida
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error cargando tablas MIG
   exit 1
fi
cat $salida >> $log_completo
fin=`date +%s`
let total=($fin-$inicioparte)/60
echo "	Tablas MIG rellenadas en $total minutos."
##############################################################################################
echo " "
echo "	-------------------------------------------------------"
echo "	------ [INFO] Rellenando tablas VALIDACION"
echo "	-------------------------------------------------------"
fecha=`date +%Y%m%d_%H%M%S`
inicioparte=`date +%s`
salida=Logs/004_carga_validaciones_$fecha.log
./DML/mig_lanza_DML.sh $1 > $salida
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error cargando tablas de validación
   exit 1
fi
cat $salida >> $log_completo
fin=`date +%s`
let total=($fin-$inicioparte)/60
echo "	Tablas de validación rellenadas en $total minutos."
##############################################################################################
echo " "
echo "	-------------------------------------------------------"
echo "	------ [INFO] Compilando procesos almacenados"
echo "	-------------------------------------------------------"
fecha=`date +%Y%m%d_%H%M%S`
inicioparte=`date +%s`
salida=Logs/005_compila_procedimientos_almacenados_$fecha.log
./SP/compila_SP.sh $1 $fecha >> $salida
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error compilando procedimientos almacenados
   exit 1
fi
cat $salida >> $log_completo
fin=`date +%s`
let total=($fin-$inicioparte)/60
echo "	Procesos almacenados compilados en $total minutos."
##############################################################################################
echo " "
echo "	-------------------------------------------------------"
echo "	------ [INFO] Ejecutando validaciones"
echo "	-------------------------------------------------------"
fecha=`date +%Y%m%d_%H%M%S`
inicioparte=`date +%s`
salida=Logs/006_ejecuta_procedimientos_almacenados_$fecha.log
./SP/lanza_SP.sh $1 $fecha >> $salida
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error ejecutando validaciones
   exit 1
fi
cat $salida >> $log_completo
fin=`date +%s`
let total=($fin-$inicioparte)/60
echo "	Validaciones completadas en $total minutos."
##############################################################################################
echo " "
echo "	*******************************************************"
echo "	****** [INFO] Revise log completo: $log_completo"
echo "	*******************************************************"
echo " "

fin=`date +%s`
let total=($fin-$inicio)/60
echo "################################################################"
echo "####### [END] Migración completada en [$total] minutos"
echo "################################################################"

exit 0