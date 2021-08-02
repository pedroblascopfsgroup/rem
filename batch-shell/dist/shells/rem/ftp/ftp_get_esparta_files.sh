cd $DIR_INPUT_AUX
rm -f DELTA.csv

lftp -u pfs,SwQdLRyFE8A5 sftp://192.168.126.7 <<EOF
cd /Archivos/REM/HayaToPFS
mget DELTA.csv
bye
EOF

check_integrity_1=`md5sum DELTA.csv`
rm -f DELTA.csv
sleep 30

lftp -u pfs,SwQdLRyFE8A5 sftp://192.168.126.7 <<EOF
cd /Archivos/REM/HayaToPFS
mget DELTA.csv
bye
EOF

check_integrity_2=`md5sum DELTA.csv`
if [ "$check_integrity_1" != "$check_integrity_2" ]; then
    rm -f DELTA.csv
fi
