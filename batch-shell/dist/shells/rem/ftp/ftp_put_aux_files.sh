lftp -c "open -u rm02,R@95pr12 sftp://10.126.128.130; ls /$1"
if [ $? -ne 0 ]; then
    lftp -c "open -u rm02,R@95pr12 sftp://10.126.128.130; mkdir /$1"
fi

lftp -u rm02,R@95pr12 sftp://10.126.128.130 <<EOF
cd /$1/
mput $DIR_SALIDA/$1*$2.*
bye
EOF
