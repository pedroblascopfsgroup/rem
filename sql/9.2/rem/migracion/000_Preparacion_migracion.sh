#! /bin/bash

dir=$(pwd)
echo "Directorio raiz de migración: "$dir

dir_f1="fase1/migracion_BNK"
cd $dir_f1
./000_Preparacion_migracion.sh

cd $dir

dir_f2="rem_fase2/migracion_fase2"
cd $dir_f2
./000_Preparacion_migracion.sh


