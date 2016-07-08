#!/bin/bash
PLATFORM_N1=producto/plataforma-base
PLATFORM_N2=producto/plataforma-app-server
PLATFORM_N3=rem/rem-web

CONTAINER=rem-web

CURRENT_DIR=$(pwd)/$(dirname $0)
TMP_DIR_NAME=tmp
WAR_NAME=pfs-9.1-SNAPSHOT.war
SNAPSHOT_WAR=$CURRENT_DIR/../rem-web/target/$WAR_NAME
WAR_FILE=$CURRENT_DIR/$TMP_DIR_NAME/$WAR_NAME

DOCKER_IP=$(cat Dockerfile | grep "ENV WEB_DBHOST" | grep -v "#" | awk '{print $3}')
MY_IP=$(ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}')

# Cambiamos la info de Dockerfile con nuestra IP (cableada)
sed -i 's|$DOCKER_IP|$MY_IP|g' Dockerfile

# Comprobamos si hemos generado el WAR nos lo copiamos para tenerlo y luego lo borramos al terminar.
if [[ ! -f $SNAPSHOT_WAR ]]; then
	echo "[ERROR] No se ha encontrado $WAR_NAME, puede que sea necesario un mvn package"
	exit 1
fi
mkdir -p $TMP_DIR_NAME
cp -f $SNAPSHOT_WAR $WAR_FILE

echo "Fichero copiado en $WAR_FILE"
#function finish {
#  rm -Rf $TMP_DIR_NAME
#}
#trap finish EXIT

# Continuamos con lo nuestro.
echo "Validando instalación de la Plataforma Producto de Recovery"

if [ "x$(docker images | grep $PLATFORM_N2)" != "x" ]; then
	echo  "$PLATFORM_N2: Se ha encontrado la imagen requerida"
else
	echo "Falta algunas imágenes de la platarforma. Se van a reconstruir"
	if [ "x$(docker images | grep $PLATFORM_N1)" != "x" ]; then
		echo "$PLATFORM_N1: Se ha encontrado la imágen"
	else
		echo "Generando imágen $PLATFORM_N1"
		sleep 1
		docker build --no-cache=true -t $PLATFORM_N1 ../dockerize/$PLATFORM_N1/.
		[ $? -ne 0 ] && exit 1
		echo -e "\n\n"
	fi
	echo "Generando imágen $PLATFORM_N2"
	sleep 1
	docker build --no-cache=true -t $PLATFORM_N2 ../dockerize/$PLATFORM_N2/.
	[ $? -ne 0 ] && exit 1
	echo -e "\n\n"
fi

echo "Continuando"
sleep 1

echo "Comprobando si $CONTAINER está arrancado"
if [ "x$(docker ps | grep $CONTAINER)" != "x" ]; then
	docker stop $CONTAINER
fi


IMAGE_ID=$(docker images | grep "$PLATFORM_N3" | awk '{print $3}')

docker build --no-cache=true -t $PLATFORM_N3 .

if [ "x$(docker ps -a | grep $CONTAINER)" != "x" ]; then
	echo -n "Borrando conenedor: "
	docker rm $CONTAINER
fi

docker run -d -p=22 -p=8080 -v ${HOME}/container-info:/container-info -h $CONTAINER --name  $CONTAINER $PLATFORM_N3

echo "Borando imágen anterior"
if [ "x$IMAGE_ID" != "x" ]; then
	docker rmi $IMAGE_ID 
fi
