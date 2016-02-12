#!/bin/bash

function set_diag(){
	/usr/java/jdk1.6.0_27/bin/java -jar /etl/HRE/shells/cmdline-jmxclient-0.10.3.jar jmx_admin:pfs_admin localhost:2099 devon:type=logger setLoggerLevel=es.capgemini.pfs.batch.common,$1
	/usr/java/jdk1.6.0_27/bin/java -jar /etl/HRE/shells/cmdline-jmxclient-0.10.3.jar jmx_admin:pfs_admin localhost:2099 devon:type=logger setLoggerLevel=es.capgemini.pfs.batch.revisar.arquetipos,$1
	/usr/java/jdk1.6.0_27/bin/java -jar /etl/HRE/shells/cmdline-jmxclient-0.10.3.jar jmx_admin:pfs_admin localhost:2099 devon:type=logger setLoggerLevel=es.capgemini.pfs.batch.revisar.arquetipos.engine,$1
}

reinicio=NO

# Comprobar si rera_gen_simulacion está en ejecución
if [ "`pgrep -f rera_gen_simulacion`" != "" ] 
then 
	reinicio=SI
	pkill -f rera_gen_simulacion
	echo "*** Proceso rera_gen_simulacion finalizado."
else 
	echo "--- Proceso rera_gen_simulacion NO estaba en ejecución."
fi

# Comprobar si rera_gen_factdiario está en ejecución
if [ "`pgrep -f rera_gen_factdiario`" != "" ] 
then 
	reinicio=SI
	pkill -f rera_gen_factdiario
	echo "*** Proceso rera_gen_factdiario finalizado."
else 
	echo "--- Proceso rera_gen_factdiario NO estaba en ejecución."
fi

reinicio=SI

if [ "$reinicio" == "SI" ] 
then
      echo "*** Es necesario reiniciar el Batch"
      /etl/HRE/programas/stopBatch.sh
      echo "*** Batch detenido"
      /home/ops-haya/batch/run.sh
      echo "*** Batch arrancado de nuevo"
      set_diag DEBUG
      echo "*** Establecido valor de diagnostico"
else
      echo "--- NO es necesario reiniciar el Batch"
fi
