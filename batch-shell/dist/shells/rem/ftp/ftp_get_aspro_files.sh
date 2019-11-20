cd $DIR_INPUT_AUX
rm -f $2.*

lftp -u pfs,SwQdLRyFE8A5 sftp://192.168.126.7 <<EOF
cd /Archivos/REM/HayaToPFS/$1
mget $2.*
bye
EOF

check_integrity_1=`md5sum $2.dat`
rm -f $2.*
sleep 30

lftp -u pfs,SwQdLRyFE8A5 sftp://192.168.126.7 <<EOF
cd /Archivos/REM/HayaToPFS/$1
mget $2.*
bye
EOF

check_integrity_2=`md5sum $2.dat`
if [ "$check_integrity_1" != "$check_integrity_2" ]; then
    rm -f $2.dat
fi
