#! /bin/bash

echo
echo "-----------------------------------------------------"
echo "-- [4/4] PROCESO DE VOLCADO A TABLAS MODELO DE REM --"
echo "-----------------------------------------------------"
echo

dir=$(pwd)
echo "[INFO] Directorio raiz de migración: "$dir

cd ./03_MIGRACION
 
echo "[INFO] Ejecutando el proceso de migración sobre REM..."

./DML-scripts.sh $1 $1

echo "[INFO] Migracion finalizada. Comprobar tabla MIG_INFO_TABLE."
