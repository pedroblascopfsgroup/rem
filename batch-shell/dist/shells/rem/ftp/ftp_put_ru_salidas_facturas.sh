#!/bin/bash

fecha=$1

echo "Inicio de transferencia ficheros RUFACTUCP.txt/RUFACTUSP.txt"
lftp -c "open -u usr_pfsbc,9f32bfd20b -p 22 sftp://intercambio2.haya.es; ls Archivos/envio/"

lftp -u usr_pfsbc,9f32bfd20b -p 22 sftp://intercambio2.haya.es <<EOF
cd Archivos/envio/
mput $DIR_SALIDA/RUFACTUSP_*_${fecha}.txt
mput $DIR_SALIDA/RUFACTUCP_*_${fecha}.txt 
bye
EOF
