cd $DIR_INPUT_AUX
rm -f $2.*

lftp -u ftpsocpart,tempo.99 -p 2153 sftp://192.168.126.66 <<EOF
cd /datos/usuarios/socpart/CISA/in/
mget $2.*
bye
EOF

check_integrity_1=`md5sum $2.txt`
rm -f $2.*
sleep 30

lftp -u ftpsocpart,tempo.99 -p 2153 sftp://192.168.126.66 <<EOF
cd /datos/usuarios/socpart/CISA/in/
mget $2.*
bye
EOF

check_integrity_2=`md5sum $2.txt`
if [ "$check_integrity_1" != "$check_integrity_2" ]; then
    rm -f $2.txt
fi
