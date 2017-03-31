#! /bin/bash


dir=$(pwd)

echo "[INFO] INICIO GENERACION FICHEROS UVEM. "

echo "Directorio raiz de migración: "$dir


dir_f2="rem_fase2/migracion_fase2"
cd $dir_f2
./Generacion_fichero_pares_comercial.sh $1

./Generacion_fichero_pares_stock.sh $1


echo "[INFO] FIN GENERACION FICHEROS UVEM. "

