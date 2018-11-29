#########################################################################
# RECOVERY- PLATAFORMA PRODUCTO
# Adaptado para rem
#  
#  (cualquier cambio que hagamos en este fichero necesitará que volvamos
#      a construir la imágen Docker para que surja efecto)
#------------------------------------------------------------------------
# Este fichero representa un ejemplo de generación de un entorno web usando
#   la plataforma producto (nivel 3)
#
#    NIVEL1      NIVEL 2        NIVEL 3 (*)
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
#
# Instrucciones de uso
#------------------------------------------------------------------------
# Paso 1. Construcción.
# Debemos ejecutar el siguiente comando desde el mismo directorio de este
#    fichero. Hay que especificar el nombre del cliente donde se indica.
#
# $ docker build --no-cache=true -t rem/app-server .
#
# Paso 2. Arranque del contenedor, inicialización.
# 
#
# $ docker run -d -p=22 -p=8080 -v ${HOME}/container-info:/container-info -h rem-web --name  rem-web rem/app-server 
#
# A continuación explicamos cuales són los parámetros que le pasamos a docker run
#   -d indicamos que se ejemcute en segundo plano
#   -p= Indicamos cuale són los puertos para los que queremos que se haga NAT
#   -v ${HOME}... mediante este paámetro hacemos que se almacene información
#			del contenedor en tiempo de ejecución en ~/container-info
#   -h establecemos el hostname del contenedor
#   --name le damos un nombre al contenedor, es lo que se mostrará al hacer docker ps
#   - finalmente indicamos el nombre de la imágen que acabamos de construir
#########################################################################

# Imágen de partida (debe existir en el repositorio local)
FROM producto/plataforma-app-server

# Nombre del proyecto.
ENV PROJECT REM

# Tag de la configuración. Este tag se puede usar indicar, por ejemplo
#    si la imágen es para un entorno de desarrollo, integracion, etc ...
ENV RECOVERY_CFG_TAG intereos.ibd01

# Versión de Recovery que desplegaremos
ENV RECOVERY_VERSION 1.0.8-16080502-rem

# URL de descarga para el WAR de Recovery
ENV WEB_ZIP_URL http://nexus.pfsgroup.es/nexus/service/rest/repository/releases/content/REM/recovery/web/pfs/$RECOVERY_VERSION/pfs-$RECOVERY_VERSION.war

# 
# Configuración de la conexión a BBDD
#
# Configuración JNDI
ENV WEB_MASTER_DSNAME 'jdbc/remmaster_Oracle9iDialect'
ENV WEB_ENTITY_DSNAME 'jdbc/rem01_Oracle9iDialect'

# SID      Servicio	Puerto  Version	   nombre máquina	IP		Proposito
# ibd011	ibd011	1521	11.2.0.4	ibd01	    192.168.31.31	integración REOS

# Datos de conexión (Oracle-Docker local) ip de tu maquina

ENV WEB_DBHOST 192.168.31.31
ENV WEB_DBPORT 1521
ENV WEB_DBSID ibd011

#ENV WEB_DBHOST 192.168.34.72
#ENV WEB_DBPORT 1521
#ENV WEB_DBSID orcl11g

# Datos de acceso para Recovery (Oracle-Docker local)
#ENV WEB_MASTER_SCHEMA CMMASTER
#ENV WEB_MASTERUSER CMMASTER
#ENV WEB_MASTERENCPASSWD j0b3d2CHe3I=04045316
#ENV WEB_MASTEPLAINPASSWD admin

#ENV WEB_ENTITY1USER CM01
#ENV WEB_ENTITY1ENCPASSWD j0b3d2CHe3I=04045316
#ENV WEB_ENTITY1LAINPASSWD admin

# Datos de conexión (BBDD integracion)
#ENV WEB_DBHOST ibd01
#ENV WEB_DBPORT 1527
#ENV WEB_DBSID ibd017

# Datos de acceso para Recovery (BBDD integracion)
ENV WEB_MASTER_SCHEMA REMMASTER
ENV WEB_MASTERUSER REMMASTER
ENV WEB_MASTERENCPASSWD j0b3d2CHe3I=04045316
ENV WEB_MASTEPLAINPASSWD admin

ENV WEB_ENTITY1USER REM01
ENV WEB_ENTITY1ENCPASSWD j0b3d2CHe3I=04045316
ENV WEB_ENTITY1LAINPASSWD admin

#
# Configuración del servicio 
#
# Puerto por el que accederemos a Recovery
ENV WEB_HTTP_PORT 8080

# Puerto para acceder al JMX de Recovery
ENV WEB_RECOVERY_JMX_PORT 2099

# Puerto para acceder al JMX del Tomcat
ENV TOMCAT_JMX_PORT 2098

# Configuración de memória para Tomcat
ENV TOMCAT_MEM_PARAMS "-Xms512m -Xmx1024m -XX:MaxPermSize=150m"


#######################################################################
# Modificaciones propias para REM

# Sobreescribimos el WAR por el que tenemos en local
#ENV USE_LOCAL_WAR_FILE /tmp/pfs-9.1-SNAPSHOT.war
ADD tmp /tmp

#######################################################################
# A partir de aquí no debe modificarse nada

# Ejecutamos los scripts de instalación diferida
RUN app-server-setup.sh

# Abrimos los puertos
EXPOSE 22 $WEB_HTTP_PORT $TOMCAT_JMX_PORT $WEB_RECOVERY_JMX_PORT 1044

# Especificamos el comando de arranque del contenedor.
CMD "$WEB_INSTALL_PATH/runAppServerInDocker.sh"

#JAVA_OPTS="-Xms512m -Xmx1024m -XX:MaxPermSize=150m"
#JAVA_OPTS='-Xmx1g'
