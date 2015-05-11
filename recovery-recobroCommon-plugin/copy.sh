  #!/bin/bash

PLUGIN_JAR=recobroCommon
PLUGIN=recobroCommon

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

rm /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/lib/recovery-$PLUGIN_JAR*
rm -Rf target/*sources*
mv target/recovery-$PLUGIN_JAR-plugin*.jar /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/lib
chmod 777 /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/lib/*$PLUGIN_JAR*

if [ -d src/web/img/plugin/$PLUGIN ];then
	rm -Rf /var/tomcat/$ENTORNO/webapps/pfs/img/plugin/$PLUGIN
	cp -Rf src/web/img/plugin/* /var/tomcat/$ENTORNO/webapps/pfs/img/plugin
	chmod -R 777 /var/tomcat/$ENTORNO/webapps/pfs/img/plugin/$PLUGIN
	echo "Se han copiado las Imagenes"
else
	echo "No hay Imagenes a copiar"
fi

if [ -d src/web/jsp/plugin/$PLUGIN ];then
	rm -Rf /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/jsp/plugin/$PLUGIN
	cp -Rf src/web/jsp/plugin/* /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/jsp/plugin
	chmod -R 777 /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/jsp/plugin/$PLUGIN
	echo "Se han copiado las JSP's"
else
	echo "No hay JSP's a copiar"
fi

if [ -d src/web/flows/plugin/$PLUGIN ];then
	rm -Rf /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/flows/plugin/$PLUGIN
	cp -Rf src/web/flows/plugin/* /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/flows/plugin
	chmod -R 777 /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/flows/plugin/$PLUGIN
	echo "Se han copiado los flows"
else
	echo "No hay flows que copiar"
fi

if [ -d src/web/js/plugin/$PLUGIN ];then
	rm -Rf /var/tomcat/$ENTORNO/webapps/pfs/js/plugin/$PLUGIN
	cp -Rf src/web/js/plugin/* /var/tomcat/$ENTORNO/webapps/pfs/js/plugin
	chmod -R 777 /var/tomcat/$ENTORNO/webapps/pfs/js/plugin/$PLUGIN
	echo "Se han copiado las librerias JavaScript"
else
	echo "No hay librerias JavaScript que copiar"
fi

if [ -f target/classes/optionalConfiguration/ac-plugin-$PLUGIN-view.xml ]; then
	rm -Rf /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/classes/optionalConfiguration/*$PLUGIN*
	cp -Rf target/classes/optionalConfiguration/* /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/classes/optionalConfiguration
	chmod 777 /var/tomcat/$ENTORNO/webapps/pfs/WEB-INF/classes/optionalConfiguration/*$PLUGIN*
	echo "Se ha copiado target/classes/optionalConfiguration/ac-plugin-$PLUGIN-view.xml"
else
	echo "No se encuentra target/classes/optionalConfiguration/ac-plugin-$PLUGIN-view.xml, no se sobreescribira"
fi



chmod -R o+rx /tmp/$PLUGIN
