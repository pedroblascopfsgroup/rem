#cd $DIR_INPUT_AUX
cd $3
rm -f $2.*

lftp -u sftp_ogf,VCMRwacF sftp://192.168.49.14 <<EOF
cd /input/
mget $2.*
bye
EOF

check_integrity_1=`md5sum $2.dat`
rm -f $2.*
sleep 30

lftp -u sftp_ogf,VCMRwacF sftp://192.168.49.14 <<EOF
cd /$1/
mget $2.*
bye
EOF

check_integrity_2=`md5sum $2.dat`
if [ "$check_integrity_1" != "$check_integrity_2" ]; then
    rm -f $2.dat
fi
