cd $DIR_INPUT_AUX
rm -f $2_$1.*

lftp -u pfs,SwQdLRyFE8A51 sftp://192.168.126.7 <<EOF
cd /Archivos/REM/HayaToPFS/
mget $2_$1.*
bye
EOF

check_integrity_1=`md5sum $2_$1.dat`
rm -f $2_$1.*
sleep 30

lftp -u pfs,SwQdLRyFE8A51 sftp://192.168.126.7 <<EOF
cd /Archivos/REM/HayaToPFS/
mget $2_$1.*
bye
EOF

check_integrity_2=`md5sum $2_$1.dat`
if [ "$check_integrity_1" != "$check_integrity_2" ]; then
    rm -f $2_$1.dat
fi
