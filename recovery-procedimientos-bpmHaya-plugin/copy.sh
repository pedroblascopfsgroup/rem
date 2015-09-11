#!/bin/bash

PLUGIN=procedimientos-bpmHaya-plugin
CARPETA_PLUGIN=cajamar

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

if [ -f target/recovery-$PLUGIN*.jar ]; then
	rm -Rf target/*sources*
	mv target/recovery-$PLUGIN*.jar /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/lib
	chmod 777 /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/lib/*${PLUGIN}*
	echo "Se ha copiado el jar"
else
	echo "No se encuentra target/recovery-$PLUGIN*.jar, no se sobreescribira"
fi

if [ -d src/web/jsp/plugin/$PLUGIN ];then
	rm -Rf /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/jsp/plugin/$PLUGIN
	cp -Rf src/web/jsp/plugin/* /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/jsp/plugin
	chmod -R 777 /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/jsp/plugin/$PLUGIN
	echo "Se han copiado las JSP's"
else
	echo "No hay JSP's a copiar"
fi
if [ -d src/web/jsp/plugin/$CARPETA_PLUGIN ];then
        rm -Rf /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/jsp/plugin/$CARPETA_PLUGIN
        cp -Rf src/web/jsp/plugin/* /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/jsp/plugin
        chmod -R 777 /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/jsp/plugin/$CARPETA_PLUGIN
        echo "Se han copiado las JSP's"
else
        echo "No hay JSP's a copiar"
fi


if [ -d src/web/flows/plugin/$CARPETA_PLUGIN ];then
	rm -Rf /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/flows/plugin/$CARPETA_PLUGIN
	cp -Rf src/web/flows/plugin/* /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/flows/plugin
	chmod -R 777 /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/flows/plugin/$CARPETA_PLUGIN
	echo "Se han copiado los flows"
else
	echo "No hay flows que copiar"
fi

if [ -d src/web/js/plugin/$CARPETA_PLUGIN ];then
	rm -Rf /var/tomcat/$ENTORNO/webapps/pfs/js/plugin/$CARPETA_PLUGIN
	cp -Rf src/web/js/plugin/* /var/tomcat/$ENTORNO/webapps/pfs/js/plugin
	chmod -R 777 /var/tomcat/$ENTORNO/webapps/pfs/js/plugin/$CARPETA_PLUGIN
	echo "Se han copiado las librerias JavaScript"
else
	echo "No hay librerias JavaScript que copiar"
fi

if [ -f target/classes/optionalConfiguration/ac*.xml ]; then
        cp -Rf target/classes/optionalConfiguration/* /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/classes/optionalConfiguration
        echo "Se ha copiado target/classes/optionalConfiguration/*"
else
        echo "No se encuentra target/classes/optionalConfiguration/*, no se sobreescribira"
fi


chmod -R o+rx /tmp/$PLUGIN
