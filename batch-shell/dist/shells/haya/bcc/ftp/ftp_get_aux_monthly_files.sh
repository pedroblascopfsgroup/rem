lftp -u sftp_haya,PASSWORD sftp://192.168.49.14 <<EOF
cd /recepcion/aprovisionamiento/auxiliar/cajamar/
lcd $DIR_INPUT_AUX
mget $1*.*
bye
EOF
