#! /bin/bash

dir=$(pwd)
echo "Directorio raiz de migración: "$dir


dir_f2="rem_fase2/migracion_fase2"
cd $dir_f2
./Generacion_fichero_pares_comercial.sh $1


