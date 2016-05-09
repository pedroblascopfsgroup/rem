cd $DIR_INPUT_AUX
rm -f $1*.*

lftp -u sftp_haya,PASSWORD sftp://192.168.49.14 <<EOF
cd /recepcion/aprovisionamiento/auxiliar/cajamar/
mget $1*.*
bye
EOF

if [ -e $1*.zip ]; then
    zip -T $1*.zip
    if [ $? -ne 0 ] ; then
        rm $1*.zip
    fi
fi
