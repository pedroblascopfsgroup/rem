#!/bin/bash

fecha=$1

echo "Inicio de transferencia ficheros RUFACTUCP.txt/RUFACTUSP.txt"
lftp -c "open -u BDC_texabdc18,klnz18N7epHA9DuE -p 22 sftp://antena.silkplace.es; ls envio/"

lftp -u BDC_texabdc18,klnz18N7epHA9DuE -p 22 sftp://antena.silkplace.es <<EOF
cd envio/
mput $DIR_SALIDA/RUFACTUSP_${fecha}.txt
mput $DIR_SALIDA/RUFACTUCP_${fecha}.txt 
bye
EOF
