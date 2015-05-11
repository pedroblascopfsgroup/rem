#!/bin/sh
 
#export ORACLE_SID=integracion

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
java -classpath $APPCLASSPATH es.capgemini.pfs.batch.Main&



