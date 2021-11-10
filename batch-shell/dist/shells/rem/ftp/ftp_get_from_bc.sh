#!/bin/bash

cd $DIR_INPUT_AUX

lftp -u BDC_texabdc18,klnz18N7epHA9DuE -p 22 sftp://antena.silkplace.es <<EOF
cd recep/
mget $1
bye
EOF
