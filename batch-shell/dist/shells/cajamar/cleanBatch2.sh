#!/bin/bash

# Inicio Update Timers
DIR_BASE_ETL=/recovery/batch-server/programas/etl

nameETL="rera_update_timers"
#nameETL="rera_update_timers"

export DIR_ETL=$DIR_BASE_ETL/$nameETL
export DIR_CONFIG=$DIR_BASE_ETL/config/
export CFG_FILE=config.ini
export MAINSH="$nameETL"_run.sh

cd "$DIR_ETL" &> /dev/null
if [ $? -ne 0 ] ; then
   echo "$(basename $0) Error en $filename: directorio inexistente $DIR_ETL"
   exit 1
fi

if [ -f $MAINSH ]; then
    CLASS="$(cat $MAINSH | grep "^ java" | cut -f10 -d" ")"
    CLASS2=`echo $CLASS | sed -e 's/$ROOT_PATH/./g'`
    CLASEINICIO="$(cat $MAINSH | grep "^ java" | cut -f11 -d" ")"
    java -Xms512M -Xmx1536M -Dconfig.dir=$DIR_CONFIG -Dconfig.file.mask=$CFG_FILE -Duser.country=ES -Duser.language=es -cp $CLASS2 $CLASEINICIO --context=Default "$@"
else
    echo "$(basename $0) Error en $filename: no se ha encontrado  $MAINSH"
    exit 1
fi

# Fin Update Timers

function set_diag(){
        java -jar /recovery/batch-server/shells/cmdline-jmxclient-0.10.3.jar jmx_admin:pfs_admin localhost:2099 devon:type=logger setLoggerLevel=es.capgemini.pfs.batch.common,$1
        java -jar /recovery/batch-server/shells/cmdline-jmxclient-0.10.3.jar jmx_admin:pfs_admin localhost:2099 devon:type=logger setLoggerLevel=es.capgemini.pfs.batch.revisar.arquetipos,$1
        java -jar /recovery/batch-server/shells/cmdline-jmxclient-0.10.3.jar jmx_admin:pfs_admin localhost:2099 devon:type=logger setLoggerLevel=es.capgemini.pfs.batch.revisar.arquetipos.engine,$1
}

reinicio=NO

# Comprobar si rera_gen_simulacion est<E1> en ejecuci<F3>n
if [ "`pgrep -f rera_gen_simulacion`" != "" ]
then
        reinicio=SI
        pkill -f rera_gen_simulacion
        echo "*** Proceso rera_gen_simulacion finalizado."
else
        echo "--- Proceso rera_gen_simulacion NO estaba en ejecuci<F3>n."
fi

# Comprobar si rera_gen_factdiario est<E1> en ejecuci<F3>n
if [ "`pgrep -f rera_gen_factdiario`" != "" ]
then
        reinicio=SI
        pkill -f rera_gen_factdiario
        echo "*** Proceso rera_gen_factdiario finalizado."
else
        echo "--- Proceso rera_gen_factdiario NO estaba en ejecuci<F3>n."
fi

reinicio=SI

if [ "$reinicio" == "SI" ]
then
      echo "*** Es necesario reiniciar el Batch"
      /recovery/batch-server/programas/stopBatch.sh
      echo "*** Batch detenido"
      /recovery/batch-server/programas/startBatch.sh
      echo "*** Batch arrancado de nuevo"
      set_diag DEBUG
      echo "*** Establecido valor de diagnostico"
else
      echo "--- NO es necesario reiniciar el Batch"
fi
