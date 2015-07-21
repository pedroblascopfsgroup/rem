#!/bin/bash

function set_diag(){
	java -jar /aplicaciones/recovecb/shells/cmdline-jmxclient-0.10.3.jar jmx_admin:pfs_admin localhost:2099 devon:type=logger setLoggerLevel=es.capgemini.pfs.batch.common,$1
	java -jar /aplicaciones/recovecb/shells/cmdline-jmxclient-0.10.3.jar jmx_admin:pfs_admin localhost:2099 devon:type=logger setLoggerLevel=es.capgemini.pfs.batch.revisar.arquetipos,$1
	java -jar /aplicaciones/recovecb/shells/cmdline-jmxclient-0.10.3.jar jmx_admin:pfs_admin localhost:2099 devon:type=logger setLoggerLevel=es.capgemini.pfs.batch.revisar.arquetipos.engine,$1
}

reinicio=NO

# Comprobar si rera_gen_simulacion est� en ejecuci�n
if [ "`pgrep -f rera_gen_simulacion`" != "" ] 
then 
	reinicio=SI
	pkill -f rera_gen_simulacion
	echo "*** Proceso rera_gen_simulacion finalizado."
else 
	echo "--- Proceso rera_gen_simulacion NO estaba en ejecuci�n."
fi

# Comprobar si rera_gen_factdiario est� en ejecuci�n
if [ "`pgrep -f rera_gen_factdiario`" != "" ] 
then 
	reinicio=SI
	pkill -f rera_gen_factdiario
	echo "*** Proceso rera_gen_factdiario finalizado."
else 
	echo "--- Proceso rera_gen_factdiario NO estaba en ejecuci�n."
fi

reinicio=SI

if [ "$reinicio" == "SI" ] 
then
      echo "*** Es necesario reiniciar el Batch"
      /aplicaciones/recovecb/programas/stopBatch.sh
      echo "*** Batch detenido"
      /aplicaciones/recovecb/programas/startBatch.sh
      echo "*** Batch arrancado de nuevo"
      set_diag DEBUG
      echo "*** Establecido valor de diagnostico"
else
      echo "--- NO es necesario reiniciar el Batch"
fi