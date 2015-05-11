#!/bin/bash

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

rm -Rf /tmp/panelcontrol
mkdir -p /tmp/panelcontrol/jsp
mkdir -p /tmp/panelcontrol/flows

if [ -f target/recovery-panelcontrol-plugin-2.0-SNAPSHOT.jar ]; then
	rm /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/lib/recovery-panelcontrol*
	rm -Rf target/*sources*
	mv target/recovery-panelcontrol-plugin*.jar /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/lib
else
	echo "No se encuentra target/recovery-panelcontrol-plugin-1.1-SNAPSHOT.jar, no se sobreescribira"
fi

rm -Rf /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/jsp/plugin/panelcontrol
cp -Rf src/web/jsp/plugin/* /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/jsp/plugin


rm -Rf /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/flows/plugin/panelcontrol
cp -Rf src/web/flows/plugin/* /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/flows/plugin

rm -Rf /var/tomcat/$ENTORNO/webapps/pfs/js/plugin/panelcontrol
cp -Rf src/web/js/plugin/* /var/tomcat/$ENTORNO/webapps/pfs/js/plugin

if [ -f target/classes/optionalConfiguration/ac-plugin-panelcontrol-view.xml ]; then
	rm -Rf /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/classes/optionalConfiguration/*panelcontrol*
	cp -Rf target/classes/optionalConfiguration/* /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/classes/optionalConfiguration
else
	echo "No se encuentra target/classes/optionalConfiguration/ac-plugin-panelcontrol-view.xml, no se sobreescribira"
fi

chmod 777 /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/lib/*panelcontrol*
chmod -R 777 /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/jsp/plugin/panelcontrol
chmod -R 777 /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/flows/plugin/panelcontrol
chmod 777 /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/classes/optionalConfiguration/*panelcontrol*


chmod -R o+rx /tmp/panelcontrol
