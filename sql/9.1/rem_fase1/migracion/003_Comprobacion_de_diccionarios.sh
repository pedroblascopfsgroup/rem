#! /bin/bash

dir=$(pwd)
echo "Directorio raiz de migración: "$dir

cd ./03_CHECK_DD
 
echo "[1/1] Comprobando códigos de diccionario inexistentes."

./DML-scripts.sh $1 $1

echo "Proceso finalizado"


