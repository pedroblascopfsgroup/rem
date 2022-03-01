#!/bin/bash

cd $DIR_INPUT_AUX

lftp -u usr_pfsbc,9f32bfd20b -p 22 sftp://intercambio2.haya.es <<EOF
cd Archivos/recep/
mget $1
bye
EOF

check_integrity_1=`md5sum $1`
rm -f $1
sleep 30

lftp -u usr_pfsbc,9f32bfd20b -p 22 sftp://intercambio2.haya.es <<EOF
cd Archivos/recep/
mget $1
bye
EOF

check_integrity_2=`md5sum $1`
if [ "$check_integrity_1" != "$check_integrity_2" ]; then
    rm -f $1
fi
