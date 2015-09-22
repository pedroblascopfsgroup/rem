#!/bin/bash

PLUGIN=procuradores-common

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

if [ -d src/web/jsp/plugin/$PLUGIN ];then
	rm -Rf /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/jsp/plugin/$PLUGIN
	cp -Rf src/web/jsp/plugin/* /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/jsp/plugin
	chmod -R 777 /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/jsp/plugin/$PLUGIN
	echo "Se han copiado las JSP's"
else
	echo "No hay JSP's a copiar"
fi

if [ -d src/web/img/plugin/$PLUGIN ];then
	rm -Rf /var/tomcat/$ENTORNO/webapps/pfs/img/plugin/$PLUGIN
	cp -Rf src/web/img/plugin/* /var/tomcat/$ENTORNO/webapps/pfs/img/plugin
	chmod -R 777 /var/tomcat/$ENTORNO/webapps/pfs/img/plugin/$PLUGIN
	echo "Se han copiado los recursos graficos"
else
	echo "No hay recursos gráficos que copiar"
fi

if [ -d src/web/flows/plugin/$PLUGIN ];then
        rm -Rf /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/flows/plugin/$PLUGIN
        cp -Rf src/web/flows/plugin/* /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/flows/plugin
        chmod -R 777 /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/flows/plugin/$PLUGIN
        echo "Se han copiado los flows"
else
        echo "No hay flows que copiar"
fi

chmod -R o+rx /tmp/$PLUGIN
