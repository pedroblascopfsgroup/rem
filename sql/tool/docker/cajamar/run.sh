#!/bin/bash

#
# Formas de ejecutar la utilidad
#
# No re-generar la BBDD
# ./run.sh | ./run.sh -help: Mostramos mensaje de ayuda y salimos
# ./run.sh -restart: Reiniciar la BBDD
#
# Regenerar en MODO 1: línea base
# ./run.sh -remove [-oradata=<directorio datafiles>] [-ignoredmp] [-dmpdir=<directorio dumps>]
#
# Regenerar en MODO 2: importar un DUMP aleatorio
# ./run.sh -impdp=<fichero_dump_a_importar> [-oradata=<directorio datafiles>]


CLIENTE=CAJAMAR
CONTAINER_NAME=cajamar-bbdd
CUSTOM_NLS_LANG=SPANISH_SPAIN.WE8MSWIN1252
IMAGE_NAME=filemon/oracle_11g
DOCKER_PS="$(docker ps -a | grep $CONTAINER_NAME)"
SQL_PACKAGE_DIR=$(pwd)/../../../tool/tmp/package
DUMP_DIRECTORY=$(pwd)/DUMP
ORADATA_HOST_DIR=~/oradata-$CONTAINER_NAME
SET_ENV_FILE=~/setEnvGlobal$CLIENTE.sh

# Estado de la BBDD
CURRENT_DUMP_NAME=export_cajamar_13Ago2015.dmp
STARTING_TAG=cj-dmp-13ago


OPTION_REMOVE=no
OPTION_IGNORE_DUMP=no
OPTION_RANDOM_DUMP=no
OPTION_RESTART=no

function show_help () {
	echo "Uso: "
	echo " MODO 1: $0 [-help] [-remove] [-restart] [-oradata=<directorio datafiles>] [-ignoredmp] [-dmpdir=<directorio dumps>]"
	echo " MODO 2: $0 -impdp=<fichero_dump_a_importar> [-help] [-oradata=<directorio datafiles>]"
	echo "    -help: Sólo imprime un mensaje de ayuda"
	echo "    -restart: Indicar para reiniciar la BBDD"
	echo "    -remove: Indicar este parámetro si se quiere volver a generar el contenedor, implica reiniciar"
	echo "    -oradata=: Especifica el diretorio del host en dóde se almacenarán los DATAFILES"
	echo "                  por defecto $ORADATA_HOST_DIR. Sólo sirve si hacemos un -remove"
	echo " MODO 1. Línea base."
	echo "    -ignoredmp: Continua la ejecución si no encentra el DUMP"
	echo "    -dmpdir=: Especifica dónde está el directorio de los DUMPS"
	echo "                  por defecto $DUMP_DIRECTORY"
	echo " MODO 2. Importar un dump aleatorio."
	echo "    -impdp=: Realiza un import dle dump que le digamos. Esta opción implica un -remove."
	echo "                  Este modo ignora los siguientes parámetros si se indican: -ignoredmp, -dmpdir"
	echo ""
}

if [[ ! -f $SET_ENV_FILE ]]; then
	echo "No se ha encontrado $SET_ENV_FILE, no puedo continuar"
	exit 1
fi

if [[ "x$@" != "x" ]]; then
	for op in $@; do
		if [[ "x$op" == "x-remove" ]]; then
			OPTION_REMOVE=yes
			OPTION_RESTART=yes
		elif [[ "x$op" == "x-restart" ]]; then
			OPTION_RESTART=yes
		elif [[ "x$op" == "x-ignoredmp" ]]; then
			OPTION_IGNORE_DUMP=yes
		elif [[ "x$op" == x-dmpdir=* ]]; then
			DUMP_DIRECTORY=$(echo $op | cut -f2 -d=)
		elif [[ "x$op" == x-oradata=* ]]; then
			ORADATA_HOST_DIR=$(echo $op | cut -f2 -d=)
		elif [[ "x$op" == x-impdp=* ]]; then
			param=$(echo $op | cut -f2 -d=)
			DUMP_DIRECTORY=$(dirname $param)
			CURRENT_DUMP_NAME=$(basename $param)
			OPTION_RANDOM_DUMP=yes
			OPTION_REMOVE=yes
			OPTION_RESTART=yes
		elif [[ "x$op" == "x-help" ]]; then
			show_help
			exit 0
		fi
	done
