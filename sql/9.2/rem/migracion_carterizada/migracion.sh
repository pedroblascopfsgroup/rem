#!/bin/bash

inicio=`date +%s`
export NLS_LANG=SPANISH_SPAIN.UTF8

hora=`date +%H:%M:%S`
echo "################################################################"
echo "####### [START] Comienza la migración: $hora"
echo "################################################################"
echo " "

echo "	-------------------------------------------------------"
echo "	------ [INFO] Creando tablas"
echo "	-------------------------------------------------------"
fecha=`date +%Y%m%d_%H%M%S`
inicioparte=`date +%s`
./DDL/mig_lanza_DDL.sh $1 > Logs/creacion_tablas_$fecha.log
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error creando tablas
   exit 1
fi
fin=`date +%s`
let total=($fin-$inicioparte)/60
echo "	Tablas creadas en $total minutos."

echo " "
echo "	-------------------------------------------------------"
echo "	------ [INFO] Descomprimiendo y reubicando ficheros"
echo "	-------------------------------------------------------"
fecha=`date +%Y%m%d_%H%M%S`
inicioparte=`date +%s`
./Ficheros_entrada/cambia_nombre_ficheros.sh > Logs/despliegue_ficheros_$fecha.log
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error descomprimiendo y/o reubicando ficheros
   exit 1
fi
fin=`date +%s`
let total=($fin-$inicioparte)/60
echo "	Ficheros reubicados y renombrados en $total minutos."
echo " "
echo "	-------------------------------------------------------"
echo "	------ [INFO] Rellenando tablas MIG"
echo "	-------------------------------------------------------"
fecha=`date +%Y%m%d_%H%M%S`
inicioparte=`date +%s`
./CTLs_DATs/mig_lanza_CTL.sh $1 > Logs/carga_migs_$fecha.log
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error cargando tablas MIG
   exit 1
fi
fin=`date +%s`
let total=($fin-$inicioparte)/60
echo "	Tablas MIG rellenadas en $total minutos."
echo " "

echo "	-------------------------------------------------------"
echo "	------ [INFO] Rellenando tablas VALIDACION"
echo "	-------------------------------------------------------"
fecha=`date +%Y%m%d_%H%M%S`
inicioparte=`date +%s`
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error cargando tablas de validación
   exit 1
fi
./DML/mig_lanza_DML.sh $1 > Logs/carga_validaciones_$fecha.log
fin=`date +%s`
let total=($fin-$inicioparte)/60
echo "	Tablas de validación rellenadas en $total minutos."
echo " "

echo "	-------------------------------------------------------"
echo "	------ [INFO] Compilando procesos almacenados"
echo "	-------------------------------------------------------"
fecha=`date +%Y%m%d_%H%M%S`
inicioparte=`date +%s`
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error compilando procedimientos almacenados
   exit 1
fi
./SP/compila_SP.sh $1 > Logs/compila_procedimientos_almacenados_$fecha.log
fin=`date +%s`
let total=($fin-$inicioparte)/60
echo "	Procesos almacenados compilados en $total minutos."
echo " "

echo "	-------------------------------------------------------"
echo "	------ [INFO] Ejecutando validaciones"
echo "	-------------------------------------------------------"
fecha=`date +%Y%m%d_%H%M%S`
inicioparte=`date +%s`
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error ejecutando validaciones
   exit 1
fi
./SP/lanza_SP.sh $1 > Logs/ejecuta_procedimientos_almacenados_$fecha.log
fin=`date +%s`
let total=($fin-$inicioparte)/60
echo "	Validaciones completadas en $total minutos."
echo " "

echo "	*******************************************************"
echo "	****** [INFO] Revise logs: Logs/"
echo "	*******************************************************"
echo " "

fin=`date +%s`
let total=($fin-$inicio)/60
echo "################################################################"
echo "####### [END] Migración completada en [$total] minutos"
echo "################################################################"

exit 0
