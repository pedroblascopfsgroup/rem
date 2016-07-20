#!/bin/bash

CUID=$1
CGID=$2
OP=$3

if [[ ! -d /input ]]; then
	echo "No se ha encontrado el directorio input"
fi

if [[ ! -d /output ]]; then
	echo "No se ha encontrado el directorio output"
fi

rm -Rf /input/build
rm -Rf /output/*

cd /input

CONST_DEV=dev
# Esta comparación tan extraña es para ignorar mayúsculas y minúsculas
if [[ "${OP,,}" == "${CONST_DEV,,}" ]]; then
	echo '*********************************************'
	echo "[WARNING] El código se compilará sin ofuscar"
	echo '*********************************************'
	sleep 1
	echo "Compilando"
	sencha app build testing
	echo "Copiando"
	cp -R /input/build/testing/HreRem/* /output
elif [[ ! -z "$OP" ]]; then
		echo ""
		echo '*********************************************'
		echo "No conozco la opción \"$OP\""
		echo "¿Querías decir \"$CONST_DEV\"?"
		echo '*********************************************'
		echo ""
		exit 1
else
	echo "Compilando"
	sencha app build
	[ $? -ne 0 ] && exit 1
	echo "Copiando"
	cp -R /input/build/production/HreRem/* /output
	[ $? -ne 0 ] && exit 1
fi

echo "Cambiando permisos a $CUID:$CGID"

chown -R $CUID:$CGID /output/*

chown -R $CUID:$CGID /input/*
