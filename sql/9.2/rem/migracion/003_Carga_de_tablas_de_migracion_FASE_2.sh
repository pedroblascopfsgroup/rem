#! /bin/bash

dir=$(pwd)
echo "Directorio raiz de migración: "$dir

dir_f2="rem_fase2/migracion_fase2"
cd $dir_f2
./002_Carga_de_tablas_de_migracion.sh $1
