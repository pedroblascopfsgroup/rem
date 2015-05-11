#!/bin/bash

PLUGIN=common

if [ -z $1 ]; then
	echo "Tienes que indicar el entorno de desarrollo en el que quieres desplegar"
	exit 1
fi

ENTORNO=$1

if [ ! -d /var/tomcat/$ENTORNO ]; then
	echo "El entorno proporcionado no existe"
	exit 1
fi

rm -Rf /tmp/$PLUGIN

if [ -f target/rec-$PLUGIN*-SNAPSHOT.jar ]; then
	rm /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/lib/rec-$PLUGIN-*
	rm -Rf target/*sources*
	mv target/rec-$PLUGIN*.jar /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/lib
	chmod 777 /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/lib/*$PLUGIN*
else
	echo "No se encuentra target/rec-$PLUGIN-1.1-SNAPSHOT.jar, no se sobreescribira"
fi


#chmod -R o+rx /tmp/$PLUGIN
