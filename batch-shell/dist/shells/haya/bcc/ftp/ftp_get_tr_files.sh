lftp -u sftp_haya,PASSWORD sftp://192.168.49.14 <<EOF
cd /recepcion/aprovisionamiento/troncal/cajamar/
lcd $DIR_INPUT_TR
mget $2*$1.*
bye
EOF
