#!/bin/bash

cd $DIR_INPUT_AUX

lftp -u usr_pfsbc,9f32bfd20b -p 22 sftp://Intercambio.haya.es <<EOF
cd Archivos/recep/
mget $1
bye
EOF
