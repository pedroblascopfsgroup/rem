#!/bin/bash

$(pwd)/$(dirname $0)/showbanner.sh
echo ""

# Se esperan  que estén cargadas las siguientes variables en el contexto del bash
# Oblitatorias
# - PROJECT_BASE
# - CLIENTE
# - CUSTOM_NLS_LANG
# - CUSTOM_LANG
# - CURRENT_DUMP_NAME
# - STARTING_TAG
# - CONTAINER_NAME
# Opcionales
# - OPTIONAL_IMPDP_OPTIONS

if [[ "x$PROJECT_BASE" == "x" || "x$CLIENTE" == "x" || "x$CUSTOM_NLS_LANG" == "x" || "x$CUSTOM_LANG" == "x" 
	|| "x$CURRENT_DUMP_NAME" == "x" || "x$STARTING_TAG" == "x" || "x$CONTAINER_NAME" == "x" ]]; then
	echo "[ERROR] No se puede iniciar por no encontrar la configuración en las variables de entorno."
	exit 1
fi


IMAGE_NAME=filemon/oracle_11g
SQL_PACKAGE_DIR=$(pwd)/../../../tool/tmp/package
DUMP_DIRECTORY=$(pwd)/DUMP
ORADATA_HOST_DIR=~/oradata-$CONTAINER_NAME
SET_ENV_FILE=~/setEnvGlobal$CLIENTE.sh
WORKSPACE_DIR=$PROJECT_BASE/.workspace
TAG_LISTS_FILE=$(pwd)/../../../../tags-list.txt
PACKAGE_TAGS_DIR=$(pwd)/../../../../package-tags

OPTION_REMOVE=no
OPTION_IGNORE_DUMP=no
OPTION_RANDOM_DUMP=no
OPTION_RESTART=no
OPTION_PITERDEBUG=no
OPTION_FLASHBACK_MODE=no
OPTION_SCRIPTS_MODE=no
OPTION_STATISTICS=no
OPTION_PORT=1521

DOCKER_INNER_ERROR_LOG=/tmp/scriptslog/error.log
VAR_OUTTER_ERROR_LOG=""
VAR_SCRIPTS_DONE=no
VAR_STARTING_TAG_CHANGED=no
VAR_WORKSPACE_CHANGED=no
VAR_DB_EXISTS=no