else
	echo "[INFO]: Mostramos el mensaje de ayuda al no especificar parámetros."
	show_help
fi

cd $(pwd)/$(dirname $0)

function package_sql () {
	if [[ "x$OPTION_RANDOM_DUMP" != "xyes" ]]; then
		local current_dir=$(pwd)
		cd ../../../..
		echo -n "[INFO]: Pitertul - Empaquetando desde $(pwd): "
		if [[ "x$ORACLE_HOME" == "x" ]]; then
			export ORACLE_HOME=empty
		fi
		./sql/tool/package-scripts-from-tag.sh $1 $2 >/dev/null
		if [[ $? -eq 0 ]]; then
			echo "OK"
		else
			echo "FALLO"
			exit 1
		fi

		cd $current_dir
	fi
}


function run_container () {
	if [[ ! -d $DUMP_DIRECTORY ]]; then
		echo "[INFO]: Se ha creado el directorio requerido $DUMP_DIRECTORY"
		mkdir -p $DUMP_DIRECTORY
	fi
	if [[ ! -d $SQL_PACKAGE_DIR ]]; then
		echo "[INFO]: Se ha creado el directorio requerido $SQL_PACKAGE_DIR"
		mkdir -p $SQL_PACKAGE_DIR
	fi
	if [[ ! -d $ORADATA_HOST_DIR ]]; then
		echo "[INFO]: Se ha creado el directorio requerido $ORADATA_HOST_DIR"
		mkdir -p $ORADATA_HOST_DIR
		chmod go+w $ORADATA_HOST_DIR
	fi
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
				-v $ORADATA_HOST_DIR:/oradata \
				-h $CONTAINER_NAME --name $CONTAINER_NAME $IMAGE_NAME

}

function remove_container () {
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

	if [[ "x$OPTION_RANDOM_DUMP" == "xyes" ]]; then
		echo "[WARNING]: Importaremos un DUMP \"no oficial\" = $CURRENT_DUMP_NAME"
		echo "[WARNING]: El no hay correspondencia entre el DUMP a importar y un TAG en Git"
	else
		echo "[INFO]: Dump de partida = $CURRENT_DUMP_NAME"
		echo "[INFO]: Tag (Git) de partida = $STARTING_TAG"
	fi
	echo "[INFO]: Almacenamiento de los datafiles = $ORADATA_HOST_DIR"
}


INSTALL_CMD="$(pwd)/install.sh $CURRENT_DUMP_NAME $STARTING_TAG $CONTAINER_NAME $CUSTOM_NLS_LANG $OPTION_RANDOM_DUMP $OPTION_REMOVE"


if [[ "x$DOCKER_PS" == "x" ]]; then
	# Si el contenedor no existe
	show_install_info
	check_dump
	echo "[INFO]: El contenedor está parado. Se va a generar desde cero a partir de la imágen."
	echo "[INFO]: Si la imágen $IMAGE_NAME no existe en el repositorio Docker local puede que tarde un poco en descargarse."
	run_and_install
else
	# Si el contenedor ya existe
	if [[ "x$OPTION_RESTART" == "xyes" ]]; then
		echo "[INFO]: (Re)iniciando entorno $CONTAINER_NAME"
		stop
	fi

	if [[ "x$OPTION_REMOVE" == "xyes" || "x$OPTION_RANDOM_DUMP" == "xyes" ]]; then
		show_install_info
		check_dump
		if [[ "x$OPTION_REMOVE" == "xyes" ]]; then
			remove_container
			run_container
		fi
		if [[ $? -eq 0 ]]; then
			$INSTALL_CMD
		fi

		run_and_install
	fi

	if [[ "x$OPTION_RESTART" == "xyes" ]]; then
		start
	fi
fi