export JAVA_HOME=/usr/java/jdk1.6.0_07
export PATH=$JAVA_HOME/bin:$PATH
export DEVON_HOME=recovery/haya/batch-server
export INSTALL_DIR=/$DEVON_HOME/bcc
export BATCH_INSTALL_DIR=$INSTALL_DIR/programas/batch
export BATCH_USER=map011-batch
export LANG=es_ES.UTF-8
export ORACLE_HOME=ORACLE_HOME_VALUE
export PATH=$PATH:$ORACLE_HOME/bin:/recovery/batch-server/bcc/shells

# Código de la entidad
export ENTIDAD=0240

# Datos de conexión para las shells JMX
export JMX_HOST=localhost
export JMX_PORT=2099
export JMX_USER=jmx_admin
export JMX_PW="IMYzS4aO1q6jg1q1cXFevw==38047741"

# Shells
export DIR_INPUT_AUX=/recovery/haya/transferencia/bcc/aprov_auxiliar/
export DIR_INPUT_TR=/recovery/haya/transferencia/bcc/aprov_troncal/
export DIR_DESTINO=$INSTALL_DIR/control/etl/input/
export DIR_BACKUP=$INSTALL_DIR/control/etl/backup/
export DIR_HRE_INPUT=$INSTALL_DIR/control/etl/input/aprov-haya/
export DIR_HRE_OUTPUT=$INSTALL_DIR/control/etl/output/aprov-haya/
export DIR_BCC_OUTPUT=$INSTALL_DIR/control/etl/output/aprov-cajamar/
export DIR_BCC_BACKUP=$INSTALL_DIR/control/etl/backup/aprov-cajamar/
export DIR_BCC_INPUT=$INSTALL_DIR/control/etl/input/aprov-cajamar/
export DIR_BASE_ETL=$INSTALL_DIR/programas/etl
export MAX_WAITING_MINUTES=60
export MAX_WAITING_MINUTES_FOR_START=720
