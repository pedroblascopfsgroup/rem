
lftp -u bbva_rem,"\YyaMLsW" sftp://intercambio2.haya.es <<EOF
cd /Archivos/BBVA_to_Haya
mput VT1*.txt
bye
EOF
