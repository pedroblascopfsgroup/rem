#!/bin/bash
# Generado automaticamente a las mié jul 23 13:32:52 CEST 2014
 
LAUNCH_JOB=ejecutarProcesoPreProcesadoCobrosFacturacion
WAIT_FOR_JOBS=procesoPreProcesadoCobrosJob,procesoFacturacionJob,procesoHistorizacionFacturacionJob

java -jar batch-shell.jar $JMX_ADMIN:$JMX_PW $JMX_HOST:$JMX_PORT devon:type=$JMX_TYPE $LAUNCH_JOB=$ENTIDAD $WAIT_FOR_JOBS

exit $?
