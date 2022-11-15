#!/bin/sh
# Supported Sencha: ExtJS Sencha version 6.0.1.76
# Description: Este script construye la aplicación sencha y la deja lista para empaquetar
# How to use: Permite lanzarlo sin más y pregunta por tipo de compilación o se puede lanzar con el tipo de compilación incluida para agilizar (development / production)

CURRENT_FOLDER=$(pwd)
EXTJS_OUT_FOLDER=$CURRENT_FOLDER/src/web/js/plugin/rem/
EXTJS_IN_FOLDER=$CURRENT_FOLDER/sencha-app
BUILD_MODE=$1
DEBUG_MODE=no

if [[ "$#" -eq 0 ]] || [[ "$BUILD_MODE" != "development" && "$BUILD_MODE" != "production" ]]; then
	PS3='Select build mode or CTRL+C to quit: '
	options=("Development" "Development (debug mode)" "Production" "Production (debug mode)" "Quit")
	select opt in "${options[@]}"
	do
		case $opt in
			"Development")
				BUILD_MODE=development
                break
				;;
			"Production")
				BUILD_MODE=production
                break
				;;
			"Development (debug mode)")
				BUILD_MODE=development
				DEBUG_MODE=yes
                break
				;;
			"Production (debug mode)")
				BUILD_MODE=production
				DEBUG_MODE=yes
                break
				;;
			"Quit")
				break
				;;
			*) echo "invalid option $REPLY";;
		esac
	done
fi

echo ''
echo -e "\e[92m\e[1m[BEGIN]\e[0m"

echo -e "\e[92m\e[1m[INFO]\e[0m Delete compiled content from the output directory"
rm -Rf $EXTJS_OUT_FOLDER/*

echo -e "\e[92m\e[1m[INFO]\e[0m Launch Docker container with a process request"
docker run -u $(id -u):$(id -g) --rm --ulimit nofile=122880:122880 -t -v $EXTJS_IN_FOLDER:/input -v $EXTJS_OUT_FOLDER:/output docker-repo.pfsgroup.es:5000/extjs/cmd-6.0.1.76:1.0 sencha-build.sh $(id -u) $(id -g) $BUILD_MODE $DEBUG_MODE

echo -e "\e[92m\e[1m[INFO]\e[0m Copy front resources"
mkdir $EXTJS_OUT_FOLDER/email-attachment
cp -a $CURRENT_FOLDER/web/js/plugin/rem/email-attachment/. $EXTJS_OUT_FOLDER/email-attachment/

if [[ ! -f $EXTJS_OUT_FOLDER/index.jsp ]]; then
	echo -e "\e[91m\e[1m[ERROR]\e[0m Sencha build has failed; The expected code has not been generated"
else
	echo -e "\e[92m\e[1m[DONE]\e[0m"
fi