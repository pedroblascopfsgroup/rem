#!/bin/sh
 
echo 'Borrando fichero de log.'
echo 'Borrando fichero de log..'
echo 'Borrando fichero de log...'
rm ./log/pfs.log
echo 'Fichero de log borrado'


# export APPCLASSPATH="%CLASSPATH%"
# export APPCLASSPATH=.

for i in *.jar 
do 
	export APPCLASSPATH="$APPCLASSPATH:$i"
 	# echo $i 
done

# echo $APPCLASSPATH
java -Dappname=batch -Djava.rmi.server.hostname=localhost -Xmx1024m -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError -classpath $APPCLASSPATH es.capgemini.pfs.batch.Main &
