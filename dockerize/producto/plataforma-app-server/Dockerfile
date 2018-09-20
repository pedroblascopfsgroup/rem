#########################################################################
# RECOVERY- PLATAFORMA PRODUCTO
# App Server
# 
#------------------------------------------------------------------------
# Esta imágen constituye el segundo de la plataforma. Esta imágen es 
#    el punto de partid para generar entornos web 
#
#    NIVEL1      NIVEL 2 (*)    NIVEL 3
#
#                            / cliente-1-web
#          	____ app-server  - cliente-2-web
#          /                 \ cliente-3-web
#         /
#        /                   / cliente-1-batch
#    base ------ batch-sever - cliente-2-batch
#        \                   \ cliente-3-batch
#         \
#          \                / cliente-1-msg-broker
#           \___ msg-broker - cliente-2-msg-broker
#                           \ cliente-3-msg-broker
# 
# $ docker build --no-cache=true -t producto/plataforma-app-server .
#########################################################################

# Imágen de partida, debe existir en el repo local
FROM producto/plataforma-base


# Especificamos el usuario y grupo con que ejecutaremos la aplicación
ENV BASE_SO_GROUP recweb
ENV BASE_SO_USER recweb

# Indicamos qué parte de la Arquitectura estamos construyendo
#  - application-server
#  - batch-server
#  - message-broker
ENV RECOVERY_APPLICATION application-server

# Seteamos el DEVON_HOME
ENV DEVON_HOME recovery/app-server

# Especificamos en qué directorio vamos a copiar el isntalador
ENV WEB_INSTALLER_DIR $BASE_INSTALLER_DIR/APP-SERVER-INSTALLER
ENV WEB_INSTALLER_FILES $WEB_INSTALLER_DIR/RECOVERY-INSTALL-APP-SERVER-files

# Especificamos con qué usuario/password nos conectamos a los repositoris de artefactos
ENV WEB_REPO_USER queryman@pfsgroup.es
ENV WEB_REPO_PASSWD "4'Nz^Ojf~v"

# Especificamos la ruta de la que nos vamos a descargar el isntalador
ENV WEB_BASE_ZIP_URL http://nexus.pfsgroup.es/nexus/repository/releases/installation/cajamar/RECOVERY-INSTALL-APP-SERVER-files/1.0/RECOVERY-INSTALL-APP-SERVER-files-1.0.zip

# Especificamos las ruta de instalación
ENV WEB_INSTALL_PATH /$DEVON_HOME

#  Datos de instalación del Tomcat
ENV CATALINA_HOME $WEB_INSTALL_PATH/tomcat
ENV TOMCAT_MAJOR 6
ENV TOMCAT_VERSION 6.0.44
ENV TOMCAT_TGZ_URL https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

# Datos para la instalación de JAMON Api.
ENV WEB_JAMON_VERSION 2.71
ENV WEB_JAMONALL_URL http://nexus.pfsgroup.es/nexus/repository/thirdparty/jamonapi/jamonall/2.71/jamonall-2.71.zip
ENV WEB_ORACLE_JDBC_DRIVER_URL http://nexus.pfsgroup.es/nexus/repository/thirdparty/batch/libraries/ojdbc14/STABLE/ojdbc14-STABLE.jar
ENV WEB_ORACLE_JDBC_DRIVER_VERSION 14-STABLE

# Especificamos el nombre que debe tener el WAR
ENV WEB_WAR_NAME pfs.war

# Especificamos en qué ruta vamos a desplegar el WAR
ENV WEB_WAR_PATH $WEB_INSTALL_PATH/$WEB_WAR_NAME

# Indicamos cual va a ser el script que genere el entorno de ejecución de la aplicación
ENV INSTALLER_ENV_FILE $INSTALL_PATH/setInstallerEnv.sh

# Especificamos dónde almacenamos las utilidades
ENV WEB_UTILS_PATH $WEB_INSTALL_PATH/utils

# Directorio en el que dejaremos el contenido que queremos que se despliegue
#   automáticamente
ENV WEB_AUTO_DEPLOY_DIR /autodeploy

###########################################################################
# Instalación directa. Estos paso son ejecutados por Docker al generar la 
#    imágen.
###########################################################################

# Creamos la estructura de directorios básicas
#
RUN mkdir -p $WEB_INSTALLER_DIR && \
	mkdir -p $BASE_INSTALLER_DIR/app-server-setup

COPY app-server-setup $BASE_INSTALLER_DIR/app-server-setup

RUN chmod +x $BASE_INSTALLER_DIR/app-server-setup/*.sh 

ENV PATH $PATH:$BASE_INSTALLER_DIR/app-server-setup
##############################################################

#
# Copiamos la estructura del paquete de instalación
#
COPY APP-SERVER-INSTALLER $WEB_INSTALLER_DIR

RUN chmod +x $WEB_INSTALLER_DIR/*.sh
##############################################################

#
# Nos descargamos y copiamos los ficheros del paquete de intalación
#
WORKDIR $WEB_INSTALLER_FILES

RUN curl -u $WEB_REPO_USER:$WEB_REPO_PASSWD -X GET $WEB_BASE_ZIP_URL > versions.zip

RUN unzip -q versions.zip

#########################################################################
# Instalación de Tomcat
#########################################################################
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

RUN set -x \
	&& curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
	&& curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
	&& tar -xf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz*

#########################################################################
# Activamos JAMON
#########################################################################
WORKDIR $WEB_INSTALLER_DIR

# Descarga e instalación de JAMON
RUN curl -u $WEB_REPO_USER:$WEB_REPO_PASSWD -X GET $WEB_JAMONALL_URL > jamonall.zip \
	&& unzip -q jamonall.zip -d jamonall \
	&& cp jamonall/binaries/jamon-$WEB_JAMON_VERSION.jar $CATALINA_HOME/lib \
	&& cp jamonall/binaries/jamon.war $CATALINA_HOME/webapps

# Descarga e instalación del driver de Oracle en Tomcat
RUN curl -u $WEB_REPO_USER:$WEB_REPO_PASSWD -X GET $WEB_ORACLE_JDBC_DRIVER_URL > ojdbc$WEB_ORACLE_JDBC_DRIVER_VERSION.jar \
	&& cp ojdbc$WEB_ORACLE_JDBC_DRIVER_VERSION.jar $CATALINA_HOME/lib


#########################################################################
# Finalizamos la configuración del servidor
#########################################################################

WORKDIR $WEB_INSTALL_PATH

ENV PATH $PATH:$WEB_UTILS_PATH

###########################################################################
# Instalación diferida. Para completar la instalación deberá ejecutarse
#  el script $BASE_INSTALLER_DIR/app-server-setup/app-server-setup.sh desde dentro
#  del contenedor.
###########################################################################
