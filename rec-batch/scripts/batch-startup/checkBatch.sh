#!/bin/bash

export JAVA_HOME=/opt/java/jre
export PATH=$JAVA_HOME/bin:$PATH

java -jar /recovery/batch-server/shells/cmdline-jmxclient-0.10.3.jar jmx_admin:pfs_admin localhost:2099 devon:type=Jobs getJobsRunningNamesList 2> /dev/null

respuesta=$?

if [ "$respuesta" == "0" ] ; then
   echo "Estado del servicio RECOVERY BATCH: arrancado"
   exit 0
else
   echo "Estado del servicio RECOVERY BATCH: parado"
   exit 1
fi
