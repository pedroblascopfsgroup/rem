#!/bin/bash

fecha=$1

echo "Inicio de transferencia ficheros cxb_pedidos.txt"
lftp -c "open -u usr_pfscaixa,cc60bc0f86 -p 22 sftp://Intercambio.haya.es; ls Archivos/envio/"

lftp -u usr_pfscaixa,cc60bc0f86 -p 22 sftp://Intercambio.haya.es <<EOF
cd Archivos/envio/
mput $DIR_SALIDA/cxb_pedidos_${fecha}.txt
bye
EOF
