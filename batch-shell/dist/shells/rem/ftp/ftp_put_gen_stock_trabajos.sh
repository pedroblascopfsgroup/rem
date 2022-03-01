cd $DIR_SALIDA

lftp -p22 -u pfs_gestion_activos,0227c8684e sftp://intercambio2.haya.es <<EOF
cd /Archivos/
mput stock_trabajos$1.csv stock_activos_rem$1.csv
bye
EOF
