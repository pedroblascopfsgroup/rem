
lftp -u bbva_rem,"\YyaMLsW" sftp://intercambio.haya.es <<EOF
cd /Archivos/Bbva_To_HAYA
mget VT1*.txt
bye
EOF
