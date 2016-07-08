#!/bin/bash
PLATFORM_N1=producto/plataforma-base
PLATFORM_N2=producto/plataforma-app-server
PLATFORM_N3=rem/rem-web
CONTAINER=rem-web

docker stop $CONTAINER && \
	docker rm $CONTAINER && \
	docker rmi $PLATFORM_N3 && \
	docker rmi $PLATFORM_N2 && \
	docker rmi $PLATFORM_N1