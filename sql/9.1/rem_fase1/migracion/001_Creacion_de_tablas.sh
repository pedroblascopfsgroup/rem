#! /bin/bash

dir=$(pwd)
echo "Directorio raiz de migración: "$dir

cd ./01_PREV
 
echo "[1/2] Creando tablas previas. Realizando ajustes previos."

./DB-scripts.sh $1 $1

cd $dir

cd ./02_TABLAS_MIG

echo "[2/2] Creando tablas de migración"

./DDL-scripts.sh $1 $1

echo "Proceso finalizado"


