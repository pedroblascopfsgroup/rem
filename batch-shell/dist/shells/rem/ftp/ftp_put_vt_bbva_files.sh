cd ${DIR_SALIDA}bbva

cp VT1_$1.txt vt1.txt

if [ $(date +%u) -eq 5 ]; then
	ficheros="vt1.txt STOCK_$1.txt"
else
    ficheros="vt1.txt"
fi

lftp -u bbva_rem,\\YyaMLsW sftp://intercambio.haya.es <<EOF
cd /Archivos/Haya_To_BBVA
mput $ficheros
bye
EOF

rm vt1.txt
