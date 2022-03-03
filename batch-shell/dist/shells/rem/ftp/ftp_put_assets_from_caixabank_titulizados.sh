#!/bin/bash

fecha=$1

echo "Inicio de transferencia ficheros RUSTOCK_TIT.xlsx"
lftp -u usr_pfsbc,9f32bfd20b -p 22 sftp://intercambio2.haya.es <<EOF
cd Archivos/envio/
mput $DIR_SALIDA/RUSTOCK_TIT_${fecha}.xlsx
bye
EOF

lftp -c "open -u usr_pfsbc,9f32bfd20b -p 22 sftp://intercambio2.haya.es; ls Archivos/envio/"
