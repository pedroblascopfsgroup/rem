#! /bin/bash

echo
echo "-----------------------------------------------------"
echo "-- [3/4] PROCESO DE CARGA DE TABLAS MIG2 --"
echo "-----------------------------------------------------"
echo

# Limpia de los directorios
rm CTLs_DATs/logs/*.log
rm CTLs_DATs/rejects/*.bad
rm CTLs_DATs/bad/*.bad

# Inicio de la carga
./loader_migracion_rem.sh $1

echo "[INFO] Proceso finalizado"
