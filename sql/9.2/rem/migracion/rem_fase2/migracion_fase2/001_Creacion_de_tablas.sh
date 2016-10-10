#! /bin/bash

echo
echo "-----------------------------------------------------"
echo "-- [2/4] PROCESO DE CREACION DE TABLAS --"
echo "-----------------------------------------------------"
echo

dir=$(pwd)
echo "[INFO] Directorio raiz de migración: "$dir

cd ./01_PREV
 
echo "[INFO] Creando tablas previas..."

./DB-scripts.sh $1 $1

cd $dir

cd ./02_TABLAS_MIG

echo "[INFO] Creando tablas de migración..."

./DDL-scripts.sh $1 $1

echo "[INFO] Proceso finalizado"


