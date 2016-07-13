#!/bin/bash

echo "Este script construye la aplicación sencha y la deja lista para empaquetar."
echo ""

### Directorios INPUT y OUTPUT
CURRENT=$(pwd)

cd $(pwd)/$(dirname $0)/sencha-app
if [[ $? -eq 0 ]]; then
	INPUT=$(pwd)
else
	echo "sencha-app: no se encuentra el directorio de origen"
	exit
fi
cd $CURRENT

OUTPUT=$(pwd)/$(dirname $0)/src/web/js/plugin/rem
mkdir -p $OUTPUT

cd $CURRENT

echo "input  = $INPUT"
echo "output = $OUTPUT"
echo ""

# Limpiamos OUTPUT
echo "Borrando 'output'"
rm -Rf $OUTPUT/*

######## Construcción y arranque de imágenes y contenedores
echo "Validando instalación de la plataforma"

if [ "x$(docker images | grep rem/sencha-cmd)" != "x" ]; then
	echo  "rem/sencha-cmd: Se ha encontrado la imagen requerida"
else
	echo "Falta algunas imágenes de la platarforma. Se van a reconstruir"
	if [ "x$(docker images | grep rem/base)" != "x" ]; then
		echo "rem/base: Se ha encontrado la imágen"
	else
		echo "Generando imágen rem/base"
		sleep 1
		docker build --no-cache=true -t rem/base $CURRENT/../dockerize/rem/rem-base/.
		[ $? -ne 0 ] && exit 1
		echo -e "\n\n"
	fi
	echo "Generando imágen rem/sencha-cmd"
	sleep 1
	docker build --no-cache=true -t rem/sencha-cmd $CURRENT/../dockerize/rem/rem-sencha-cmd/.
	[ $? -ne 0 ] && exit 1
	echo -e "\n\n"
fi

echo "Continuando"
sleep 1
# Descomentar para construir con el build de sencha
docker run --rm -i -v $(pwd)/sencha-app:/input -v $(pwd)/src/web/js/plugin/rem/:/output rem/sencha-cmd sencha-build-dev.sh $(id -u) $(id -g)


if [[ ! -f $(pwd)/src/web/js/plugin/rem/index.jsp ]]; then
	echo "EL BUILD HA FALLADO: No se ha generado el código esperado"
	exit 1
fi
