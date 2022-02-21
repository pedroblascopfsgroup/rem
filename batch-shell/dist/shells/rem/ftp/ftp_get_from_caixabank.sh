#!/bin/bash

cd $DIR_INPUT_AUX

lftp -u usr_pfscaixa,cc60bc0f86 -p 22 sftp://Intercambio2.haya.es <<EOF
cd Archivos/recep/
mget $1
bye
EOF

check_integrity_1=`md5sum $1`
rm -f $1
sleep 30

lftp -u usr_pfscaixa,cc60bc0f86 -p 22 sftp://Intercambio2.haya.es <<EOF
cd Archivos/recep/
mget $1
bye
EOF

check_integrity_2=`md5sum $1`
if [ "$check_integrity_1" != "$check_integrity_2" ]; then
    rm -f $1
fi
