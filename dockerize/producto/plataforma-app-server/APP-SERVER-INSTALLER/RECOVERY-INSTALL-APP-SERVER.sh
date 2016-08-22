#!/bin/bash

source RECOVERY-INSTALL-APP-SERVER.properties

LOCAL_PATH=`pwd`
APP_SERVER_PATH=${WEB_INSTALL_PATH//\//\\/}
WEB_WAR_PATH=$(echo $WEB_WAR_PATH | sed "s/\//\\\\\//g")
WEB_MASTER_DSNAME=$(echo $WEB_MASTER_DSNAME | sed "s/\//\\\\\//g")
WEB_ENTITY_DSNAME=$(echo $WEB_ENTITY_DSNAME | sed "s/\//\\\\\//g")

echo 'CONFIG_VALUES=( 'APP_SERVER_PATH' 'WEB_MASTERUSER' 'WEB_MASTER_DSNAME' 'WEB_MASTER_SCHEMA' 'WEB_RECOVERY_JMX_PORT' )' > $INSTALLER_ENV_FILE
echo 'TOMCAT_CFG_VALUES=( 'WEB_HTTP_PORT' 'WEB_WAR_PATH' 'WEB_MASTER_DSNAME' 'WEB_ENTITY_DSNAME' 'WEB_MASTERUSER' 'WEB_MASTEPLAINPASSWD' 'WEB_ENTITY1USER' 'WEB_ENTITY1LAINPASSWD' 'WEB_DBHOST' 'WEB_DBPORT' 'WEB_DBSID' )' >> $INSTALLER_ENV_FILE
echo 'TOMCAT_RUN_VALUES=( 'TOMCAT_JMX_PORT' 'TOMCAT_MEM_PARAMS' )' >> $INSTALLER_ENV_FILE

source $INSTALLER_ENV_FILE

if [ "x$TOMCAT_MEM_PARAMS" == "x" ]; then
	TOMCAT_MEM_PARAMS="-Xmx512m -XX:MaxPermSize=150m"
fi

for param in "${CONFIG_VALUES[@]}"
do
    sed -i "s/$param/${!param}/g" RECOVERY-INSTALL-APP-SERVER-files/devon.properties
done

for param in "${TOMCAT_CFG_VALUES[@]}"
do
    sed -i "s/$param/${!param}/g" RECOVERY-INSTALL-APP-SERVER-files/server.xml
done

for param in "${TOMCAT_RUN_VALUES[@]}"
do
    sed -i "s/$param/${!param}/g" RECOVERY-INSTALL-APP-SERVER-files/startTomcat.sh
done


echo "[INFO] Copiando fichero de configuración..."
cp RECOVERY-INSTALL-APP-SERVER-files/devon.properties $WEB_INSTALL_PATH  
cp RECOVERY-INSTALL-APP-SERVER-files/startTomcat.sh $WEB_INSTALL_PATH  
cp RECOVERY-INSTALL-APP-SERVER-files/server.xml $CATALINA_HOME/conf/server.xml
chmod +x $WEB_INSTALL_PATH/startTomcat.sh

echo "[INFO] Copiando WARs..."
cp RECOVERY-INSTALL-APP-SERVER-files/*.war $WEB_INSTALL_PATH  
echo "[INFO] Creando directorios..."
mkdir $WEB_INSTALL_PATH/log
mkdir $WEB_INSTALL_PATH/pfs
mkdir $WEB_INSTALL_PATH/pfs/temporaryFiles
mkdir $WEB_INSTALL_PATH/birt
echo "[INFO] Desempaquetando Birt..."
cp RECOVERY-INSTALL-APP-SERVER-files/ReportEngine.tar.gz $WEB_INSTALL_PATH/birt
cd $WEB_INSTALL_PATH/birt
tar xfz ReportEngine.tar.gz
rm ReportEngine.tar.gz
cd $LOCAL_PATH
echo "[INFO] Fin de la instalación *****"
