lftp -c "open -u rm02,R@95pr12 sftp://192.168.126.2; ls /$1"
if [ $? -ne 0 ]; then
    lftp -c "open -u rm02,R@95pr12 sftp://192.168.126.2; mkdir /$1"
fi

lftp -u rm02,R@95pr12 sftp://192.168.126.2 <<EOF
cd /$1/
mput $DIR_SALIDA/$2.*
bye
EOF
