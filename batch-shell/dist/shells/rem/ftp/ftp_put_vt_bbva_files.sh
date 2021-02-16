cd ${DIR_SALIDA}bbva

lftp -u bbva_rem,\\YyaMLsW sftp://intercambio.haya.es <<EOF
cd /Archivos/Haya_To_BBVA
mput VT1_$1.txt STOCK_$1.txt
mv VT1_$1.txt vt1.txt
bye
EOF
