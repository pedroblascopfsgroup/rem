cd $DIR_INPUT_AUX
rm -f $2_$1.*

lftp -u rm01,R@59rp21 sftp://10.126.128.130 <<EOF
cd /$1/
mget $2_$1.*
bye
EOF

check_integrity_1=`md5sum $2_$1.dat`
rm -f $2_$1.*
sleep 30

lftp -u rm01,R@59rp21 sftp://10.126.128.130 <<EOF
cd /$1/
mget $2_$1.*
bye
EOF

check_integrity_2=`md5sum $2_$1.dat`
if [ "$check_integrity_1" != "$check_integrity_2" ]; then
    rm -f $2_$1.dat
fi
