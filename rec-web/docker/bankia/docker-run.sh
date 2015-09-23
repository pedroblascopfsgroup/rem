#!/bin/bash
PLATFORM_N1=producto/plataforma-base
PLATFORM_N2=producto/plataforma-app-server
PLATFORM_N3=bankia/bankia-web

CONTAINER=bankia-web

SHAPSHOT_WAR="$(pwd)/../../target/pfs-9.1-SNAPSHOT.war"

IMAGE_ID=$(docker images | grep "$PLATFORM_N3" | awk '{print $3}')

if [[ "x$1" == "x-remove" || "x$IMAGE_ID" == "x" ]]; then
	OPTION_REGENERA=yes
else
	OPTION_REGENERA=no
fi

echo "Validando instalación de la Plataforma Producto de Recovery"

if [ "x$(docker images | grep $PLATFORM_N2)" != "x" ]; then
	echo  "$PLATFORM_N2: Se ha encontrado la imagen requerida"
else
	echo "ERROR: No se han encontrado las imágenes correspondientes a la plataforma base. Consulta con Arquitectura para su generación."
fi

if [[ ! -f $SHAPSHOT_WAR ]]; then
	echo "ERROR: $(basename $SHAPSHOT_WAR) No se ha encontrado. ¿Has empaquetado?"
	exit 1
fi


echo "Comprobando si $CONTAINER está arrancado"
if [ "x$(docker ps | grep $CONTAINER)" != "x" ]; then
	docker stop $CONTAINER
fi

if [[ "x$OPTION_REGENERA" == "xyes" ]]; then
	echo "Borando imágen anterior"
	if [ "x$IMAGE_ID" != "x" ]; then
		docker rmi $IMAGE_ID 
	fi
	
	docker build --no-cache=true -t $PLATFORM_N3 .
else
	echo "[INFO] Reiniciando el contenedor."
	echo "[INFO] Ejecuta $0 -remove para regenerar."
fi

if [ "x$(docker ps -a | grep $CONTAINER)" != "x" ]; then
	echo -n "Borrando conenedor: "
	docker rm $CONTAINER
fi

docker run --rm -ti -p=22 -p=8080 \
	-v ${HOME}/container-info:/container-info \
	-v $SHAPSHOT_WAR:/recovery/app-server/pfs.war \
	-h $CONTAINER --name  $CONTAINER $PLATFORM_N3
