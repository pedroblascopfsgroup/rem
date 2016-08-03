export JAVA_HOME=/usr/java/jdk1.6.0_07
export PATH=$JAVA_HOME/bin:$PATH
export DEVON_HOME=recovery/DIRECTORY_NAME_VALUE/batch-server
export INSTALL_DIR=/$DEVON_HOME
export LANG=es_ES.UTF-8
export ORACLE_HOME=ORACLE_HOME_VALUE
export PATH=$PATH:$ORACLE_HOME/bin

# Código de la entidad
export ENTIDAD=2038

# Shells
export DIR_INPUT_AUX=/recovery/DIRECTORY_NAME_VALUE/transferencia/aprov_auxiliar/
export DIR_INPUT_TR=/recovery/DIRECTORY_NAME_VALUE/transferencia/aprov_troncal/
export DIR_DESTINO=$INSTALL_DIR/control/etl/input/
export DIR_SALIDA=$INSTALL_DIR/control/etl/output/
export DIR_BACKUP=$INSTALL_DIR/control/etl/backup/
export DIR_BASE_ETL=$INSTALL_DIR/programas/etl
export MAX_WAITING_MINUTES=20
export MAX_WAITING_MINUTES_FOR_START=720
