#!/bin/bash

cd $DIR_INPUT_AUX

lftp -u usr_pfscaixa,cc60bc0f86 -p 22 sftp://Intercambio.haya.es <<EOF
cd Archivos/recep/
mget $1
bye
EOF
