#!/bin/bash

CURRENT_DUMP_NAME=$1
shift
STARTING_TAG=$1
shift
CONTAINER_NAME=$1
shift 
CUSTOM_NLS_LANG=$1
shift
CUSTOM_LANG=$1
shift
OPTION_RANDOM_DUMP=$1
shift
OPTION_REMOVE=$1
shift
DOCKER_INNER_ERROR_LOG=$1
shift
OPTION_IGNORE_DUMP=$1
shift
OPTIONAL_IMPDP_OPTIONS=$1
shift

if [[ "x$CURRENT_DUMP_NAME" == "x" || "x$STARTING_TAG" == "x" || "x$CONTAINER_NAME" == "x" 
		|| "x$CUSTOM_NLS_LANG" == "x" || "x$CUSTOM_LANG" == "x" || "x$OPTION_RANDOM_DUMP" == "x" || "x$OPTION_REMOVE" == "x"
		|| "x$DOCKER_INNER_ERROR_LOG" == "x" || "x$OPTION_IGNORE_DUMP" == "x" ]]; then
	echo "[ERROR]: No se puede continuar con la instalación de la BD"
	echo "[ERROR]: Uso: $0 CURRENT_DUMP_NAME STARTING_TAG CONTAINER_NAME CUSTOM_NLS_LANG OPTION_RANDOM_DUMP OPTION_REMOVE DOCKER_INNER_ERROR_LOG OPTION_IGNORE_DUMP"
	exit 1
fi

if [[ "$OPTION_IGNORE_DUMP" != "yes" && "$OPTION_IGNORE_DUMP" != "no" ]]; then
	echo "[ERROR]: valor incorrecto para OPTION_IGNORE_DUMP: $OPTION_IGNORE_DUMP"
	exit 1
fi

CONTAINER_SETUP_DIR=/setup
INNER_DUMP_DIRECTORY=/DUMP

# OUTSIDE DOCKER
DUMP_FILE_OUT_DOCKER=DUMP/$CURRENT_DUMP_NAME
if [[ "x$(hostname)" != "x$CONTAINER_NAME" ]]; then
	docker exec $CONTAINER_NAME /setup/install.sh "$CURRENT_DUMP_NAME" "$STARTING_TAG" "$CONTAINER_NAME" "$CUSTOM_NLS_LANG" \
				"$CUSTOM_LANG" "$OPTION_RANDOM_DUMP" "$OPTION_REMOVE" "$DOCKER_INNER_ERROR_LOG" "$OPTION_IGNORE_DUMP" "$OPTIONAL_IMPDP_OPTIONS"
	exit $?
fi

# INSIDE DOCKER
touch /setup/.test

if [[ -f /setup/SQL-SCRIPTS/listener.ora ]]; then
	cp /setup/SQL-SCRIPTS/listener.ora  /home/oracle/app/oracle/product/11.2.0/dbhome_2/network/admin/listener.ora
else
	echo "<Docker [$CONTAINER_NAME]>:[ERROR] Falta el script /setup/SQL-SCRIPTS/listener.ora. No se puede continuar."
	exit 1
fi

if [[ $? -ne 0 ]]; then
	echo "<Docker [$CONTAINER_NAME]>: ERROR no se puede escribir en el WORKSPACE"
	echo -e "\t\t Tool Version = $(cat /setup/version.txt)"
	exit 1
else
	rm /setup/.test
fi
export ORACLE_SID=orcl

echo "<Docker [$CONTAINER_NAME]>: Seteando LOCALES"
CMD="export LANG=$CUSTOM_LANG"
echo $CMD | tee -a /home/oracle/.bashrc
$CMD
CMD="export NLS_LANG=$CUSTOM_NLS_LANG"
echo $CMD | tee -a /home/oracle/.bashrc
$CMD

cd $(pwd)/$(dirname $0)

echo "<Docker [$CONTAINER_NAME]>: Esperando a ORACLE"

while true
do
	if [[ "x$($ORACLE_HOME/bin/lsnrctl status orcl | grep READY)" != "x" ]]; then
		break
	fi
  	echo "<Docker [$CONTAINER_NAME]>: Esperando a que la instancia ORACLE esté disponile, esto puede tardar aproximadamente 1 min"
  	sleep 5
done

