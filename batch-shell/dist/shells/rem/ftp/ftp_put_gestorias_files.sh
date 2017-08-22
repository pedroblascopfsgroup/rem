cd $DEVON_HOME/control/etl/ogf/output

lftp -u sftp_ogf,VCMRwacF sftp://192.168.49.14 <<EOF
cd /output/
mput $DEVON_HOME/control/etl/ogf/output/OGF_*_$1.*
bye
EOF

cd $DEVON_HOME/control/etl/tecnotramit/output

lftp -u sftp_tecnotramit,XuPOjpUT sftp://192.168.49.14 <<EOF
cd /output/
mput $DEVON_HOME/control/etl/tecnotramit/output/TECNOTRAMIT_*_$1.*
bye
EOF

cd $DEVON_HOME/control/etl/tinsa_certify/output

lftp -u sftp_tinsa,SaQbBvMf sftp://192.168.49.14 <<EOF
cd /output/
mput $DEVON_HOME/control/etl/tinsa_certify/output/TINSACERTIFY_*_$1.*
bye
EOF
