cd ${DIR_DESTINO}bbva

lftp -u bbva_rem,\\YyaMLsW sftp://intercambio2.haya.es <<EOF
cd /Archivos/BBVA_to_Haya
get $2_$1.txt
bye
EOF
