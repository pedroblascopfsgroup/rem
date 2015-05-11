#!/bin/sh
 

export ORACLE_SID=integracion


export TC_INSTALL_DIR="/home/integracion/terracotta-2.7.0-stable1"
export TC_CONFIG_PATH="81.93.216.106:9510"

for i in *.jar 
do 
	export APPCLASSPATH="$APPCLASSPATH:$i"
 	# echo $i 
done

# echo $APPCLASSPATH

export DSO_BOOT_JAR="/home/integracion/terracotta-2.7.0-stable1/lib/dso-boot/dso-boot-hotspot_linux_160_07.jar"

java -classpath $APPCLASSPATH -Xbootclasspath/p:$DSO_BOOT_JAR -Dtc.install-root=$TC_INSTALL_DIR -Dtc.config=$TC_CONFIG_PATH  es.capgemini.pfs.batch.Main




