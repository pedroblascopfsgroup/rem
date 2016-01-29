#!/bin/bash



if [ -f .apodo ]; then
	APODO=$(cat .apodo)
else
	APODO=""
fi
if [ "x$1" != "x-q" ]; then
	echo "-----------------------------------------------------------------------------------------------------"
	echo " ASISTENTE PARA CREAR EL PROYECTO EN ECLIPSE PARA rec-web"
	echo "-----------------------------------------------------------------------------------------------------"
	echo ""
	echo "Puedes pasar le -q al script para ahorrarte este mensaje."
	echo ""
	echo "Este script te permite darle un APODO al proyecto"
	echo "El nombre del proyecto en eclipse será rec-web (APODO)"
	echo ""
	if [ -z "$APODO" ]; then
		echo -n "Introduce el nombre del apodo que desaeas [puedes dejarlo en blanco]: "
	else
		echo -n "Introduce el nombre del apodo qeu deseas [por defecto $APODO]: "
	fi
	
	read INPUT
	
	if [ -z "$APODO" ]; then
		APODO="$INPUT"
	else
		[ -z "$INPUT" ] || APODO="$INPUT"
	fi
fi

[ -f build.properties ] && source build.properties

[ -z "$APODO" ] && TEMPLATE="" || TEMPLATE=" ($APODO)"
mvn $BUILD_PROPERTIES eclipse:eclipse  -Declipse.projectNameTemplate="recovery-procedimientos-bpmHaya$TEMPLATE"

echo $APODO > .apodo
