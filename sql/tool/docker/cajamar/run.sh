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
WORKSPACE_DIR=$(pwd)/.workspace

# Estado de la BBDD
CURRENT_DUMP_NAME=export_cajamar_13Ago2015.dmp
STARTING_TAG=cj-dmp-13ago


OPTION_REMOVE=no
OPTION_IGNORE_DUMP=no
OPTION_RANDOM_DUMP=no
OPTION_RESTART=no
OPTION_PITERDEBUG=no
OPTION_FLASHBACK_MODE=no
OPTION_SCRIPTS_MODE=no

DOCKER_INNER_ERROR_LOG=/tmp/scriptslog/error.log
VAR_OUTTER_ERROR_LOG=""
VAR_SCRIPTS_DONE=no
VAR_STARTING_TAG_CHANGED=no
VAR_WORKSPACE_CHANGED=no

function show_help () {
	echo "Uso: "
	echo " MODO 1: $0 [-help] [-remove] [-restart] [-oradata=<directorio datafiles>] [-ignoredmp] [-dmpdir=<directorio dumps>]"
	echo "            [-errorlog=<fichero_logs>] [-piterdebug]"
	echo " MODO 2: $0 -impdp=<fichero_dump_a_importar> [-remove] [-help] [-oradata=<directorio datafiles>]"
	echo " MODO 3: $0 -flashback [-help]"
	echo " MODO 4: $0 -scripts [-help] [-errorlog=<fichero_logs>] [-piterdebug] [-fromtag=<tag_de_partida>]"
	echo " -------------------------------------------------------------------------------------------------------------------"
	echo " OPCIONES GENERALES"
	echo "    -help: Sólo imprime un mensaje de ayuda"
	echo "    -restart: Indicar para reiniciar la BBDD"
	echo "    -oradata=: Especifica el diretorio del host en dóde se almacenarán los DATAFILES"
	echo "                  por defecto $ORADATA_HOST_DIR. Sólo sirve si hacemos un -remove o -impdp"
	echo "    -workspace=: Cambia el workspace de la tool. Esta opción es útil si montamos una"
	echo "                 Pipeline de integración contínua, en caso contrario no tiene sentido especificarlo"
	echo ""
	echo " OPCIONES MODO 1. Línea base."
	echo "    -remove: Indicar este parámetro si se quiere volver a generar el contenedor, implica reiniciar"
	echo "    -ignoredmp: Continua la ejecución si no encentra el DUMP"
	echo "    -dmpdir=: Especifica dónde está el directorio de los DUMPS"
	echo "                  por defecto $DUMP_DIRECTORY"
	echo "    -errorlog=: Fichero en el que queremos volcar la salida de los scripts DxL"
	echo "    -piterdebug: Habilita el modo debug al empaquetar con la Pitertul"
	echo ""
	echo " OPCIONES MODO 2. Importar un dump aleatorio."
	echo "    -impdp=: Realiza un import del dump que le digamos. Esta opción implica un -remove."
	echo "                  Este modo ignora los siguientes parámetros si se indican: -ignoredmp, -dmpdir"
	echo "    -remove: Indicar este parámetro si se quiere volver a generar el contenedor, implica reiniciar"
	echo "                  Esta opción es redundante en este modo ya que -impdp siempre implica un remove"
	echo ""
	echo " OPCIONES MODO 3. Modo Flashback, punto de restauración"
	echo "    -flashback: Pone la BBDD en modo flashback creando un punto de restauración. Se sale del modo"
	echo "                  mediante Ctrl+C. Al salir se ofrecen dos opciones: restaurar o confirmar"
	echo ""
	echo " OPCIONES MODO 4. Ejecución de scripts"
	echo "    -errorlog=: Fichero en el que queremos volcar la salida de los scripts DxL"
	echo "    -piterdebug: Habilita el modo debug al empaquetar con la Pitertul"
	echo "    -fromtag=: Ejecuta los scripts a partir del tag seleccionado"
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
		elif [[ "x$op" == x-errorlog=* ]]; then
			VAR_OUTTER_ERROR_LOG=$(echo $op | cut -f2 -d=)
			log_name=$(basename $VAR_OUTTER_ERROR_LOG)
			DOCKER_INNER_ERROR_LOG=$(dirname $DOCKER_INNER_ERROR_LOG)/$log_name
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
		elif [[ "x$op" == "x-piterdebug" ]]; then
			OPTION_PITERDEBUG=yes
		elif [[ "x$op" == "x-flashback" ]]; then
			OPTION_FLASHBACK_MODE=yes
		elif [[ "x$op" == "x-scripts" ]]; then
			OPTION_SCRIPTS_MODE=yes
		elif [[ "x$op" == x-fromtag=* ]]; then
			STARTING_TAG=$(echo $op | cut -f2 -d=)
			VAR_STARTING_TAG_CHANGED=yes
		elif [[ "x$op" == x-workspace=* ]]; then
			WORKSPACE_DIR=$(echo $op | cut -f2 -d=)
			VAR_WORKSPACE_CHANGED=yes
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
		
		if [[ "x$ORACLE_HOME" == "x" ]]; then
			export ORACLE_HOME=empty
		fi

		if [[ "x$OPTION_PITERDEBUG" == "xyes" ]]; then
			echo "[INFO]: Pitertul - Empaquetando desde $(pwd): "
			echo "<<<<<<<<<< PITERTUL DEBUG MODE ON >>>>>>>>>>>>>"
			OLD_T=$TERM
			export TERM=dumb
			./sql/tool/package-scripts-from-tag.sh $1 $2
			if [[ $? -eq 0 ]]; then
				echo "<<<<<<<<<< PITERTUL DEBUG MODE OFF >>>>>>>>>>>>>"
				TERM=$OLD_T
			else
				echo "<<<<<<<<<<    PITERTUL FAILURE    >>>>>>>>>>>>>"
				exit 1
			fi
		else
			echo -n "[INFO]: Pitertul - Empaquetando desde $(pwd): "
			./sql/tool/package-scripts-from-tag.sh $1 $2 &>/dev/null
			if [[ $? -eq 0 ]]; then
				echo "OK"
			else
				echo "FALLO"
				exit 1
			fi
		fi
		ws_package_dir=$WORKSPACE_DIR/package
		rm -Rf $ws_package_dir
		cp -R $SQL_PACKAGE_DIR $ws_package_dir
		chmod -R go+w $ws_package_dir/*
		chmod +x $ws_package_dir/DDL/*.sh
		chmod +x $ws_package_dir/DML/*.sh

		cd $current_dir
		
	fi
}


function run_container () {
	local errorlog_volume=""

	mkdir -p $WORKSPACE_DIR
	rm -Rf $WORKSPACE_DIR/*
	cp $(pwd)/*.sh $WORKSPACE_DIR && chmod ugo+rx $WORKSPACE_DIR/*.sh
	cp -R $(pwd)/SQL-SCRIPTS $WORKSPACE_DIR && chmod ugo+r $WORKSPACE_DIR/SQL-SCRIPTS/*

	if [[ "x$VAR_OUTTER_ERROR_LOG" != "x" ]]; then
		outter_log_dir=$(dirname $VAR_OUTTER_ERROR_LOG)
		errorlog_volume="-v ${outter_log_dir}:$(dirname $DOCKER_INNER_ERROR_LOG):rw"
	fi

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
		VAR_SCRIPTS_DONE=yes
	fi
	echo -n "[INFO]: $CONTAINER_NAME: Generando el contenedor a partir de la imágen [$IMAGE_NAME]: "
	docker run -d -p=22 -p 1521:1521 \
				-v /etc/localtime:/etc/localtime:ro \
				-v $WORKSPACE_DIR:/setup $errorlog_volume \
				-v $DUMP_DIRECTORY:/DUMP \
				-v $ORADATA_HOST_DIR:/oradata \
				-h $CONTAINER_NAME --name $CONTAINER_NAME $IMAGE_NAME

}

function remove_container () {
	echo "[INFO]: Se va a restaurar la BBDD. Esto implica un borrado de la BBDD y una re-generación"
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
	

	if [[ "x$OPTION_RANDOM_DUMP" == "xyes" ]]; then
		echo "[WARNING]: Importaremos un DUMP \"no oficial\" = $CURRENT_DUMP_NAME"
		echo "[WARNING]: Puede que no haya correspondencia entre el DUMP a importar y un TAG en Git"
	else
		echo "[INFO]: Dump de partida = $CURRENT_DUMP_NAME"
		echo -n "[INFO]: Tag (Git) de partida = $STARTING_TAG"
		if [[ "x$VAR_STARTING_TAG_CHANGED" == "xyes" ]]; then
			echo " (* no es la opción por defecto)"
		else
			echo ""
		fi
	fi
	echo "[INFO]: Almacenamiento de los datafiles = $ORADATA_HOST_DIR"
}


function do_install () {
	$(pwd)/install.sh $CURRENT_DUMP_NAME $STARTING_TAG $CONTAINER_NAME $CUSTOM_NLS_LANG $OPTION_RANDOM_DUMP $OPTION_REMOVE $DOCKER_INNER_ERROR_LOG
}

function restore_or_confirm_flahsback () {
	echo "[INFO] Saliendo del modo flashback"
	echo "Por favor introduce una opción"
	echo " 1: Confirmar"
	echo " 2: Restaurar"
	echo -n "flashback> "
	read IN
	case $IN in
		1 )
			echo "Al realizar esta operación los cambios realizados en BBDD serán permanentes"
			echo -n "¿Estás seguro? [s/N] "; read IN 
			if [[ "x$IN" == "xs" || "x$IN" == "xs" ]]; then
				echo "[INFO] Confirmando estado de la BBDD"
				$(pwd)/flashback.sh $CONTAINER_NAME confirm
				exit $?
			fi
			;;
		2)
			echo "Al realizar esta operación se revertirán los cambios realizados en la BBDD Volviendo"
			echo -n "¿Estás seguro? [s/N] "; read IN 
			if [[ "x$IN" == "xs" || "x$IN" == "xs" ]]; then
				echo "[INFO] Restaurando el estado de la BBDD"
				$(pwd)/flashback.sh $CONTAINER_NAME restore
				exit $?
			fi
			;;
	esac
	echo "[INFO] Volviendo al modo Flashback"
	echo "Pulsa Ctrl + C para salir"
}

show_install_info
# Creamos el workspace
if [[ "x$VAR_WORKSPACE_CHANGED" == "xyes" ]]; then
	echo "[WARNING] Se va a usar el siguiente directorio como WORKSPACE: $WORKSPACE_DIR"
fi

if [[ "x$VAR_OUTTER_ERROR_LOG" != "x" ]]; then
	outter_log_dir=$(dirname $VAR_OUTTER_ERROR_LOG)
	if [[ ! -f VAR_OUTTER_ERROR_LOG ]]; then
			mkdir -p $outter_log_dir
			touch $VAR_OUTTER_ERROR_LOG
			chmod go+rw $VAR_OUTTER_ERROR_LOG
		fi
fi

if [[ "x$DOCKER_PS" == "x" ]]; then
	# Si el contenedor no existe
	OPTION_REMOVE=yes
	check_dump
	echo "[INFO]: El contenedor está parado. Se va a generar desde cero a partir de la imágen."
	echo "[INFO]: Si la imágen $IMAGE_NAME no existe en el repositorio Docker local puede que tarde un poco en descargarse."
	run_container
	if [[ $? -eq 0 ]]; then
		do_install
		if [[ $? -ne 0 ]]; then
			echo "[ERROR]: No se ha podido generar $CONTAINER_NAME"
			exit 1
		fi
	fi
else
	# Si el contenedor ya existe
	if [[ "x$OPTION_RESTART" == "xyes" ]]; then
		echo "[INFO]: (Re)iniciando entorno $CONTAINER_NAME"
		stop
	fi

	if [[ "x$OPTION_REMOVE" == "xyes" || "x$OPTION_RANDOM_DUMP" == "xyes" ]]; then
		if [[ "x$OPTION_SCRIPTS_MODE" == "xno" && "x$VAR_STARTING_TAG_CHANGED" == "xno" ]]; then
			show_install_info
			check_dump
			if [[ "x$OPTION_REMOVE" == "xyes" ]]; then
				remove_container
				run_container
			fi
			if [[ $? -eq 0 ]]; then
				do_install
				if [[ $? -ne 0 ]]; then
					echo "[ERROR]: No se ha podido generar $CONTAINER_NAME"
					exit 1
				fi
			fi
		else
			echo "[WARNING] Se han indicado opciones imcompatibles"
			if [[ "x$OPTION_SCRIPTS_MODE" == "xyes" ]]; then
				echo "[WARNING] La opción -scripts es incompatible con "
			fi
			if [[ "x$VAR_STARTING_TAG_CHANGED" == "xyes" ]]; then
				echo "[WARNING] La opción -fromtag es incompatible con -remove o -impdp"
			fi
		fi
	fi

	if [[ "x$OPTION_FLASHBACK_MODE" == "xyes" ]]; then
		trap restore_or_confirm_flahsback SIGINT
		echo "[INFO] Entrando en modo flashback"
		echo "[INFO] Creando un punto de restauración de la BBDD"
		$(pwd)/flashback.sh $CONTAINER_NAME create
		echo "Pulsa Ctrl + C para salir del modo Flhasback"
		while true; do sleep 5; done
	fi

	if [[ "x$OPTION_SCRIPTS_MODE" == "xyes" && "x$VAR_SCRIPTS_DONE" == "xno"
			&& "x$OPTION_RANDOM_DUMP" == "xno"  && "x$OPTION_REMOVE" == "xno" ]]; then
		echo "[INFO] Empaquetando y ejecutando scripts DDL y DML"
		package_sql $STARTING_TAG $CLIENTE
		$(pwd)/execute-scripts.sh $CONTAINER_NAME $DOCKER_INNER_ERROR_LOG
	fi

	if [[ "x$OPTION_RESTART" == "xyes" ]]; then
		start
	fi
fi