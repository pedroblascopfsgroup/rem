cd $1
lftp -u ${USER},${PASS} -p ${PORT} sftp://${HOST} <<EOF
cd $2
mget $3
mrm -f $3
bye
EOF
