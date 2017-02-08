#! /bin/bash

dir=$(pwd)
echo "Directorio raiz de migración: "$dir

#Lanzamos la migracion completa

./000_Preparacion_migracion.sh
./001_Creacion_de_tablas.sh $1
./002_Carga_de_tablas_de_migracion.sh $1
./003_Comprobacion_de_diccionarios.sh $1
./004_Migrar_fase_1.sh $1
./005_Migrar_fase_2.sh $1
