#!/bin/bash

fecha=$1

echo "Inicio de transferencia ficheros [SIN DEFINIR]_TIT.xlsx"
lftp -c "open -u usr_pfscaixa,cc60bc0f86 -p 22 sftp://Intercambio.haya.es; ls Archivos/envio/"

lftp -u usr_pfscaixa,cc60bc0f86 -p 22 sftp://Intercambio.haya.es <<EOF
cd Archivos/envio/
mput $DIR_SALIDA/[SIN DEFINIR]_${fecha}.xlsx
bye
EOF
