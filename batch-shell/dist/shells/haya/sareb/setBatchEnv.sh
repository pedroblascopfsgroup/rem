# Conf. Entorno
export DIR_RAIZ=/recovery/haya 
#/recovery/iap031 	[INTE] 
#/recovery/haya 	[RSI, PRE Y PRO]
export JAVA_HOME=/usr/java/jdk1.6.0_27
#/usr/java/jdk1.6.0_07	[INTE]   
#/usr/java/jdk1.6.0_27	[VAL01, PRE Y PRO]
export PATH=$JAVA_HOME/bin:$PATH
export BATCH_INSTALL_DIR=$DIR_RAIZ/batch-server/sareb/programas/batch 
export BATCH_USER=ops-haya
export DEVON_HOME=$DIR_RAIZ/batch-server 
export LANG=es_ES.UTF-8
export NLS_LANG=SPANISH_SPAIN.AL32UTF8
export ORACLE_HOME=/opt/app/oracle/product/10.2.0/db_1 
#/opt/sw/oracle/product/11.2.0/client_1	[INTE Y VAL01]
#/opt/app/oracle/product/10.2.0/db_1	[PRE Y PRO]
export PATH=$PATH:$ORACLE_HOME/bin

# Código de la entidad
export ENTIDAD=2038

# Shells
export DIR_INPUT_AUX=$DIR_RAIZ/transferencia/sareb/aprov_auxiliar/
export DIR_INPUT_TR=$DIR_RAIZ/transferencia/sareb/aprov_troncal/
export DIR_DESTINO=$DIR_RAIZ/batch-server/sareb/control/etl/input/
export DIR_CONTROL_OUTPUT=$DIR_RAIZ/batch-server/sareb/control/etl/output/
export DIR_BACKUP=$DIR_RAIZ/batch-server/sareb/control/etl/backup/
export DIR_HRE_OUTPUT=$DIR_RAIZ/batch-server/sareb/control/etl/output/aprov-haya/
export DIR_BASE_ETL=$DIR_RAIZ/batch-server/sareb/programas/etl
export DIR_PROGRAMAS=$DIR_RAIZ/batch-server/sareb/programas
export MAX_WAITING_MINUTES=10

export DIR_SHELLS=$DIR_RAIZ/batch-server/sareb/shells
export DIR_INPUT_CONV=$DIR_RAIZ/batch-server/sareb/control/etl/input/convivencia/
export DIR_OUTPUT_CONV=$DIR_RAIZ/batch-server/sareb/control/etl/output/convivencia/
export DIR_CONTROL_LOG=$DIR_RAIZ/batch-server/sareb/log/
export DIR_CONTROL_ETL=$DIR_RAIZ/batch-server/sareb/etl/

# BUROFAX
export ENVIO_DOCALIA=/sftp_docalia/burofax/envio

# FTP
export HOST=192.168.235.59
export USER=ftpsocpart
export PASS=tempo.99
export PORT=2153
export HABILITAR_FTP=NO #Las shells usan esta variable para saber si tienen que trabajar con el ftp (SOLO PRO) o no.

export DIR_SFT_HAYA_RECEPCION=/sftp_haya/recepcion/convivencia
export DIR_SFT_HRE_RECEPCION=/sftp_hre/recepcion
export DIR_SFT_HAYA_ENVIO=/sftp_haya/envio/convivencia
export DIR_SFT_HRE_ENVIO=/sftp_hre/envio
export DIR_SFT_HAYA_ENVIO_UVEM=/sftp_haya/envio/uvem
export DIR_SFT_HAYA_ENVIO_APR=/sftp_haya/envio/aprovisionamiento
export DIR_SFT_HAYA_RECEPCION_APR=/sftp_haya/recepcion/aprovisionamiento

export SFTP_DIR_BASE_BNK=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya
export SFTP_DIR_BNK_OUT_APR=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya/out/aprovisionamiento
export SFTP_DIR_BNK_OUT_APR_TR=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya/out/aprovisionamiento/troncal
export SFTP_DIR_BNK_IN_APR_TR=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya/in/aprovisionamiento/troncal
export SFTP_DIR_BNK_IN_APR_AUX=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya/in/aprovisionamiento/auxiliar
export SFTP_DIR_BNK_IN_UVEM=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya/in/uvem

#JMX --Revisar valores entornos!!
export JMX_ADMIN=jmx_admin
export JMX_PW=IMYzS4aO1q6jg1q1cXFevw==46794765
export JMX_HOST=localhost
export JMX_PORT=3094
export JMX_TYPE=BatchRecobro

					
					

