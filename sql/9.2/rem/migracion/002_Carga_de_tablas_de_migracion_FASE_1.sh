#! /bin/bash

dir=$(pwd)
echo "Directorio raiz de migración: "$dir

dir_f1="fase1/migracion_BNK"
cd $dir_f1
./002_Carga_de_tablas_de_migracion.sh $1
