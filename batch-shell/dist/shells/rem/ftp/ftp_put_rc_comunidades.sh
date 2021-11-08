#!/bin/bash

fecha=$1

echo "Inicio de transferencia ficheros [SIN DEFINIR]_TIT.xlsx"
lftp -c "open -u BDC_texabdc18,klnz18N7epHA9DuE -p 22 sftp://antena.silkplace.es; ls envio/"

lftp -u BDC_texabdc18,klnz18N7epHA9DuE -p 22 sftp://antena.silkplace.es <<EOF
cd envio/
mput $DIR_SALIDA/[SIN DEFINIR]_${fecha}.xlsx
bye
EOF