while true
do
	if [[ "x$(echo '' | $ORACLE_HOME/bin/sqlplus system/admin@localhost:1521/orcl @/setup/SQL-SCRIPTS/showdbstatus.sql | grep OPEN)" != "x" ]]; then
		break
	fi
  	echo "<Docker [$CONTAINER_NAME]>: Esperando a que la BD esté levantada, esto puede tardar unos segundos"
  	sleep 5
done

echo "<Docker [$CONTAINER_NAME]>: BD disponible: OK"

if [[ "x$OPTION_REMOVE" == "xyes" ]]; then
	export ORACLE_SID=orcl
	echo "<Docker [$CONTAINER_NAME]>: Limpiando el contenido de /oradata..."
	rm -Rf /oradata/* && \
	mkdir -p /oradata/flash && \
	mkdir -p /oradata/redo

	if [[ $? -ne 0 ]]; then
		echo "<Docker [$CONTAINER_NAME]>:[ERROR] Ha ocurrido un error al limpiar /oradata"
		echo -e "\t\t Tool Version = $(cat /setup/version.txt)"
		exit 1
	fi

	echo "<Docker [$CONTAINER_NAME]>: configurando acceso para SYSTEM"
	$ORACLE_HOME/bin/sqlplus system/admin@localhost:1521/orcl @/setup/SQL-SCRIPTS/alter-system-user.sql &>/dev/null
	if [[ $? -ne 0 ]]; then
		echo "<Docker [$CONTAINER_NAME]>:[ERROR] Ha ocurrido un error al configurar el acceso para SYSTEM"
		echo -e "\t\t Tool Version = $(cat /setup/version.txt)"
		exit 1
	fi
	nls_lang_file=/setup/SQL-SCRIPTS/nls_parameters_$CUSTOM_NLS_LANG.sql
	if [[ -f $nls_lang_file ]]; then
		echo "<Docker [$CONTAINER_NAME]>: configurando NLS_PARAMETERS ($CUSTOM_NLS_LANG)"
		$ORACLE_HOME/bin/sqlplus / as sysdba @${nls_lang_file}
		if [[ $? -ne 0 ]]; then
			echo "<Docker [$CONTAINER_NAME]>:[ERROR] Ha ocurrido un error al configurar los NLS_PARAMETERS"
			echo -e "\t\t Tool Version = $(cat /setup/version.txt)"
			exit 1
		fi
	else
		echo "<Docker [$CONTAINER_NAME]>: [WARNING] se van a dejar los NLS_PARAMETERS por defecto en la BD"
		ffound=no
		for p in $(find /setup/SQL-SCRIPTS -name nls_parameter*); do
			echo "<Docker [$CONTAINER_NAME]>: [WARNING] $(basename $p): fichero de parámetros encontrado"
			ffound=si
		done
		if [[ "x$ffound" == "xsi" ]]; then
			echo "<Docker [$CONTAINER_NAME]>: [WARNING] ¿quieres usar alguno de los ficheros encontrados?."
			echo "<Docker [$CONTAINER_NAME]>: [WARNING] cambia el NLS_LANG o renombra el fichero."
		fi
	fi
	
	echo "<Docker [$CONTAINER_NAME]>: creando tablespaces y directorios..."
	$ORACLE_HOME/bin/sqlplus system/admin@localhost:1521/orcl @/setup/SQL-SCRIPTS/tablespaces-scripts.sql
	if [[ $? -ne 0 ]]; then
		echo "<Docker [$CONTAINER_NAME]>:[ERROR] Ha ocurrido un error al crear los tablespaces"
		echo -e "\t\t Tool Version = $(cat /setup/version.txt)"
		exit 1
	fi
	$ORACLE_HOME/bin/sqlplus system/admin@localhost:1521/orcl @/setup/SQL-SCRIPTS/directories-scripts.sql
	if [[ $? -ne 0 ]]; then
		echo "<Docker [$CONTAINER_NAME]>:[ERROR] Ha ocurrido un error al configurar los directorios de Oracle"
		echo -e "\t\t Tool Version = $(cat /setup/version.txt)"
		exit 1
	fi
	chmod go+rw /oradata/*
fi



DUMP_FILE_PATH=$INNER_DUMP_DIRECTORY/$CURRENT_DUMP_NAME
if [[ -f $DUMP_FILE_PATH  ]]; then
	echo "<Docker [$CONTAINER_NAME]>: Importando dump de la bbdd.."
	echo "<Docker [$CONTAINER_NAME]>: $ORACLE_HOME/bin/impdp system/admin@localhost:1521/orcl DIRECTORY=scripts dumpfile=$CURRENT_DUMP_NAME logfile=SYSTMP:$CURRENT_DUMP_NAME.import.log $OPTIONAL_IMPDP_OPTIONS"
	if [[ "x$OPTIONAL_IMPDP_OPTIONS" != "x" ]]; then
		echo $OPTIONAL_IMPDP_OPTIONS > /setup/impdp.params
		chmod o+rw /setup/impdp.params
		$ORACLE_HOME/bin/impdp system/admin@localhost:1521/orcl DIRECTORY=scripts dumpfile=$CURRENT_DUMP_NAME logfile=SYSTMP:$CURRENT_DUMP_NAME.import.log parfile=/setup/impdp.params
	else
		$ORACLE_HOME/bin/impdp system/admin@localhost:1521/orcl DIRECTORY=scripts dumpfile=$CURRENT_DUMP_NAME logfile=SYSTMP:$CURRENT_DUMP_NAME.import.log
	fi

	if [[ $? -ne 0 ]]; then
		if [[ "$OPTION_IGNORE_DUMP" != "yes" ]]; then
			echo "<Docker [$CONTAINER_NAME]>:[ERROR] Ha ocurrido un error al importar el dump"
			echo -e "\t\t Tool Version = $(cat /setup/version.txt)"
			exit 1
		else
			echo "<Docker [$CONTAINER_NAME]>:[WARNING] Ha ocurrido algún error al importar el dump"
		fi
	fi

	if [[ "x$OPTION_REMOVE" == "xyes" ]]; then
		echo "<Docker [$CONTAINER_NAME]>: Asignando passwords a usuarios de la BD..."
		$ORACLE_HOME/bin/sqlplus system/admin@localhost:1521/orcl @/setup/SQL-SCRIPTS/database-passwords.sql
		if [[ $? -ne 0 ]]; then
			echo "<Docker [$CONTAINER_NAME]>:[ERROR] Ha ocurrido un error al cambiar los passwords de la BD"
			echo -e "\t\t Tool Version = $(cat /setup/version.txt)"
			exit 1
		fi

		echo "<Docker [$CONTAINER_NAME]>: Configurando ENTIDADCONFIG..."
		$ORACLE_HOME/bin/sqlplus system/admin@localhost:1521/orcl @/setup/SQL-SCRIPTS/dml-entidadconfig-update.sql
		if [[ $? -ne 0 ]]; then
			echo "<Docker [$CONTAINER_NAME]>:[ERROR] Ha ocurrido un error al configurar ENTIDADCONFIG"
			echo -e "\t\t Tool Version = $(cat /setup/version.txt)"
			exit 1
		fi
	fi

	if [[ "x$OPTION_RANDOM_DUMP" != "xyes" ]]; then
		/setup/execute-scripts.sh $CONTAINER_NAME $DOCKER_INNER_ERROR_LOG $CUSTOM_NLS_LANG
		if [[ $? -ne 0 ]]; then
			echo "<Docker [$CONTAINER_NAME]>:[ERROR] Ha fallado la ejecución de scripts"
			echo -e "\t\t Tool Version = $(cat /setup/version.txt)"
			exit 1
		fi
	else
		echo "<Docker [$CONTAINER_NAME]>: No se van a ejecutar scripts DDL ni DML"
	fi
else
	echo "*************************** WARNING *******************************"
	echo "<Docker [$CONTAINER_NAME]>: $DUMP_FILE_PATH: No existe el fichero no se va a importar el DUMP"
	echo "******************************************************************"
fi

if [[ "x$OPTION_REMOVE" == "xyes" ]]; then
	echo "<Docker [$CONTAINER_NAME]>: preparando el modo flashback..."
	$ORACLE_HOME/bin/sqlplus / as sysdba @/setup/SQL-SCRIPTS/enable_flahsback.sql
	if [[ $? -ne 0 ]]; then
		echo "<Docker [$CONTAINER_NAME]>:[ERROR] Ha ocurrido un error al preparar el modo flashback"
		echo -e "\t\t Tool Version = $(cat /setup/version.txt)"
		exit 1
	fi
fi
