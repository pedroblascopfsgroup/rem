#/bin/bash

# Ejecutamos la instalación base
base-setup.sh

echo "#########################################################################"
echo "# Instalación de Application Server"
echo "#########################################################################"


cd $WEB_INSTALLER_FILES
if [ -z "$USE_LOCAL_WAR_FILE" ]; then
	echo "[INFO] Descargamos el WAR de NEXUS"
	rm -Rf $WEB_WAR_NAME \
		&& curl -u $WEB_REPO_USER:$WEB_REPO_PASSWD -X GET $WEB_ZIP_URL > $WEB_WAR_NAME
	else
		echo "[WARNING] No nos descargamos el WAR de NEXUS"
		echo "[INFO] Copimamos el WAR: $USE_LOCAL_WAR_FILE"
		if [ -f $USE_LOCAL_WAR_FILE ]; then
			cp $USE_LOCAL_WAR_FILE $WEB_WAR_NAME
		else
			echo "[ERROR] $WEB_WAR_NAME: No se ha encontrado el fichero"
			exit 1
		fi
fi


echo "# Ejecutamos el instalador del paquete"
cd $WEB_INSTALLER_DIR
mkdir -p $WEB_INSTALL_PATH \
		&& ./RECOVERY-INSTALL-APP-SERVER.sh

echo "# Configuramos las variables de entornos para el usuario web"
echo "export DEVON_HOME=$DEVON_HOME" >> /home/$BASE_SO_USER/.bashrc	\
		&& echo "export JAVA_HOME=$JAVA_HOME" >> /home/$BASE_SO_USER/.bashrc \
		&& echo "export CATALINA_HOME=$CATALINA_HOME" >> /home/$BASE_SO_USER/.bashrc


echo "# JAMON: Configuración del server.xml"
[ ! -f $CATALINA_HOME/conf/server.xml.nojamon ] && cp $CATALINA_HOME/conf/server.xml $CATALINA_HOME/conf/server.xml.nojamon \
	&& sed -i 's/\(<Engine name="Catalina" defaultHost="localhost">\)/\1\n\t \
        <Valve className="com.jamonapi.http.JAMonTomcatValve" \/>/g' $CATALINA_HOME/conf/server.xml \
	&& sed -i 's/oracle.jdbc.driver.OracleDriver/com.jamonapi.proxy.JAMonDriver/g' $CATALINA_HOME/conf/server.xml \
	&& sed -i 's/jdbc:oracle:thin:\(.*\)"/jdbc:jamon:oracle:thin:\1jamonrealdriver=oracle.jdbc.driver.OracleDriver"/g' $CATALINA_HOME/conf/server.xml


echo "# Abrimos puertos y configuramos el arranque del contenedor"
cp -R $BASE_INSTALLER_DIR/utils $WEB_UTILS_PATH
chmod +x $WEB_UTILS_PATH/*.sh
chown -R $BASE_SO_USER:$BASE_SO_GROUP $WEB_INSTALL_PATH

echo "Creamos el directorio $WEB_AUTO_DEPLOY_DIR en el que dejar las cosas que queremos que se auto desplieguesn"
mkdir $WEB_AUTO_DEPLOY_DIR

cd $WEB_INSTALL_PATH

echo '/etc/init.d/ssh start' > runAppServerInDocker.sh && \
	echo '$WEB_UTILS_PATH/writeInfo.sh' >> runAppServerInDocker.sh && \
	echo 'su - '$BASE_SO_USER' -c "cd $WEB_INSTALL_PATH && ./startTomcat.sh"' \
			>> runAppServerInDocker.sh && \
	echo 'sleep 5' >> runAppServerInDocker.sh && \
	echo 'su - '$BASE_SO_USER' -c "tail -F $WEB_INSTALL_PATH/log/pfs_web.log"' >> runAppServerInDocker.sh && \
	chmod +x runAppServerInDocker.sh

echo "# Borramos los instalables"	
rm -Rf $BASE_INSTALLER_DIR