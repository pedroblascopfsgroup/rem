export JAVA_HOME=/opt/java/jre
export PATH=$JAVA_HOME/bin:$PATH
export BATCH_INSTALL_DIR=/recovery/batch-server/programas/batch
export BATCH_USER=recbatch
export DEVON_HOME=recovery/batch-server
export LANG=es_ES.UTF-8
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0
export PATH=$PATH:$ORACLE_HOME/bin:/recovery/batch-server/shells

# Código de la entidad
export ENTIDAD=0240

# Datos de conexión para las shells JMX
export JMX_HOST=localhost
export JMX_PORT=2099
export JMX_USER=jmx_admin
export JMX_PW="IMYzS4aO1q6jg1q1cXFevw==38047741"

# Shells
export DIR_INPUT_AUX=/recovery/transferencia/aprov_auxiliar/
export DIR_INPUT_TR=/recovery/transferencia/aprov_troncal/
export DIR_DESTINO=/recovery/batch-server/control/etl/input/
export DIR_BACKUP=/recovery/batch-server/control/etl/backup/
export DIR_HRE_INPUT=/recovery/batch-server/control/etl/input/aprov-haya/
export DIR_HRE_OUTPUT=/recovery/batch-server/control/etl/output/aprov-haya/
export DIR_HRE_BACKUP=/recovery/batch-server/control/etl/backup/aprov-haya/
export DIR_BASE_ETL=/recovery/batch-server/programas/etl
export MAX_WAITING_MINUTES=10
