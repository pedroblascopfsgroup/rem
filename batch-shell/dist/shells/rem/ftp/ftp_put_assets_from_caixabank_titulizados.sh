#!/bin/bash

fecha=$1

echo "Inicio de transferencia ficheros RUSTOCK_TIT.xlsx"
lftp -c "open -u usr_pfsbc,9f32bfd20b -p 22 sftp://Intercambio.haya.es; ls Archivos/envio/"

lftp -u usr_pfsbc,9f32bfd20b -p 22 sftp://Intercambio.haya.es <<EOF
cd Archivos/envio/
mput $DIR_SALIDA/RUSTOCK_TIT_${fecha}.xlsx
bye
EOF
