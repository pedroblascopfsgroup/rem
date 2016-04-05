#!/bin/bash

DIR_ORIGEN=/backup
FILE=pfsreco_doc.zip

cd $DIR_ORIGEN

lftp -u ${USER},${PASS} -p ${PORT} sftp://${HOST} <<EOF
cd $SFTP_DIR_BNK_OUT_APR
get $FILE
bye
EOF
 

exit 
