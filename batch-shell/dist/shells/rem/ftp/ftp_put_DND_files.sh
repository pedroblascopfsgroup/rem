cd ${DIR_SALIDA}DND

cp STOCK_ACTIVOS_DND_$1_*.csv STOCK_ACTIVOS_DND_$1.csv

lftp -u pfs,SwQdLRyFE8A5 sftp://intercambio2.haya.es <<EOF
cd /Archivos/REM/PFSToHaya/DND
mput STOCK_ACTIVOS_DND_$1.csv
bye
EOF
