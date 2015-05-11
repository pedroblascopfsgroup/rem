#!/bin/bash

PLUGIN=masivo-common

if [ -z $1 ]; then
	echo "Tienes que indicar el entorno de desarrollo en el que quieres desplegar"
	exit 1
fi

ENTORNO=$1

if [ ! -d /home/$ENTORNO/batch ]; then
	echo "El entorno proporcionado no existe"
	echo "Los entrornos disponibles son"
	ls /home | grep desa
	exit 1
fi

if [ -f target/recovery-$PLUGIN-*-SNAPSHOT.jar ]; then
	rm /home/$ENTORNO/batch/recovery-$PLUGIN**.jar
	rm -Rf target/*sources*
	mv target/recovery-$PLUGIN*.jar /home/$ENTORNO/batch
	chmod 777 /home/$ENTORNO/batch/*$PLUGIN**.jar
	echo "Se ha copiado target/recovery-$PLUGIN-*-SNAPSHOT.jar"
else
	echo "No se encuentra target/recovery-$PLUGIN-*-SNAPSHOT.jar, no se sobreescribira"
fi
