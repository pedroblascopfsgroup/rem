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
#java -Djava.rmi.server.hostname=localhost -Xmx1024m -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError -classpath $APPCLASSPATH es.capgemini.pfs.batch.Main &
#JRockit params
#java -Djava.rmi.server.hostname=localhost -Xms:1024m -Xmx:3072m -Xns:256m -XX:+HeapDumpOnOutOfMemoryError -classpath $APPCLASSPATH es.capgemini.pfs.batch.Main &
java -Dappname=batch -Djava.rmi.server.hostname=localhost -Xms:1024m -Xmx:3072m -Xns:256m -XX:+HeapDumpOnOutOfMemoryError -XX:+UnlockDiagnosticVMOptions -XX:MaxClassBlockMemory=75M -classpath $APPCLASSPATH es.capgemini.pfs.batch.Main &
