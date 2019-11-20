cd $2
lftp -u ${USER},${PASS} -p ${PORT} sftp://${HOST} <<EOF
cd $1
mget $3
mget $4
mrm -f $3
mrm -f $4
bye
EOF
