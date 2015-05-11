#!/bin/sh
 
export HOME=home/oracle
export ORACLE_SID=integracion

export JPDA_TRANSPORT=dt_socket
export JPDA_ADDRESS=8000
export JAVA_HOME=/usr/java/jdk1.6.0_07


# export APPCLASSPATH="%CLASSPATH%"
# export APPCLASSPATH=.

for i in *.jar 
do 
	export APPCLASSPATH="$APPCLASSPATH:$i"
 	# echo $i 
done

# echo $APPCLASSPATH
java -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8000  -classpath $APPCLASSPATH es.capgemini.pfs.batch.Main
