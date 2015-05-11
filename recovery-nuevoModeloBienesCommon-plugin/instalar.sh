#!/bin/bash

PLUGIN=recovery-nuevoModeloBienes-plugin

ENTORNO=$1

if [ x$1 == x ]; then 
	echo "Por favor, indica el entorno en el que quieres instalar, GAÑAN"
	exit 0
fi

DIR=/var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/lib
DIR2=/var/tomcat/$ENTORNO/webapps/pfs/WEB-INF
DIR3=/home/$ENTORNO/batch

cp -R ./src/web/flows/* $DIR2/flows
cp -R ./src/web/jsp/* $DIR2/jsp
cp -R ./src/web/img/* $DIR2/img
cp -R ./src/web/reports/* $DIR2/reports
cp -R ./src/main/resources/optionalConfiguration/* $DIR2/classes/optionalConfiguration

if [ ! -d target ]; then
	echo "GAÑAN, no se porqué no encuentro el directorio target. Prueba a empaquetar"
fi

jars="$(find target -name $PLUGIN-*-SNAPSHOT.jar)"
c=$(echo "$jars" | wc -l)

if [ "x$jars" == "x" ] || [ $c -eq 0 ]; then
	echo "No se ha encontrado el plugin, ¿Has empaquetado? GAÑAN"
	exit 0
fi

if [ $c -gt 1 ]; then
	echo "Hay demasiados SNAPSHOTS. Haz una limpieza GAÑAN"
	exit 0
fi

if [ -d $DIR ]; then
	file=$(find $DIR -name $PLUGIN-*.jar)
	echo $file
	if [ "x$file" != "x" ]; then
		echo -n "Se ha encontrado el fichero $file. ¿Quieres borrarlo? [s|n] "
		read op
		if [ x$op == xs ] || [ x$op == xS ]; then
			rm $file
		fi
	fi
	cp $jars $DIR3
	chmod o+rw $DIR3/$(echo $jars | sed "s/target\\///")
	mv $jars $DIR
	chmod o+rw $DIR/$(echo $jars | sed "s/target\\///")
else
	echo "ERROR no existe $DIR. No se puede instalar"
	exit 1
fi