function show_help () {
	echo "Uso: "
	echo " MODO 1: $0 [-help] [-remove] [-restart] [-oradata=<directorio datafiles>] [-port=<oracle port>] [-name=<containte name>]"
	echo "            [-ignoredmp] [-dmpdir=<directorio dumps>] [-errorlog=<fichero_logs>] [-piterdebug]"
	echo " MODO 2: $0 -impdp=<fichero_dump_a_importar> [-remove] [-help] [-oradata=<directorio datafiles>] [-port=<oracle port>]"
	echo "            [-name=<containte name>]"
	echo " MODO 3: $0 -flashback [-help]"
	echo " MODO 4: $0 -scripts [-help] [-errorlog=<fichero_logs>] [-piterdebug] [-fromtag=<tag_de_partida>]"
	echo " -------------------------------------------------------------------------------------------------------------------"
	echo " OPCIONES GENERALES"
	echo "    -help: Sólo imprime un mensaje de ayuda"
	echo "    -restart: Indicar para reiniciar la BD"
	echo "    -oradata=: Especifica el diretorio del host en dóde se almacenarán los DATAFILES"
	echo "                  por defecto $ORADATA_HOST_DIR. Sólo sirve si hacemos un -remove o -impdp"
	echo "    -workspace=: Cambia el workspace de la tool. Esta opción es útil si montamos una"
	echo "                 Pipeline de integración contínua, en caso contrario no tiene sentido especificarlo"
	echo "    -statistics: Actualiza las estadísticas en la BD"
	echo "    -port=: Puerto por el que escuchará la BBDD"
	echo "    -name=: Nombre que le queremos dar al contenedor"
	echo ""
	echo " OPCIONES MODO 1. Línea base."
	echo "    -remove: Indicar este parámetro si se quiere volver a generar el contenedor, implica reiniciar"
	echo "    -ignoredmp: Continua la ejecución si no encentra el DUMP o si ocurren errores al importar"
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
	echo " OPCIONES MODO 3. Modo Flashback, punto de restauración."
	echo "    -flashback: Pone la BD en modo flashback creando un punto de restauración. Se sale del modo"
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
		elif [[ "x$op" == "x-statistics" ]]; then
			OPTION_STATISTICS=yes
		elif [[ "x$op" == x-port=* ]]; then
			OPTION_PORT=$(echo $op | cut -f2 -d=)
		elif [[ "x$op" == x-name=* ]]; then
			CONTAINER_NAME=$(echo $op | cut -f2 -d=)
		else
			echo "[WARNING] desconozco esta opción: $op"
		fi
	done
else
	echo "[INFO]: Mostramos el mensaje de ayuda al no especificar parámetros."
	show_help
fi

DOCKER_PS="$(docker ps -a | grep $CONTAINER_NAME)"

cd $(pwd)/$(dirname $0)
##
# $1 -> tag
# $1 -> cliente
function package_sql () {
	if [[ "x$OPTION_RANDOM_DUMP" != "xyes" ]]; then
		local current_dir=$(pwd)
		local package_script=./sql/tool/package-scripts-from-tag.sh
		local tag_or_list=$1
		local cliente=$2
		POST_PKG_SCRIPTS_DIR=$WORKSPACE_DIR/post-package
		rm -Rf $WORKSPACE_DIR/package*
		rm -Rf $SQL_PACKAGE_DIR
		rm -Rf $PACKAGE_TAGS_DIR
		rm -Rf $POST_PKG_SCRIPTS_DIR
		cd ../../../..

		if [[ -d $PROJECT_BASE/post-package ]]; then
			cp -R $PROJECT_BASE/post-package $WORKSPACE_DIR
			chmod -R 777 $POST_PKG_SCRIPTS_DIR
		fi

		if [[ -f $TAG_LISTS_FILE ]]; then
			tag_or_list=$(basename $TAG_LISTS_FILE)
			echo "[WARNING]: Piterdebug: $tag_or_list encontrado"
			echo "[WARNING]: Piterdebug: Se va a realizar un empaquetado por etapas"
			package_script=./sql/tool/package-scripts-from-tags-list.sh
		fi
		
		if [[ "x$ORACLE_HOME" == "x" ]]; then
			export ORACLE_HOME=empty
		fi

		if [[ "x$OPTION_PITERDEBUG" == "xyes" ]]; then
			echo "[INFO]: Pitertul - Empaquetando desde $(pwd): "
			echo "<<<<<<<<<< PITERTUL DEBUG MODE ON >>>>>>>>>>>>>"
			OLD_T=$TERM
			export TERM=dumb
			$package_script $tag_or_list $cliente
			if [[ $? -eq 0 ]]; then
				echo "<<<<<<<<<< PITERTUL DEBUG MODE OFF >>>>>>>>>>>>>"
				TERM=$OLD_T
			else
				echo "<<<<<<<<<<    PITERTUL FAILURE    >>>>>>>>>>>>>"
				exit 1
			fi
		else
			echo -n "[INFO]: Pitertul - Empaquetando desde $(pwd): "
			$package_script $tag_or_list $cliente &>/dev/null
			if [[ $? -eq 0 ]]; then
				echo "OK"
			else
				echo "FALLO"
				exit 1
			fi
		fi
		if [[ -d $PACKAGE_TAGS_DIR ]]; then
			ws_package_dir=$WORKSPACE_DIR/package-tags
			SQL_PACKAGE_DIR=$PACKAGE_TAGS_DIR
		else
			ws_package_dir=$WORKSPACE_DIR/package
		fi

		cp -R $SQL_PACKAGE_DIR $ws_package_dir

		if [[ -d $POST_PKG_SCRIPTS_DIR ]]; then
			echo "[INFO]: Ejecutando scripts post-empaquetado"
			echo "[INFO]: Exportando variables [ws_package_dir] "
			export ws_package_dir
			for script in $POST_PKG_SCRIPTS_DIR/*; do
				echo "[INFO]: Ejecutando $(basename $script)"
				chmod +x $script
				$script
				if [[ $? -ne 0 ]]; then
					echo "[ERRR] Fallo al ejecutar $script"
					exit 1
				fi
			done
		fi

		chmod -R go+w $ws_package_dir
		for sh in $(find $ws_package_dir -name '*.sh'); do
			chmod ugo+x $sh
		done

		cd $current_dir
		
	fi
}


function run_container () {
	show_install_info

	local errorlog_volume=""

	mkdir -p $WORKSPACE_DIR
	rm -Rf $WORKSPACE_DIR/*
	cp $(pwd)/*.sh $WORKSPACE_DIR && chmod ugo+rx $WORKSPACE_DIR/*.sh
	cp -R $PROJECT_BASE/SQL-SCRIPTS $WORKSPACE_DIR
	if [[ -d $PROJECT_BASE/pre-scripts ]]; then
		cp -R $PROJECT_BASE/pre-scripts $WORKSPACE_DIR
		chmod 777 $WORKSPACE_DIR/pre-scripts
		chmod +x $WORKSPACE_DIR/pre-scripts/*.sh
	fi
	if [[ -d $PROJECT_BASE/post-scripts ]]; then 
		cp -R $PROJECT_BASE/post-scripts $WORKSPACE_DIR
		chmod 777 $WORKSPACE_DIR/post-scripts
		chmod +x $WORKSPACE_DIR/post-scripts/*.sh
	fi
	scripts_dir=$WORKSPACE_DIR/SQL-SCRIPTS/
	cp $(pwd)/sql-files/*.sql $scripts_dir
	cp $(pwd)/sql-files/listener.ora $scripts_dir
	chmod ugo+r $scripts_dir/*
	$(pwd)/showversion.sh > $WORKSPACE_DIR/version.txt
	chmod go+r $WORKSPACE_DIR/version.txt
	echo $WORKSPACE_DIR > $WORKSPACE_DIR/workspace.path

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
	elif [[ ! -z "$(ls -l $ORADATA_HOST_DIR | grep -v .dbf | grep -v flash | grep -v redo | grep -v total)" ]]; then
			echo "[ERROR] $ORADATA_HOST_DIR ya se está usando para otros propósitos."
			echo "[ERROR] $ORADATA_HOST_DIR sólo puede conener archivos DBF y los subdirectorios flash y redo."
			if [[ -z "$(which tree)" ]]; then
				ls -l $ORADATA_HOST_DIR
			else
				$(which tree) $ORADATA_HOST_DIR
			fi
			exit 1
	fi
	touch $ORADATA_HOST_DIR/test
	if [[ $? -eq 0 ]]; then
		rm $ORADATA_HOST_DIR/test
	else
		echo "[ERROR] $ORADATA_HOST_DIR : Permisos insuficientes."
		echo "[ERROR]     Prueba con chmod go+w $ORADATA_HOST_DIR"
		exit 1
	fi
	if [[ -f $DUMP_PATH ]]; then
		package_sql $STARTING_TAG $CLIENTE
		VAR_SCRIPTS_DONE=yes
	fi
	echo -n "[INFO]: $CONTAINER_NAME: Generando el contenedor a partir de la imágen [$IMAGE_NAME]: "
	docker run -d -p=22 -p $OPTION_PORT:1521 \
				-v /etc/localtime:/etc/localtime:ro \
				-v $WORKSPACE_DIR:/setup $errorlog_volume \
				-v $DUMP_DIRECTORY:/DUMP \
				-v $ORADATA_HOST_DIR:/oradata \
				-h $CONTAINER_NAME --name $CONTAINER_NAME $IMAGE_NAME

}

function remove_container () {
	echo "[INFO]: Se va a restaurar la BD. Esto implica un borrado de la BD y una re-generación"
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
	$(pwd)/install.sh "$CURRENT_DUMP_NAME" "$STARTING_TAG" "$CONTAINER_NAME" "$CUSTOM_NLS_LANG" "$CUSTOM_LANG" "$OPTION_RANDOM_DUMP" "$OPTION_REMOVE" \
						"$DOCKER_INNER_ERROR_LOG" "$OPTION_IGNORE_DUMP" "$OPTIONAL_IMPDP_OPTIONS"
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
			echo "Al realizar esta operación los cambios realizados en BD serán permanentes"
			echo -n "¿Estás seguro? [s/N] "; read IN 
			if [[ "x$IN" == "xs" || "x$IN" == "xs" ]]; then
				echo "[INFO] Confirmando estado de la BD"
				$(pwd)/flashback.sh $CONTAINER_NAME confirm
				exit $?
			fi
			;;
		2)
			echo "Al realizar esta operación se revertirán los cambios realizados en la BD Volviendo"
			echo -n "¿Estás seguro? [s/N] "; read IN 
			if [[ "x$IN" == "xs" || "x$IN" == "xs" ]]; then
				echo "[INFO] Restaurando el estado de la BD"
				$(pwd)/flashback.sh $CONTAINER_NAME restore
				exit $?
			fi
			;;
	esac
	echo "[INFO] Volviendo al modo Flashback"
	echo "Pulsa Ctrl + C para salir"
}

function verify_workspace () {
	local _ws
	if [[ ! -z "$(docker ps | grep $CONTAINER_NAME)" ]]; then
		_ws="$(docker exec $CONTAINER_NAME cat /setup/workspace.path)"
		if [[ "$WORKSPACE_DIR" == "$_ws" && -d $WORKSPACE_DIR ]]; then
			echo "[INFO] Directorio de trabajo verificado."
		else
			echo "[ERROR] El directorio de trabajo no coincide con el del contenedor, o no existe"
			echo -e "container ws dir = '$_ws'"
			exit 1
		fi
	else
		echo "[ERROR] $CONTAINER_NAME no está levantado."
		exit 1
	fi
}

# Creamos el workspace
if [[ "x$VAR_WORKSPACE_CHANGED" == "xyes" ]]; then
	echo "[INFO] Se va a usar el siguiente directorio como WORKSPACE: $WORKSPACE_DIR"
else
	echo "[WARNING] Se va a usar el siguiente directorio como WORKSPACE: $WORKSPACE_DIR"
	echo "[WARNING]  esto no es conveniente si se quiere conservar el estado de la BD independiente del repositorio de versiones."
	echo "[WARNING] Usa el parámetro -workspace para ocultar este aviso."
fi

if [[ ! -d $WORKSPACE_DIR ]]; then
	mkdir $WORKSPACE_DIR
	chmod go+rwx $WORKSPACE_DIR
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
	VAR_DB_EXISTS=yes
else
	VAR_DB_EXISTS=yes
	# Si el contenedor ya existe
	if [[ "x$OPTION_RESTART" == "xyes" ]]; then
		echo "[INFO]: (Re)iniciando entorno $CONTAINER_NAME"
		stop
	fi

	if [[ "x$OPTION_REMOVE" == "xyes" || "x$OPTION_RANDOM_DUMP" == "xyes" ]]; then
		if [[ "x$OPTION_SCRIPTS_MODE" == "xno" && "x$VAR_STARTING_TAG_CHANGED" == "xno" ]]; then
			check_dump
			if [[ "x$OPTION_REMOVE" == "xyes" ]]; then
				remove_container
				run_container
			fi
			if [[ $? -eq 0 ]]; then
				do_install
				if [[ $? -ne 0 ]]; then
					echo "[ERROR]: Han ocurrido errores al generar $CONTAINER_NAME"
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

	if [[ "x$OPTION_SCRIPTS_MODE" == "xyes" && "x$VAR_SCRIPTS_DONE" == "xno"
			&& "x$OPTION_RANDOM_DUMP" == "xno"  && "x$OPTION_REMOVE" == "xno" ]]; then
		echo "[INFO] Verificando directorio de trabajo..."
		verify_workspace
		echo "[INFO] Empaquetando y ejecutando scripts DDL y DML"
		package_sql $STARTING_TAG $CLIENTE
		$(pwd)/execute-scripts.sh $CONTAINER_NAME $DOCKER_INNER_ERROR_LOG $CUSTOM_NLS_LANG
        if [[ $? != 0 ]]; then
        	echo "[ERROR] Puedes consultar el log en $VAR_OUTTER_ERROR_LOG"
            exit 1
        fi
	fi

	if [[ "x$OPTION_RESTART" == "xyes" ]]; then
		start
	fi
fi

if [[ "x$VAR_DB_EXISTS" == "xyes" ]]; then
	if [[ "x$OPTION_STATISTICS" == "xyes" ]]; then
		echo "[INFO] Actualizando las estadísticas de la BD"
		$(pwd)/statistics.sh $CONTAINER_NAME
		if [[ $? -ne 0 ]]; then
			exit $?
		fi
	fi
	if [[ "x$OPTION_FLASHBACK_MODE" == "xyes" ]]; then
		trap restore_or_confirm_flahsback SIGINT
		echo "[INFO] Entrando en modo flashback"
		echo "[INFO] Creando un punto de restauración de la BD"
		$(pwd)/flashback.sh $CONTAINER_NAME create
		echo "Pulsa Ctrl + C para salir del modo Flhasback"
		while true; do sleep 5; done
	fi
else
	[ "x$OPTION_STATISTICS" == "xyes" ] && \
		echo "[WARNING] No actualizamos las estadístics porque no existe la BD ($CONTAINER_NAME)"

	[ "x$OPTION_FLASHBACK_MODE" == "xyes" ] && \
		echo "[WARNING] No habilitamos el modo flashback porque no existe la BD ($CONTAINER_NAME)"
fi
	