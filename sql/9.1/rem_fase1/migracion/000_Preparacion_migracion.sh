#! /bin/bash

echo "Se va a proceder a la generación de los paquetes necesarios para ejecutar el proceso de migración."

#01_PREV
#-------------

dir=$(pwd)
echo "Directorio raiz de migración: "$dir

cd ../../../../
pwd=$(pwd)
echo "Directorio raiz de recovery: "$pwd

echo "[1/4] Generando empaquetado 01_PREV que contiene DDLs y DMLs de creación de tablas auxiliares e inserción de datos en diccionarios."

nohup ./sql/tool/package-scripts-from-tag-and-folder.sh rem_mig_v0.1 REM migracion

pkg=$pwd"/sql/tool/tmp/package"

echo "Directorio raiz de empaquetado: "$pkg

cd $pkg/DB/

rm -r $dir/01_PREV/*

cp -r * $dir/01_PREV

#02_TABLAS_MIG
#------------

echo "[2/4] Generando empaquetado 02_TABLAS_MIG que contiene los DDLs necesarios para crear las tablas de migración."

cd $pwd

nohup ./sql/tool/package-scripts-from-tag-and-folder.sh rem_mig_v0.1 REM migracion/DDLs_MIG

cd $pkg/DDL/

rm -r $dir/02_TABLAS_MIG/*

cp -r * $dir/02_TABLAS_MIG

#03_CHECK_DD
#------------

echo "[3/4] Generando empaquetado 03_CHECK_DD que contiene DMLs necesarios para la comprobación de códigos de diccionario."

cd $pwd

nohup ./sql/tool/package-scripts-from-tag-and-folder.sh rem_mig_v0.1 REM migracion/DMLs_CHECK_DD

cd $pkg/DML/

rm -r $dir/03_CHECK_DD/*

cp -r * $dir/03_CHECK_DD

#03_CHECK_DD
#------------

echo "[4/4] Generando empaquetado 04_MIGRACION que contiene los DMLs de volcado de las tablas de migración al modelo REM."

cd $pwd

nohup ./sql/tool/package-scripts-from-tag-and-folder.sh rem_mig_v0.1 REM migracion/DMLs_REM_MIGRATION

cd $pkg/DML/

rm -r $dir/04_MIGRACION/*

cp -r * $dir/04_MIGRACION

echo "[OK] Preparación de paquetes finalizada"
