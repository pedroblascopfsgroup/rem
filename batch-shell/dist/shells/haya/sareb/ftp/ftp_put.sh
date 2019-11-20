cd $1
lftp -u ${USER},${PASS} -p ${PORT} sftp://${HOST} <<EOF
cd $2
mput $3
bye
EOF
