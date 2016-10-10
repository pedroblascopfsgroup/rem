#! /bin/bash

echo
echo "-----------------------------------------------------"
echo "-- [1/4] PROCESO DE EMPAQUETADO --"
echo "-----------------------------------------------------"
echo

dir=$(pwd)
echo "[INFO] Directorio raiz de migración: "$dir

cd ../../../../../../
pwd=$(pwd)
echo "[INFO] Directorio raiz de recovery: "$pwd

pkg=$pwd"/sql/pitertul/tmp/package"
echo "[INFO] Directorio raiz de empaquetado: "$pkg


#01_PREV
#-------------

echo "[INFO] Generando empaquetado del directorio PRE_MIGRACION..."

nohup ./sql/pitertul/package-scripts-from-tag-and-folder.sh rem_mig_fase2_v0.1 REM migracion/rem_fase2/migracion_fase2/PRE_MIGRACION

cd $pkg/DB/

rm -r $dir/01_PREV/*

cp -r * $dir/01_PREV


#02_TABLAS_MIG
#------------

echo "[INFO] Generando empaquetado del directorio DDLs_MIG..."

cd $pwd

nohup ./sql/pitertul/package-scripts-from-tag-and-folder.sh rem_mig_fase2_v0.1 REM migracion/rem_fase2/migracion_fase2/DDLs_MIG

cd $pkg/DDL/

rm -r $dir/02_TABLAS_MIG/*

cp -r * $dir/02_TABLAS_MIG


#03_MIGRACION
#------------

echo "[INFO] Generando empaquetado del directorio DMLs_REM_MIGRATION..."

cd $pwd

nohup ./sql/pitertul/package-scripts-from-tag-and-folder.sh rem_mig_fase2_v0.1 REM migracion/rem_fase2/migracion_fase2/DMLs_REM_MIGRATION

cd $pkg/DML/

rm -r $dir/03_MIGRACION/*

cp -r * $dir/03_MIGRACION

echo "[INFO] Proceso finalizado"
