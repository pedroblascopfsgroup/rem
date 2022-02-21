cd ${DIR_DESTINO}bbva

lftp -u bbva_rem,\\YyaMLsW sftp://intercambio.haya.es <<EOF
cd /Archivos/BBVA_to_Haya
get $2-$1.csv
bye
EOF
