#!/bin/bash

echo "#########################################################################"
echo "# Instalación base del SO"
echo "#########################################################################"
export TERM=linux
export DEBIAN_FRONTEND=noninteractive

# Configuramos el usuario WEB_USER
groupadd $BASE_SO_GROUP && \
	useradd -s /bin/bash -g $BASE_SO_GROUP -p $(openssl passwd $BASE_SO_USER) $BASE_SO_USER && \
	mkdir /home/$BASE_SO_USER && \
	cp /root/.bashrc /home/$BASE_SO_USER/ && \
	cp /root/.profile /home/$BASE_SO_USER/ && \
	chown -R $BASE_SO_USER:$BASE_SO_GROUP /home/$BASE_SO_USER