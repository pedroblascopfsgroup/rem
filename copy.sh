#!/bin/bash

PLUGIN=nuevoModeloBienesCommon

if [ -z $1 ]; then
	echo "Tienes que indicar el entorno de desarrollo en el que quieres desplegar"
	exit 1
fi

ENTORNO=$1

if [ ! -d /var/tomcat/$ENTORNO ]; then
	echo "El entorno proporcionado no existe"
	echo "Los entrornos disponibles son"
	ls /var/tomcat | grep desa
	exit 1
fi

rm -Rf /tmp/$PLUGIN
mkdir -p /tmp/$PLUGIN/jsp
mkdir -p /tmp/$PLUGIN/flows

if [ -f target/recovery-$PLUGIN-plugin-*-SNAPSHOT.jar ]; then
	rm /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/lib/recovery-$PLUGIN*
	rm -Rf target/*sources*
	mv target/recovery-$PLUGIN-plugin*.jar /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/lib
	chmod 777 /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/lib/*$PLUGIN*
else
	echo "No se encuentra target/recovery-$PLUGIN-plugin-SNAPSHOT.jar, no se sobreescribira"
fi

if [ -f target/classes/optionalConfiguration/ac-plugin-nuevoModeloBienes-projectContext.xml ]; then
        cp -Rf target/classes/optionalConfiguration/* /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/classes/optionalConfiguration
        echo "Se ha copiado target/classes/optionalConfiguration/*"
else
        echo "No se encuentra target/classes/optionalConfiguration/*, no se sobreescribira"
fi


chmod -R o+rx /tmp/$PLUGIN
