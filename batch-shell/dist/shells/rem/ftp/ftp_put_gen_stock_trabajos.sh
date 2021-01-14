cd $DIR_SALIDA

lftp -p22 -u pfs_gestion_activos,0227c8684e sftp://intercambio.haya.es <<EOF
cd /Archivos/
mput stock_trabajos$1.csv 
bye
EOF

