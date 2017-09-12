echo "Inicio del proceso de volcado de los ficheros de documentos de resultado a las gestorias"

cd $INSTALL_DIR/control/etl/ogf/output
echo "Gestoria OGF - OGF_DOCUMENTOS_RESUL_RG_${1}.dat"
lftp -u sftp_ogf,VCMRwacF sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/ogf/output/OGF_DOCUMENTOS_RESUL_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/tecnotramit/output

echo "Gestoria TECNOTRAMIT - TECNOTRAMIT_DOCUMENTOS_RESUL_RG_${1}.dat"
lftp -u sftp_tecnotramit,XuPOjpUT sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/tecnotramit/output/TECNOTRAMIT_DOCUMENTOS_RESUL_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/tinsa_certify/output

echo "Gestoria TINSACERTIFY - TINSACERTIFY_DOCUMENTOS_RESUL_RG_${1}.dat"
lftp -u sftp_tinsa,SaQbBvMf sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/tinsa_certify/output/TINSACERTIFY_DOCUMENTOS_RESUL_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"
echo "Fin del proceso de volcado de los ficheros de documentos de resultado a las gestorias"
