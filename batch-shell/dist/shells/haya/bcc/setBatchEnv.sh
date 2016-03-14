export JAVA_HOME=/usr/java/jdk1.6.0_07
export PATH=$JAVA_HOME/bin:$PATH
export BATCH_INSTALL_DIR=/recovery/batch-server/bcc/programas/batch
export BATCH_USER=map011-batch
export DEVON_HOME=recovery/batch-server/bcc
export LANG=es_ES.UTF-8
export ORACLE_HOME=/opt/sw/oracle/product/11.2.0/client_1
export PATH=$PATH:$ORACLE_HOME/bin:/recovery/batch-server/bcc/shells

# Código de la entidad
export ENTIDAD=0240

# Datos de conexión para las shells JMX
export JMX_HOST=localhost
export JMX_PORT=2099
export JMX_USER=jmx_admin
export JMX_PW="IMYzS4aO1q6jg1q1cXFevw==38047741"

# Shells
export DIR_INPUT_AUX=/recovery/transferencia/bcc/aprov_auxiliar/
export DIR_INPUT_TR=/recovery/transferencia/bcc/aprov_troncal/
export DIR_DESTINO=/recovery/batch-server/bcc/control/etl/input/
export DIR_BACKUP=/recovery/batch-server/bcc/control/etl/backup/
export DIR_HRE_INPUT=/recovery/batch-server/bcc/control/etl/input/aprov-haya/
export DIR_HRE_OUTPUT=/recovery/batch-server/bcc/control/etl/output/aprov-haya/
export DIR_BCC_OUTPUT=/recovery/batch-server/bcc/control/etl/output/aprov-cajamar/
export DIR_BCC_BACKUP=/recovery/batch-server/bcc/control/etl/backup/aprov-cajamar/
export DIR_BCC_INPUT=/recovery/batch-server/bcc/control/etl/input/aprov-cajamar/
export DIR_BASE_ETL=/recovery/batch-server/bcc/programas/etl
export MAX_WAITING_MINUTES=10
