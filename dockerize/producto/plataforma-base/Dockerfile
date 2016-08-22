#########################################################################
# RECOVERY- PLATAFORMA PRODUCTO
# Imágen Base
#------------------------------------------------------------------------
# Esta imágen constituye el primer nivel de la plataforma y es la base para
#  la construcción del segundo nivel
#
#    NIVEL1 (*)   NIVEL 2        NIVEL 3
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
# $ docker build --no-cache=true -t producto/plataforma-base .
#########################################################################

# Imágen de partida (disponible en el repo público de Docker)
FROM java:6-jre

## Variables requeridas (deben informarse en el nivel 2)
# ENV BASE_SO_GROUP   # Especificamos usuario y grupo del 
# ENV BASE_SO_USER    #  so con el que ejecutremos la
                      #  aplicación

# Versión de JAVA instalada en la imágen
ENV JAVA_VERSION 1.6

# Ruta de instalación de Java
ENV JAVA_HOME /usr/lib/jvm/java-6-openjdk-amd64

# Directorio en el que se va a escribir la información en tiempo de ejecución
#  de los contenedores que generemos
ENV CONTAINER_INFO_DIR /container-info


# Directorio base en el que se almacenarán los ficheros de instalación
ENV BASE_INSTALLER_DIR /pfssettup


###########################################################################
# Instalación directa. Estos paso son ejecutados por Docker al generar la 
#    imágen.
###########################################################################
# Instalamos: vi, ssh y less
RUN apt-get update && apt-get -y install ssh vim less \
	&& echo "sshd : ALL" >> /etc/hosts.allow \
	&& mkdir -p $BASE_INSTALLER_DIR/base-setup && mkdir -p $BASE_INSTALLER_DIR/utils

COPY base-setup $BASE_INSTALLER_DIR/base-setup
COPY utils $BASE_INSTALLER_DIR/utils

RUN chmod +x $BASE_INSTALLER_DIR/base-setup/*.sh && chmod +x $BASE_INSTALLER_DIR/utils

ENV PATH $PATH:$BASE_INSTALLER_DIR/base-setup:$BASE_INSTALLER_DIR/utils

###########################################################################
# Instalación diferida. Para completar la instalación deberá ejecutarse
#  el script $BASE_INSTALLER_DIR/base-setup/base-setup.sh desde dentro
#  del contenedor.
###########################################################################