cd $DIR_INPUT_AUX
rm -f stock_bienes.dat

lftp -u sftp_haya,386c86c9e9 sftp://192.168.49.14 <<EOF
cd /envio/uvem/
mget stock_bienes.dat
bye
EOF

check_integrity_1=`md5sum stock_bienes.dat`
rm -f stock_bienes.dat
sleep 30

lftp -u sftp_haya,386c86c9e9 sftp://192.168.49.14 <<EOF
cd /envio/uvem/
mget stock_bienes.dat
bye
EOF

check_integrity_2=`md5sum stock_bienes.dat`
if [ "$check_integrity_1" != "$check_integrity_2" ]; then
    rm -f stock_bienes.dat
fi
