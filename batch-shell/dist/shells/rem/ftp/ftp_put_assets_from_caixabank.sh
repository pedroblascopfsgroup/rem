#!/bin/bash

fecha=$1

echo "Inicio de transferencia ficheros RUSTOCK.TXT"
lftp -u usr_pfsbc,9f32bfd20b -p 22 sftp://Intercambio2.haya.es <<EOF
cd Archivos/envio/
mput $DIR_SALIDA/RUSTOCK_${fecha}.TXT
bye
EOF

lftp -c "open -u usr_pfsbc,9f32bfd20b -p 22 sftp://Intercambio2.haya.es; ls Archivos/envio/"
