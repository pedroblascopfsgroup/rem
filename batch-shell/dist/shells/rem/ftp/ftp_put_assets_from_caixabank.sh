#!/bin/bash

fecha=$1

echo "Inicio de transferencia ficheros RUSTOCK.TXT"
lftp -c "open -u BDC_texabdc18,klnz18N7epHA9DuE -p 22 sftp://antena.silkplace.es; ls envio/"

lftp -u BDC_texabdc18,klnz18N7epHA9DuE -p 22 sftp://antena.silkplace.es <<EOF
cd envio/
mput $DIR_SALIDA/RUSTOCK_${fecha}.TXT
bye
EOF
