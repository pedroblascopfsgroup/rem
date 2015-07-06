#!/bin/sh
 
echo 'Borrando fichero de log.'
echo 'Borrando fichero de log..'
echo 'Borrando fichero de log...'
rm ./log/pfs.log
echo 'Fichero de log borrado'

export HOME=home/oracle
#export ORACLE_SID=demo

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
java -XX:MaxPermSize=256m -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8000  -classpath $APPCLASSPATH es.capgemini.pfs.batch.Main&
