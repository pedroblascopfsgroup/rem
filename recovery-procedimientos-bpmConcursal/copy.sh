#!/bin/bash

PLUGIN=procedimientos

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

if [ -f target/recovery-$PLUGIN-bpmConcursal-*-SNAPSHOT.jar ]; then
	rm -Rf target/*sources*
	rm /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/lib/recovery-$PLUGIN-bpmConcursal*
	mv target/recovery-$PLUGIN-bpmConcursal*.jar /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/lib
	chmod 777 /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/lib/*${PLUGIN}-bpmConcursal*
else
	echo "No se encuentra target/recovery-$PLUGIN-bmpConcursal-SNAPSHOT.jar, no se sobreescribira"
fi


if [ -f target/classes/optionalConfiguration/ac-rec-bpmConcursos-pfsgroup.xml ]; then
        rm -Rf /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/classes/optionalConfiguration/ac-rec-bpmConcursos-pfsgroup.xml
        cp -Rf target/classes/optionalConfiguration/ac-rec-bpmConcursos-pfsgroup.xml /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/classes/optionalConfiguration
        chmod 777 /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/classes/optionalConfiguration/ac-rec-bpmConcursos-pfsgroup.xml
        echo "Se ha copiado target/classes/optionalConfiguration/ac-rec-bpmConcursos-pfsgroup.xml"
else
        echo "No se encuentra target/classes/optionalConfiguration/ac-rec-bpmConcursos-pfsgroup.xml, no se sobreescribira"
fi

chmod -R o+rx /tmp/$PLUGIN
