#! /bin/bash

echo "[1/5] Lanzando script ./000_Preparacion_migracion.sh..."

./000_Preparacion_migracion.sh

echo "[2/5] Lanzando script ./001_Creacion_de_tablas.sh..."

./001_Creacion_de_tablas.sh $1

echo "[3/5] Lanzando script ./002_Carga_de_tablas_de_migracion.sh..."

./002_Carga_de_tablas_de_migracion.sh $1

echo "[4/5] Lanzando script ./003_Comprobacion_de_diccionarios.sh..."

./003_Comprobacion_de_diccionarios.sh $1

echo "[5/5] Lanzando script ./004_Migrar.sh..."

./004_Migrar.sh $1

echo "Proceso de migración finalizado."
