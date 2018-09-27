# Conf. Entorno
export DIR_RAIZ=/recovery/DIR_PRINCIPAL_VALUE
#/recovery/iap031 	[INTE] 
#/recovery/haya 	[RSI, PRE Y PRO]
export JAVA_HOME=/usr/java/jdk1.6.0_45
#/usr/java/jdk1.6.0_07	[INTE, VAL01 y VAL02]   
#/usr/java/jdk1.6.0_27	[PRE Y PRO]
export PATH=$JAVA_HOME/bin:$PATH
export BATCH_INSTALL_DIR=$DIR_RAIZ/batch-server/batch 
export BATCH_USER=BATCH_USER_VALUE
export DEVON_HOME=$DIR_RAIZ/batch-server 
export LANG=es_ES.UTF-8
export NLS_LANG=SPANISH_SPAIN.AL32UTF8
export ORACLE_HOME=ORACLE_HOME_VALUE
#/opt/sw/oracle/product/11.2.0/client_1	[INTE, VAL01 y VAL02]
#/opt/app/oracle/product/11.2.0/dbhome_11204        [PRE]
#/opt/sw/oracle/client_1	[PRO]
export PATH=$PATH:$ORACLE_HOME/bin

# Código de la entidad
export ENTIDAD=0183
export ENTIDAD_AUXILIAR=0183

# Shells
export DIR_INPUT_AUX=$DIR_RAIZ/transferencia/giants/aprov_auxiliar
export DIR_INPUT_TR=$DIR_RAIZ/transferencia/giants/aprov_troncal
export DIR_DESTINO=$DIR_RAIZ/batch-server/giants/control/etl/input
export DIR_CONTROL_OUTPUT=$DIR_RAIZ/batch-server/giants/control/etl/output
export DIR_BACKUP=$DIR_RAIZ/batch-server/giants/control/etl/backup
export DIR_BASE_ETL=$DIR_RAIZ/batch-server/giants/programas/etl
export DIR_PROGRAMAS=$DIR_RAIZ/batch-server/giants/programas
export MAX_WAITING_MINUTES=10
export MAX_WAITING_MINUTES_FOR_START=1440

export DIR_SHELLS=$DIR_RAIZ/batch-server/giants/shells
export DIR_INPUT_CONV=$DIR_RAIZ/batch-server/giants/control/etl/input/convivencia
export DIR_OUTPUT_CONV=$DIR_RAIZ/batch-server/giants/control/etl/output/convivencia
export DIR_CONTROL_LOG=$DIR_RAIZ/batch-server/giants/log

# BUROFAX
#export ENVIO_DOCALIA=/sftp/docalia/burofax/envio
#export RECEPCION_DOCALIA=/sftp/docalia/burofax/entrega

# FTP
export HOST=192.168.235.59
export USER=ftpsocpart
export PASS=tempo.99
export PORT=2153

export DIR_SFT_HAYA_RECEPCION=/sftp/haya/recepcion/convivencia
export DIR_SFT_HRE_RECEPCION=/sftp/hre/recepcion
export DIR_SFT_HAYA_ENVIO=/sftp/haya/envio/convivencia
export DIR_SFT_HRE_ENVIO=/sftp/hre/envio
export DIR_SFT_HAYA_ENVIO_UVEM=/sftp/haya/envio/uvem
export DIR_SFT_HAYA_ENVIO_APR=/sftp/haya/envio/aprovisionamiento
export DIR_SFT_HAYA_RECEPCION_APR=/sftp/haya/recepcion/aprovisionamiento
export DIR_SFT_HAYA_RECEPCION_IRIS=/sftp/haya_temp/entrada

export SFTP_DIR_BASE_BNK=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya
export SFTP_DIR_BNK_OUT_APR=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya/out/aprovisionamiento
export SFTP_DIR_BNK_OUT_APR_TR=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya/out/aprovisionamiento/troncal
export SFTP_DIR_BNK_IN_APR_TR=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya/in/aprovisionamiento/troncal
export SFTP_DIR_BNK_IN_APR_AUX=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya/in/aprovisionamiento/auxiliar
export SFTP_DIR_BNK_IN_UVEM=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya/in/uvem

#JMX
#export JMX_ADMIN=jmx_admin
#export JMX_PW=IMYzS4aO1q6jg1q1cXFevw==46794765
#export JMX_HOST=localhost
#export JMX_PORT=JMX_PORT_VALUE_BATCH
#export JMX_TYPE=BatchRecobro

					
					

