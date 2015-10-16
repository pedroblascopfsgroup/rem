PLATFORM_N1=producto/plataforma-base
PLATFORM_N2=producto/plataforma-app-server
PLATFORM_N3=haya/haya-web


IMAGE_ID=$(docker images | grep "$PLATFORM_N3" | awk '{print $3}')

if [[ "x$SHAPSHOT_WAR" != "x" ]]; then
	if [[ ! -f $SHAPSHOT_WAR ]]; then
		echo "ERROR: $(basename $SHAPSHOT_WAR) No se ha encontrado. ¿Has empaquetado?"
		exit 1
	fi
fi

if [[ "x$1" == "x-remove" || "x$IMAGE_ID" == "x" ]]; then
	OPTION_REGENERA=yes
else
	OPTION_REGENERA=no
fi

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
		docker build --no-cache=true -t $PLATFORM_N1 plataforma/$PLATFORM_N1/.
		[ $? -ne 0 ] && exit 1
		echo -e "\n\n"
	fi
	echo "Generando imágen $PLATFORM_N2"
	sleep 1
	docker build --no-cache=true -t $PLATFORM_N2 plataforma/$PLATFORM_N2/.
	[ $? -ne 0 ] && exit 1
	echo -e "\n\n"
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