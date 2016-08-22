#!/bin/bash
PLATFORM_N3=rem/rem-web

CONTAINER=rem-web

SNAPSHOT=9.1-SNAPSHOT

# echo "Validando que la versión $SNAPSHOT (desarrollo) está empaquetada"
# if [[ ! -d $APP_DIR ]]; then
# 	echo "$APP_DIR: No se ha encontrado el directorio. Es necesario realizar un mvn package"
# 	exit 1
# fi

echo "$PLATFORM_N3: Comprobamos que exista la imágen"
if [ "x$(docker images | grep $PLATFORM_N3)" == "x" ]; then
	echo  "$PLATFORM_N3: No se ha encontrado la imágen. Debes dockerizar."
	exit 1
fi

echo "Comprobando si $CONTAINER está arrancado"
if [ "x$(docker ps | grep $CONTAINER)" != "x" ]; then
	echo -n "Parando contenedor: "
	docker stop $CONTAINER
fi

echo "                                                 @@                                                         "
echo "                                                :@@                                                         "
echo "                                                @@@'                  '.,,.                                 "
echo "                                               @@@@C           '+@@@@@@@@@@@@@@@@,                          "
echo "                                              @@@@@'   +@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                  "
echo "                                             @@@@@@.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+              "
echo "                                             @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@             "
echo "                            @@@;'           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+';:,,.'''''''..,            "
echo "                            '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'                                             "
echo "                                 '@@@@@@@@@@@@@@@@@@@@@;                                                    "
echo "                               ,@@@@@@@@@@@@@@@@@@@@@@@@@@+                                                 "
echo "                           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.                                            "
echo "                      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'                                       "
echo "                   '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                     "
echo "                 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@: ;@@@@@@@@@@@@@@@@@@                                   "
echo "                @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   +@@@@@@@@@@@@@@@@@                                  "
echo "             .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  ,@@@@@@@      @@@@@@@@@@@@@@@@                               "
echo "             @@@@@@@@@@@@@@@@@@@@.@@@@@@@@@@@   @@@@@@@@      C@@@@@@@@@@@@@@:                              "
echo "           ;@@@@@@@@@@@@@@@@@@;  '@@@@@@@@@@@    +@@@@@@@.       @@@@@@@@@@@@@@                             "
echo "          @@@@@@@@@@@@@@@@@@     @@@@@@@@@@@@     ,@@@@@@@@        @@@@@@@@@@@@@                            "
echo "         @@@@@@@@@@@@@@@@.       @@@@@@@@@@@C      '@@@@@@@@         +@@@@@@@@@@@                           "
echo "        @@@@@@@@@@@@@@@          @@@@@@@@@@@+       '@@@@@@@@.         :@@@@@@@@@@                          "
echo "        @@@@@@@@@@@@@@           @@@@@@@@@@@+        @@@@@@@@@          ,@@@@@@@@@:                         "
echo "       @@@@@@@@@@@,             .@@@@@@@@@@@+         :@@@@@@@@@           .@@@@@@@;                        "
echo "      @@@@@@@@@@                 @@@@@@@@@@@C          C@@@@@@@@@            ,@@@@@@                        "
echo "      @@@@@@@@                   @@@@@@@@@@@@           @@@@@@@@@@             '@@@@;                       "
echo "      @@@@@@@                    @@@@@@@@@@@@           ,@@@@@@@@@@             +@@@@                       "
echo "     @@@@                         @@@@@@@@@@@             @@@@@@@@@@@               +                       "
echo "     @@@                          @@@@@@@@@@@             @@@@@@@@@@@'                                      "
echo "                                  '@@@@@@@@@@              @@@@@@@@@@@                                      "
echo "                                   @@@@@@@@@@              @@@@@@@@@@@@                                     "
echo "                                    @@@@@@@@@'              @@@@@@@@@@@@                                    "
echo "                                      @@@@@@@@               @@@@@@@@@@@@'                                  "
echo "                                      +@@@@@@@               @@@@@@@@@@@@@                                  "
echo "                                        @@@@@@               ;@@@@@@@@@@@@,                                 "
echo "                                         @@@@@:               @@@@@@@@@@@@@                                 "
echo "                                           @@@@               @@@@@@@@@@@@@@                 FRAMEWORK-PARADISE"
echo "                                            @@@               ;@@@@@@@@@@@@@                                "
echo "                                              ;                @@@@@@@@@@@@@@                               "
echo "                                                               @@@@@@@@@@@@@@                               "
echo "                                                               +@@@@@@@@@@@@@@                              "
echo "                                                                @@@@@@@@@@@@@@                              "
echo "                                                                @@@@@@@@@@@@@@@                             "
echo "                                                                @@@@@@@@@@@@@@@                             "
echo "                                                                +@@@@@@@@@@@@@@:                            "
echo "                                                                ;@@@@@@@@@@@@@@C                            "
echo "                                                                 @@@@@@@@@@@@@@@                            "
echo ""

# PARA DESPLEGAR CÓDIGO EXTJS EN DESARROLLO
# -v $(pwd)/sencha-app:/autodeploy/rem-js \

# PARA DESPLEGAR CÓDIGO EXTJS COMPILADO
# -v $(pwd)/src/web/js/plugin/rem:/autodeploy/rem-js \

docker run -ti -m 2048M --rm -p=22 -p=8881:8080 -p=1044:1044 \
	-v $(pwd)/../rem-web:/autodeploy/src \
	-v $(pwd)/sencha-app:/autodeploy/rem-js \
	-v $(pwd)/devon.properties:/autodeploy/devon.properties \
	--name ${CONTAINER}-desarrollo -h ${CONTAINER}-desarollo $PLATFORM_N3 \
	/bin/bash -c "
	
		trap exit SIGINT
		# Para que Tomcat acepte enlaces simbólicos
		sed -i 's/<Context>/<Context allowLinking=\"true\">/' /recovery/app-server/tomcat/conf/context.xml		

		rm -rf /recovery/app-server/pfs.war
		ln -s /autodeploy/src/target/pfs-9.1-SNAPSHOT.war /recovery/app-server/pfs.war

		# Sobreescribimos devon.properties
		rm -rf /recovery/app-server/devon.properties
		ln -s /autodeploy/devon.properties /recovery/app-server/devon.properties

		# Arranque de Tomcat
		/recovery/app-server/startTomcat.sh
		
		echo ''
		echo -n '['

		while true; do

			echo -n '**'
			echo -ne '\b\b.'

			if [ -d /recovery/app-server/tomcat/webapps/pfs/WEB-INF/jsp/plugin/rem ]; then 

					for i in {1..10}
					do
					    sleep 1
						echo -n '**'
						echo -ne '\b\b.'
					done

					echo ''
			        echo 'Tomcat Running'
			        echo ''
			        mkdir -p /recovery/app-server/tomcat/webapps/pfs/js/plugin
			        rm -rf /recovery/app-server/tomcat/webapps/pfs/js/plugin/rem
					ln -s /autodeploy/rem-js /recovery/app-server/tomcat/webapps/pfs/js/plugin/rem
					break
			fi

			sleep 1

		done

		tail -F /recovery/app-server/tomcat/logs/catalina.out	
		"
