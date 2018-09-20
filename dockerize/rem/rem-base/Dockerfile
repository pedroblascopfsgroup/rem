#########################################################################
# PROYECTO: HAYA - REM
# APLICACIÓN: application-server (modo maqueta)
#
# Para construir la imágen
# $ docker build --no-cache=true -t rem/base .
#
# Para arrancar el contenedor por primera vez
# $ docker run -d -p=80 -h rem-base --name  rem-base rem/base
# 
# Para acceder al contenedor directamente (por ejemplo para cambiar el password)
# $ docker exec -ti rem-base /bin/bash
#
# Para ver el log
# $ docker logs -f rem-base
#########################################################################
FROM httpd:2.4

RUN apt-get update && apt-get -y install curl unzip libc6-i386

# Variables de configuración
ENV INSTALL_DIR /haya-rem

ENV JAVA_VERSION 1.8.0_60
ENV JAVA_7_URL http://nexus.pfsgroup.es/nexus/service/rest/repository/browse/thirdparty/oracle-java/jre/$JAVA_VERSION/jre-$JAVA_VERSION.zip
ENV ART_REPO_USER queryman@pfsgroup.es
ENV ART_REPO_PASSWD "4'Nz^Ojf~v"

# Java 7
RUN mkdir /$INSTALL_DIR \
	&& cd /$INSTALL_DIR \
	&& curl -u $ART_REPO_USER:$ART_REPO_PASSWD -X GET $JAVA_7_URL > jre.zip \
	&& unzip -q jre.zip \
	&& rm jre.zip

ENV JAVA_HOME $INSTALL_DIR/jre-$JAVA_VERSION
ENV PATH $PATH:$JAVA_HOME/bin

WORKDIR $INSTALL_DIR
