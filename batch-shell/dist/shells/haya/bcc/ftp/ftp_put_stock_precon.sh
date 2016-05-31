lftp -u sftp_haya,PASSWORD sftp://192.168.49.14 <<EOF
cd /envio/aprovisionamiento/troncal/cajamar/
mput $DIR_BCC_OUTPUT/STOCK_PRECON*$1.*
bye
EOF
