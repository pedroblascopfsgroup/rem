#!/bin/bash

echo ""
echo ""
echo "Se va a cambiar la configuración del contenedor $PROJECT::$RECOVERY_APPLICATION [$HOSTNAME]"
echo ""
echo ""

#####################################################################################
# Comprobación de parámetros
ERROR=0
NEWP="<perfil>"

if [ "x$1" != "x" ]; then
	NEWP=$1
else
	echo "Especifica el nombre del perfil."
	ERROR=1
fi

SETENV_PATH=$CONTAINER_INFO_DIR/$PROJECT/$HOSTNAME/setEnv_$NEWP.sh

if [ ! -f $SETENV_PATH ]; then
	echo "Se espera el siguiente fichero con la configuarción del perfil:"
	echo -e "\t- $SETENV_PATH"
	ERROR=1
fi

if [ $ERROR -ne 0 ]; then
	echo "Abortando."
	exit 1
fi

#####################################################################################
# Actualizamos la información sobre el entorno
mkdir -p ~/environment.d/
for f in ~/environment.d/*; do source $f; done

#####################################################################################
# Carga de variables de entorno
CHANGED__ENV=""
function __ENV () {
	export OLD_$1="${!1}"
	CHANGED_ENV="$CHANGED_ENV""$1 "
}

function show_changes () {
	echo "Se aplicarán los siguientes cambios: "
	echo "---------------------------------------"
	for var in $CHANGED_ENV; do
		local var_old="OLD_$var"
		local var_new=$var
		local changed=""

		local old_value="${!var_old}"
		local new_value=${!var_new}
		if [ "$old_value" != "$new_value" ]; then 
			changed='(*)'
			echo "# created $(date)" > ~/environment.d/$var
			echo "export ${var}=${new_value}" >> ~/environment.d/$var
		fi
		echo -e "$changed\t$var: $old_value--> $new_value"
	done
	echo "---------------------------------------"
}

__ENV MASTER_DSNAME
__ENV ENTITY_DSNAME

__ENV DBHOST
__ENV DBPORT
__ENV DBSID 

__ENV MASTER_SCHEMA
__ENV MASTERUSER
__ENV MASTERENCPASSWD
__ENV MASTEPLAINPASSWD

__ENV ENTITY1USER
__ENV ENTITY1ENCPASSWD
__ENV ENTITY1LAINPASSWD

source $SETENV_PATH

show_changes

#####################################################################################
# Cambiamos los ficheros de configuración
source $INSTALLER_ENV_FILE

# devon.properties
mkdir -p /$DEVON_HOME/devon.properties.save
cp /$DEVON_HOME/devon.properties /$DEVON_HOME/devon.properties.save/devon.properties.save.$(date +%Y%m%d.%H%M)
echo "Actualizando devon.properties"

for param in "${CONFIG_VALUES[@]}"
do
	new_value="${!param}"
	param_old=OLD_$param
	param_old_value=${!param_old}
		
	if [ "x$new_value" != "x" ] && 
			[ "x$param_old_value" != "x" ] && 
			[ "$param_old_value" != "$new_value" ]
	then
		echo -e "\t$param_old_value -> $new_value"
    	sed -i "s/$param_old_value/$new_value/g" /$DEVON_HOME/devon.properties
    fi
done

# server.xml
mkdir -p $INSTALL_PATH/tomcat/conf/server.xml.save
cp $INSTALL_PATH/tomcat/conf/server.xml $INSTALL_PATH/tomcat/conf/server.xml.save/server.xml.save.$(date +%Y%m%d.%H%M)
echo "Actualizando server.xml"

for param in "${TOMCAT_CFG_VALUES[@]}"
do
	new_value="${!param}"
	param_old=OLD_$param
	param_old_value=${!param_old}
		
	if [ "x$new_value" != "x" ] && 
			[ "x$param_old_value" != "x" ] && 
			[ "$param_old_value" != "$new_value" ]
	then
		echo -e "\t$param_old_value -> $new_value"
    	sed -i "s/$param_old_value/$new_value/g" $INSTALL_PATH/tomcat/conf/server.xml
    fi
done

#####################################################################################
# Actualizamos la info de estado actual
writeInfo.sh