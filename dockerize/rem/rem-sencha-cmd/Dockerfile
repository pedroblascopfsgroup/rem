#########################################################################
# PROYECTO: Piloto REOs
# APLICACIÓN: application-server (modo maqueta)
#
# Para construir la imágen
# $ docker build --no-cache=true -t rem/sencha-cmd .
#
# Para arrancar el contenedor por primera vez
# $ docker run -d -p=80 -h rem-sencha-cmd --name  rem-sencha-cmd rem/sencha-cmd
# 
# Para acceder al contenedor directametne (por ejemplo para cambiar el password)
# $ docker exec -ti rem-sencha-cmd /bin/bash
#
# Para ver el log
# $ docker logs -f rem-sencha-cmd
#########################################################################
FROM rem/base

RUN apt-get update && apt-get install -y ruby rubygems fontconfig

# Variables de configuración
# ENV INSTALL_DIR -> Variable que heredamos de rem/base

ENV SENCHA_VERSION 6.0.1.76
ENV SENCHA_CMD_URL http://nexus.pfsgroup.es/nexus/repository/thirdparty/sencha/sencha-cmd/$SENCHA_VERSION/sencha-cmd-$SENCHA_VERSION.zip
ENV ART_REPO_USER queryman@pfsgroup.es
ENV ART_REPO_PASSWD "4'Nz^Ojf~v"

# Instalamos Sencha Cmd
RUN cd $INSTALL_DIR \
	&& curl -u $ART_REPO_USER:$ART_REPO_PASSWD -X GET $SENCHA_CMD_URL > sencha-cmd.zip \
	&& unzip -q sencha-cmd.zip \
	&& rm sencha-cmd.zip

# Actualizamos permisos
RUN chmod 777 $INSTALL_DIR/Sencha/Cmd

# Solucionamos bug en la instalación de sencha cmd
RUN cd $INSTALL_DIR/Sencha/Cmd/$SENCHA_VERSION/bin && ln -s linux-x64/ linux

# Copiamos el script para hacer el build de /input a /output
COPY sh $INSTALL_DIR/sh

ENV PATH $PATH:$INSTALL_DIR/Sencha/Cmd/$SENCHA_VERSION:$INSTALL_DIR/sh

RUN chmod +rx $INSTALL_DIR/sh/*

WORKDIR $INSTALL_DIR
