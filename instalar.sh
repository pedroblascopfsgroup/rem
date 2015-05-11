#!/bin/bash

PLUGIN1=recovery-procedimientos-bpm
PLUGIN2=recovery-procedimientos-plugin

ENTORNO=$1

if [ x$1 == x ]; then 
	echo "Por favor, indica el entorno en el que quieres instalar, GAÑAN"
	exit 0
fi

DIR=/var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/lib
DIR2=/var/tomcat/$ENTORNO/webapps/pfs/WEB-INF

cp -R ./recovery-procedimientos-plugin/src/web/flows/* $DIR2/flows
cp -R ./recovery-procedimientos-plugin/src/web/jsp/* $DIR2/jsp
cp -R ./recovery-procedimientos-plugin/src/web/img/* $DIR2/img
cp -R ./recovery-procedimientos-plugin/src/main/resources/optionalConfiguration/* $DIR2/classes/optionalConfiguration
cp -R ./recovery-procedimientos-bpm/src/main/resources/optionalConfiguration/* $DIR2/classes/optionalConfiguration

if [ ! -d target ]; then
	echo "GAÑAN, no se porqué no encuentro el directorio target. Prueba a empaquetar"
fi

jars="$(find ./recovery-procedimientos-bpm/target -name $PLUGIN1-*-SNAPSHOT.jar)"
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
	file=$(find $DIR -name $PLUGIN1-*.jar)
	echo $file
	if [ "x$file" != "x" ]; then
		echo -n "Se ha encontrado el fichero $file. ¿Quieres borrarlo? [s|n] "
		read op
		if [ x$op == xs ] || [ x$op == xS ]; then
			rm $file
		fi
	fi
	mv $jars $DIR
	#chmod o+rw $DIR/$(echo $jars | sed "s/target\\///")
else
	echo "ERROR no existe $DIR. No se puede instalar"
	exit 1
fi



jars="$(find ./recovery-procedimientos-plugin/target -name $PLUGIN2-*-SNAPSHOT.jar)"
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
	file=$(find $DIR -name $PLUGIN2-*.jar)
	echo $file
	if [ "x$file" != "x" ]; then
		echo -n "Se ha encontrado el fichero $file. ¿Quieres borrarlo? [s|n] "
		read op
		if [ x$op == xs ] || [ x$op == xS ]; then
			rm $file
		fi
	fi
	mv $jars $DIR
	#chmod o+rw $DIR/$(echo $jars | sed "s/target\\///")
else
	echo "ERROR no existe $DIR. No se puede instalar"
	exit 1
fi

