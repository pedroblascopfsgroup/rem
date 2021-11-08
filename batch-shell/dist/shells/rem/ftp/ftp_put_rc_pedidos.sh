#!/bin/bash

fecha=$1

echo "Inicio de transferencia ficheros cxb_pedidos.txt"
lftp -c "open -u BDC_texabdc18,klnz18N7epHA9DuE -p 22 sftp://antena.silkplace.es; ls envio/"

lftp -u BDC_texabdc18,klnz18N7epHA9DuE -p 22 sftp://antena.silkplace.es <<EOF
cd envio/
mput $DIR_SALIDA/cxb_pedidos_${fecha}.txt
bye
EOF
