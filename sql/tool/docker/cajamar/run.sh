#!/bin/bash

CLIENTE=CAJAMAR
CONTAINER_NAME=cajamar-bbdd
IMAGE_NAME=filemon/oracle_11g
DOCKER_PS="$(docker ps -a | grep $CONTAINER_NAME)"
SQL_PACKAGE_DIR=$(pwd)/../../../tool/tmp/package
DUMP_DIRECTORY=$(pwd)/DUMP

# Estado de la BBDD
CURRENT_DUMP_NAME=export_cajamar_13Ago2015.dmp
STARTING_TAG=cj-dmp-13ago


OPTION_REMOVE=no
OPTION_IGNORE_DUMP=no

if [[ "x$@" != "x" ]]; then
	for op in $@; do
		if [[ "x$op" == "x-remove" ]]; then
			OPTION_REMOVE=yes
		elif [[ "x$op" == "x-ignoredmp" ]]; then
			OPTION_IGNORE_DUMP=yes
		elif [[ "x$op" == x-dmpdir=* ]]; then
			DUMP_DIRECTORY=$(echo $op | cut -f2 -d=)
		fi
	done
else
	echo "(Re)iniciando entorno $CONTAINER_NAME"
	echo "Uso: $0 [-remove] [-ignoredmp] [-dmpdir=<directorio dumps>]"
	echo "    -remove: Indicar este parámetro si se quiere volver a generar el contenedor"
	echo "    -ignoredmp: Continua la ejecución si no encentra el DUMP"
	echo "    -dmpdir=: Especifica dónde está el directorio de los DUMPS"
	echo "                  por defecto $DUMP_DIRECTORY"
	echo ""
fi


cd $(pwd)/$(dirname $0)

function package_sql () {
	local current_dir=$(pwd)
	cd ../../../..
	echo -n "[INFO]: Pitertul - Empaquetando desde $(pwd): "
	./sql/tool/package-scripts-from-tag.sh $1 $2 >/dev/null
	if [[ $? -eq 0 ]]; then
		echo "OK"
	else
		echo "FALLO"
		exit 1
	fi
	
	cd $current_dir
}


function run_and_install () {
	if [[ -f $DUMP_PATH ]]; then
		package_sql $STARTING_TAG $CLIENTE
		chmod -R go+w $SQL_PACKAGE_DIR/*
		chmod +x $SQL_PACKAGE_DIR/DDL/*.sh
		chmod +x $SQL_PACKAGE_DIR/DML/*.sh
	fi
	echo -n "[INFO]: $CONTAINER_NAME: Generando el contenedor a partir de la imágen [$IMAGE_NAME]: "
	docker run -d -p=22 -p 1521:1521 \
				-v /etc/localtime:/etc/localtime:ro \
				-v $(pwd):/setup \
				-v $DUMP_DIRECTORY:/DUMP \
				-v $SQL_PACKAGE_DIR:/sql-package \
				-h $CONTAINER_NAME --name $CONTAINER_NAME $IMAGE_NAME \
	 && $INSTALL_CMD

}

function remove () {
	echo -n "[INFO]: Borrando el contenedor: "
	docker rm $CONTAINER_NAME
}

function stop () {
	echo -n "[INFO]: Parando el contenedor: "
	docker stop $CONTAINER_NAME
}

function start () {
	echo -n "[INFO]: Arrancando el contenedor: "
	docker start $CONTAINER_NAME
}


function check_dump () {
	if [ -d $DUMP_DIRECTORY ]; then
		echo "[INFO]: Directorio para dumps: $DUMP_DIRECTORY"
		DUMP_PATH=$DUMP_DIRECTORY/$CURRENT_DUMP_NAME
		if [[ ! -f $DUMP_PATH ]]; then
			if [[ "x$OPTION_IGNORE_DUMP" == "xyes" ]]; then
				echo "$DUMP_PATH: No se ha encontrado el fichero. No se va a cargar el dump"
				echo -n "Pulsa [ENTER] para continuar: "; read ENTER
			else
				echo "[ERROR]: $DUMP_PATH No se ha podido encontrar. Abortando.	"
				echo "[ERROR]: Añade la opción -ignoredmp al comando para ingorar."
				exit 1
			fi
		fi
	else
		echo "[ERROR]: $DUMP_DIRECTORY El directorio no existe. Abortando."
		exit 1
	fi
}

function show_install_info () {
	echo "[INFO]: Se va a restaurar la BBDD. Esto implica un borrado de la BBDD y una re-generación"
	echo "[INFO]: Dump de partida = $CURRENT_DUMP_NAME"
	echo "[INFO]: Tag (Git) de partida = $STARTING_TAG"
}


INSTALL_CMD="$(pwd)/install.sh $CURRENT_DUMP_NAME $STARTING_TAG $CONTAINER_NAME"

if [[ "x$DOCKER_PS" == "x" ]]; then
	# Si el contenedor no existe
	show_install_info
	check_dump
	echo "[INFO]: El contenedor está parado. Se va a generar desde cero a partir de la imágen."
	echo "[INFO]: Si la imágen $IMAGE_NAME no existe en el repositorio Docker local puede que tarde un poco en descargarse."
	run_and_install
else
	# Si el contenedor ya existe
	stop

	if [[ "x$OPTION_REMOVE" == "xyes" ]]; then
		# Si queremos volver a generar el contenedor
		show_install_info
		check_dump
		remove
		run_and_install
	else
		start
	fi
fi




#docker exec -ti oracle-cajamar /setup/install.sh
