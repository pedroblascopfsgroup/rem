#! /bin/bash

dir=$(pwd)
echo "Directorio raiz de migración: "$dir

dir_f1="fase1/migracion_BNK"
cd $dir_f1
./001_Creacion_de_tablas.sh $1

cd $dir

dir_f2="rem_fase2/migracion_fase2"
cd $dir_f2
./001_Creacion_de_tablas.sh $1
