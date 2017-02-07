#! /bin/bash

dir=$(pwd)
echo "Directorio raiz de migración: "$dir

dir_f1="fase1/migracion_BNK"
cd $dir_f1
./004_Migrar.sh $1
