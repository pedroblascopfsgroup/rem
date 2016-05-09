cd $DIR_INPUT_AUX
rm -f $2*$1.*

lftp -u sftp_haya,PASSWORD sftp://192.168.49.14 <<EOF
cd /recepcion/aprovisionamiento/troncal/cajamar/
mget $2*$1.*
bye
EOF

if [ -e $2*$1.zip ]; then
    zip -T $2*$1.zip
    if [ $? -ne 0 ] ; then
        rm $2*$1.zip
    fi
fi
