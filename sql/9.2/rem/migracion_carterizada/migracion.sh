#!/bin/bash

inicio=`date +%M`
export NLS_LANG=SPANISH_SPAIN.UTF8

echo " "
echo "#######################################################"
echo "###### [INFO] Comienza la migración"
echo "#######################################################"
echo " "
echo "#######################################################"
echo "###### [INFO] Creando tablas"
echo "#######################################################"
echo " "
fecha=`date +%Y%m%d_%H%M%S`
./DDL/mig_lanza_DDL.sh $1 > Logs/creacion_tablas_$fecha.log

echo " "
echo "#######################################################"
echo "###### [INFO] Descomprimiendo y reubicando ficheros"
echo "#######################################################"
echo " "
fecha=`date +%Y%m%d_%H%M%S`
./Ficheros_entrada/cambia_nombre_ficheros.sh > Logs/despliegue_ficheros_$fecha.log

echo " "
echo "#######################################################"
echo "###### [INFO] Rellenando tablas MIG"
echo "#######################################################"
echo " "
fecha=`date +%Y%m%d_%H%M%S`
./CTLs_DATs/mig_lanza_CTL.sh $1 > Logs/carga_migs_$fecha.log

echo " "
echo "#######################################################"
echo "###### [INFO] Rellenando tablas VALIDACION"
echo "#######################################################"
echo " "
fecha=`date +%Y%m%d_%H%M%S`
./DML/mig_lanza_DML.sh $1 > Logs/carga_validaciones_$fecha.log

echo " "
echo "#######################################################"
echo "###### [INFO] Compilando procesos almacenados"
echo "#######################################################"
echo " "
fecha=`date +%Y%m%d_%H%M%S`
./SP/compila_SP.sh $1 > Logs/compila_procedimientos_almacenados_$fecha.log

echo " "
echo "#######################################################"
echo "###### [INFO] Ejecutando validaciones"
echo "#######################################################"
echo " "
fecha=`date +%Y%m%d_%H%M%S`
./SP/lanza_SP.sh $1 > Logs/ejecuta_procedimientos_almacenados_$fecha.log

fin=`date +%M`
let total=($fin-$inicio)

echo "*******************************************************"
echo "-----> [INFO] Revise log"
echo "*******************************************************"

echo " "
echo "#######################################################"
echo "###### [INFO] Migración completada en $total minutos"
echo "#######################################################"
echo " "

exit 0
