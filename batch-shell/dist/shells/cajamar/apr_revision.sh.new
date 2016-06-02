#!/bin/bash
# Generado manualmente.
if [[ "x$ENTIDAD" == "x" ]]; then
	echo "ERROR: Código de ENTIDAD desconocido. ¿Se ha cargado el setBatchEnv.sh"
	exit 1
fi
if [[ "x$JMX_HOST" == "x" ]]; then
	echo "ERROR: Código de JMX_HOST desconocido. ¿Se ha cargado el setBatchEnv.sh"
	exit 1
fi
if [[ "x$JMX_USER" == "x" ]]; then
	echo "ERROR: Código de JMX_USER desconocido. ¿Se ha cargado el setBatchEnv.sh"
	exit 1
fi
if [[ "x$JMX_PORT" == "x" ]]; then
	echo "ERROR: Código de JMX_PORT desconocido. ¿Se ha cargado el setBatchEnv.sh"
	exit 1
fi

LAUNCH_JOB=ejecutarProcesoArquetipado
WAIT_FOR_JOBS=procesoArquetipadoRecuperacionesJob,procesoRevisionExpedientesRecuperacionesJob,procesoRevisionClientesRecuperacionesJob,procesoCreacionClientesRecuperacionesJob,procesoCreacionExpedientesRecuperacionesETLJob,procesoHistorizarArquetipadoRecuperacionesJob
JMX_TYPE=BatchRecuperaciones
BASEDIR=$(dirname $0)

cd $BASEDIR
java -jar batch-shell.jar $JMX_USER:$JMX_PW $JMX_HOST:$JMX_PORT devon:type=$JMX_TYPE $LAUNCH_JOB=$ENTIDAD $WAIT_FOR_JOBS

exit $?

