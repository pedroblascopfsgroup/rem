#!/bin/bash

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

if [ "$reinicio" == "SI" ] 
then
      echo "*** Es necesario reiniciar el Batch"
      /recovery/batch-server/sareb/programas/stopBatch.sh
      echo "*** Batch detenido"
      /recovery/batch-server/sareb/programas/startBatch.sh
      echo "*** Batch arrancado de nuevo"
else
      echo "--- NO es necesario reiniciar el Batch"
fi
