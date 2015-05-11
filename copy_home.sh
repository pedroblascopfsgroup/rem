#!/bin/bash

PLUGIN=bankiaWeb

if [ -z $1 ]; then
	echo "Tienes que indicar el entorno de desarrollo en el que quieres desplegar"
	exit 1
fi

ENTORNO=$1

if [ ! -d ~/$ENTORNO ]; then
	echo "El entorno proporcionado no existe"
	exit 1
fi

rm -Rf /tmp/$PLUGIN
mkdir -p /tmp/$PLUGIN/jsp
mkdir -p /tmp/$PLUGIN/flows

if [ -f target/recovery-$PLUGIN-plugin-*-SNAPSHOT.jar ]; then
	rm ~/$ENTORNO/WEB-INF/lib/recovery-$PLUGIN-plugin*
	rm -Rf target/*sources*
	mv target/recovery-$PLUGIN-plugin*.jar ~/$ENTORNO/WEB-INF/lib
	chmod 777 ~/$ENTORNO/WEB-INF/lib/*$PLUGIN*
else
	echo "No se encuentra target/recovery-$PLUGIN-plugin-1.1-SNAPSHOT.jar, no se sobreescribira"
fi

if [ -d src/web/jsp/plugin/$PLUGIN ];then
	rm -Rf ~/$ENTORNO/WEB-INF/jsp/plugin/$PLUGIN-plugin*
	cp -Rf src/web/jsp/plugin/* ~/$ENTORNO/WEB-INF/jsp/plugin
	chmod -R 777 ~/$ENTORNO/WEB-INF/jsp/plugin/$PLUGIN
	echo "Se han copiado las JSP's"
else
	echo "No hay JSP's a copiar"
fi

if [ -d src/web/flows/plugin/$PLUGIN ];then
	rm -Rf ~/$ENTORNO/WEB-INF/flows/plugin/$PLUGIN
	cp -Rf src/web/flows/plugin/* ~/$ENTORNO/WEB-INF/flows/plugin
	chmod -R 777 ~/$ENTORNO/WEB-INF/flows/plugin/$PLUGIN
	echo "Se han copiado los flows"
else
	echo "No hay flows que copiar"
fi

if [ -d src/web/js/plugin/$PLUGIN ];then
	rm -Rf ~/$ENTORNO/js/plugin/$PLUGIN
	cp -Rf src/web/js/plugin/* ~/$ENTORNO/js/plugin
	chmod -R 777 ~/$ENTORNO/js/plugin/$PLUGIN
	echo "Se han copiado las librerias JavaScript"
else
	echo "No hay librerias JavaScript que copiar"
fi

if [ -d src/web/reports/plugin/$PLUGIN ];then
	rm -Rf ~/$ENTORNO/reports/plugin/$PLUGIN
	cp -Rf src/web/reports/plugin/* ~/$ENTORNO/reports/plugin
	chmod -R 777 ~/$ENTORNO/reports/plugin/$PLUGIN
	echo "Se han copiado los reports"
else
	echo "No hay reports que copiar"
fi

if [ -f target/classes/optionalConfiguration/ac-plugin-$PLUGIN-view.xml ]; then
	rm -Rf ~/$ENTORNO/WEB-INF/classes/optionalConfiguration/*$PLUGIN*
	cp -Rf target/classes/optionalConfiguration/* ~/$ENTORNO/WEB-INF/classes/optionalConfiguration
	chmod 777 ~/$ENTORNO/WEB-INF/classes/optionalConfiguration/*$PLUGIN*
	echo "Se ha copiado target/classes/optionalConfiguration/ac-plugin-$PLUGIN-view.xml"
else
	echo "No se encuentra target/classes/optionalConfiguration/ac-plugin-$PLUGIN-view.xml, no se sobreescribira"
fi

if [ -d src/web/img/plugin/$PLUGIN ];then
	rm -Rf ~/$ENTORNO/img/plugin/$PLUGIN
	cp -Rf src/web/img/plugin/* ~/$ENTORNO/img/plugin
	chmod -R 777 ~/$ENTORNO/img/plugin/$PLUGIN
	echo "Se han copiado los recursos graficos"
else
	echo "No hay recursos gráficos que copiar"
fi


chmod -R o+rx /tmp/$PLUGIN

