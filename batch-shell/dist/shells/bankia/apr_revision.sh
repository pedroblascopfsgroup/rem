#!/bin/bash
# Generado automaticamente a las mié jul 23 13:32:52 CEST 2014
 
ENTIDAD=2038
LAUNCH_JOB=ejecutarProcesoArquetipado
WAIT_FOR_JOBS=procesoArquetipadoRecuperacionesJob,procesoRevisionExpedientesRecuperacionesJob,procesoRevisionClientesRecuperacionesJob,procesoCreacionClientesRecuperacionesJob,procesoCreacionExpedientesRecuperacionesETLJob,procesoHistorizarArquetipadoRecuperacionesJob
JMX_TYPE=BatchRecuperaciones

JMX_ADMIN=jmx_admin
JMX_PW=IMYzS4aO1q6jg1q1cXFevw==46794765
JMX_HOST=localhost
JMX_PORT=2099
BASEDIR=$(dirname $0)

cd $BASEDIR
java -jar batch-shell.jar $JMX_ADMIN:$JMX_PW $JMX_HOST:$JMX_PORT devon:type=$JMX_TYPE $LAUNCH_JOB=$ENTIDAD $WAIT_FOR_JOBS

exit $?


