JAVA_HOME=/usr/java/jdk1.6.0_07

TC_INSTALL_DIR=/home/integracion/terracotta/terracotta-2.7.0
TC_CONFIG=/home/integracion/tc-config.xml


"${JAVA_HOME}/bin/java" -server -Xms256m -Xmx256m -Dcom.sun.management.jmxremote -Dtc.install-root=${TC_INSTALL_DIR} -Dtc.config=${TC_CONFIG} -cp ${TC_INSTALL_DIR}/lib/tc.jar com.tc.server.TCServerMain

#lgiavedo -> agregado para terracotta

export TC_INSTALL_DIR="/home/desarrollo/terracotta/terracotta-2.7.0-stable1"
export TC_CONFIG_PATH="localhost:9510"
export DSO_BOOT_JAR="/home/desarrollo/terracotta/terracotta-2.7.0-stable1/lib/dso-boot/dso-boot-hotspot_linux_160_07.jar"

export TC_JAVA_OPTS="-Xbootclasspath/p:${DSO_BOOT_JAR} -Dtc.install-root=${TC_INSTALL_DIR} -Dtc.config=$TC_CONFIG_PATH"

#export JAVA_OPTS=${TC_JAVA_OPTS}:${JAVA_OPTS}
export JAVA_OPTS=${TC_JAVA_OPTS}


#lgiavedo -> FIN agregado


Crear el dso-bootHotSpot:

	/usr/java/jdk1.6.0_07/bin/java -Dtc.install-root=/home/integracion/terracotta/terracotta-2.7.0 ${JAVA_OPTS} -cp /home/integracion/terracotta/terracotta-2.7.0/lib/tc.jar com.tc.object.tools.BootJarTool make -f /home/integracion/tc-config.xml
	
