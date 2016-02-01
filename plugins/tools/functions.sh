function install_war () {
	local TOMCAT_HOME=$1
	local WAR=$2
	local NEWWAR=$3
	local LOGFILE=$4
	local FILE=$5
	local ACTION=$6
	

	local OP=""
	echo -n "Sobreescribir $WAR con la version nueva [s|N]: "
	read OP
	if [ x$OP == "xs" ] || [ x$OP == "xS" ]; then
		local BKFILE="${WAR}.BK.$(date -I)"
		echo "Sobreescribiendo $WAR. Se deja una copia de seguridad en $BKFILE"
		cp $WAR $BKFILE && mv $NEWWAR $WAR
		 
		
		echo -n "Limpiando directorios de tomcat: "
		if [ -d $TOMCAT_HOME/work ]; then
			rm -Rf $TOMCAT_HOME/work/*
			echo -n "work "
		else
			echo -n "work[NOT FOUND] "
		fi
		if [ -d $TOMCAT_HOME/temp ]; then
			rm -Rf $TOMCAT_HOME/temp/*
			echo -n "temp "
		else
			echo -n "temp[NOT FOUND] "
		fi
		
		if [ -d $TOMCAT_HOME/webapps ]; then
			rm -Rf $TOMCAT_HOME/webapps/*
			echo -n "webapps "
		else
			echo -n "webapps[NOT FOUND] "
		fi
		echo ""
		
		echo "$ACTION $FILE en fecha $(date)." >> $LOGFILE
	else
		echo "Fichero generado en $(readlink -f $NEWWAR)"
	fi
}

function check_tomcat () {
	local SERVICE="org.apache.catalina.startup.Bootstrap"
	local USERGREP="$(id -u)"

	if ps n -eo pid,user,args | grep $USERGREP | grep -v grep | grep $SERVICE  > /dev/null ; then
		exit_with_error "El tomcat esta arrancado, debe pararse"
	fi
}

function check_entorno () {
	if [ $(whoami) != "$1" ]; then
		exit_with_error "Debe conectarse con el usuario $1"
	fi
}

function unzip_file () {
	check_command unzip
	check_command readlink


	local DIR=$2
	local FILE=$(readlink -f $1)
	local CURRENT=$(pwd)
	echo "Desempaquetando $FILE"	

	mkdir -p $DIR
	cd $DIR
	unzip -o -q $FILE
	cd $CURRENT
	
}

function get_property () {
	local FILE=$1
	local PROP=$2
	
	local VALUE="$(cat $FILE | grep "${PROP}=" | tail -n 1 | cut -f2 -d=)"
	if [ -z $VALUE ]; then
		exit_with_error "No se ha definido la propiedad $PROP en $FILE"
	fi
	echo $VALUE
}


function check_command () {
	if [ -z "$(whereis $1 | cut -f2 -d:)" ]; then
		exit_with_error "No se ha podido encontrar el comando $1"
	fi
}


function check_no_file () {
	if [ -f $1 ]; then 
		exit_with_error $2
	fi
}
function check_file () {
	if [ ! -f $1 ]; then 
		exit_with_error "No se ha podido encontrar el fichero $1"
	fi
}

function check_no_dir () {
	if [ -d $1 ]; then 
		exit_with_error $2
	fi
}
function check_dir () {
	if [ ! -d $1 ]; then 
		exit_with_error "No se ha podido encontrar el directorio $1"
	fi
}

function exit_with_error () {
	echo "ERROR $*" >&2
	exit 1
}