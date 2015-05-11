#/bin/bash

SQL_DIR=${WORKSPACE}/src/main/sql

if [ "x$1" == "x" ]; then
	echo "[ERROR] Argumento (1) TAG no especificado"
	exit 1
fi

if [ "x$2" == "x" ]; then
	echo "[ERROR] Argumento (2) BATCH_INSTALL_DIR no especificado"
	exit 1
fi

if [ ! -d "$2" ]; then
	echo "[ERROR] $2: no existe el directorio"
	exit 1
fi

if [ "x$WORKSPACE" = "x" ]; then
	echo "[ERROR] WORKSPACE: variable de entorno no encontrada"
	exit 1
fi

if [ ! -d "$SQL_DIR" ]; then
	echo "[ERROR] $SQL_DIR: no existe el directorio"
	exit 1
fi

if [ -d "$SQL_DIR/$1" ]; then
	if [ -d "$SQL_DIR/$1/default" ]; then
		name="batch-$(echo $1 | sed 's/\./\_/g')"
		dir=$2/../sql/$name
		rm -Rf $2/../sql
		mkdir -p $2/../sql
		cp -R $SQL_DIR/$1/default $dir
		echo "version=$1" > $2/../sql/version.properties
		echo "fecha=$(date)" >> $2/../sql/version.properties
	else
		echo "[ERROR] $SQL_DIR/$1/default: no existe el subdirectorio. Los scripts deben estar en un subdirectorio 'default'"
		exit 1
	fi
else 
	echo "[WARN] No se han encontrado scripts a ejecutar en $SQL_DIR/$1"
fi

