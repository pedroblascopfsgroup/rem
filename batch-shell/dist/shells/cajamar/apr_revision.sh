#!/bin/bash
# Generado manualmente.
 
LAUNCH_JOB=<ptedefinir>
ENTIDAD=<ptedefinir>
WAIT_FOR_JOBS=<ptedefinir>

JMX_ADMIN=jmx_admin
JMX_PW=IMYzS4aO1q6jg1q1cXFevw==46794765
JMX_HOST=localhost
JMX_PORT=<ptedefinir>
JMX_TYPE=<ptedefinir>

#java -jar batch-shell.jar $JMX_ADMIN:$JMX_PW $JMX_HOST:$JMX_PORT devon:type=$JMX_TYPE $LAUNCH_JOB=$ENTIDAD $WAIT_FOR_JOBS
echo "Realizando conexión por JMX al batch-server"

exit $?

