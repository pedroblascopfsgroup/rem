#!/bin/bash

HOST=192.168.235.59
USER=ftpsocpart
PASS=tempo.99
PORT=2153
DIR_ORIGEN=/backup
SFTP_DIR_BNK=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya/out/aprovisionamiento
FILE=pfsreco_doc.zip

cd $DIR_ORIGEN

lftp -u ${USER},${PASS} -p ${PORT} sftp://${HOST} <<EOF
cd $SFTP_DIR_BNK
get $FILE
bye
EOF
 

exit 
