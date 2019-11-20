cd $1
lftp -u ${USER},${PASS} -p ${PORT} sftp://${HOST} <<EOF
cd $SFTP_DIR_BNK_OUT_APR
get $2
bye
EOF
