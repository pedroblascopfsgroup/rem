#!/bin/bash

CUID=$1
CGID=$2

if [[ ! -d /input ]]; then
	echo "No se ha encontrado el directorio input"
fi

if [[ ! -d /output ]]; then
	echo "No se ha encontrado el directorio output"
fi

rm -Rf /input/build
rm -Rf /output/*

cd /input

echo "Compilando"
sencha app build 
echo "Copiando"
cp -R /input/build/production/HreRem/* /output

echo "Cambiando permisos a $CUID:$CGID"

chown -R $CUID:$CGID /output/*

chown -R $CUID:$CGID /input/*
