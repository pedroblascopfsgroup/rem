#! /bin/bash

dir=$(pwd)
echo "Directorio raiz de migración: "$dir

cd ./04_MIGRACION
 
echo "[1/1] Ejecutando el proceso de migración sobre REM."

./DML-scripts.sh $1 $1

echo "Proceso finalizado. Comprobar tabla MIG_INFO_TABLE."


