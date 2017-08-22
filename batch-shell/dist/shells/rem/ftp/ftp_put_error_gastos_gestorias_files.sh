echo "Inicio del proceso de volcado de los ficheros de errores de gastos a las gestorias"

cd $INSTALL_DIR/control/etl/ogf/output
echo "Gestoria OGF - OGF_GASTOS_NOTIF_ERR_RG_${1}.dat"
lftp -u sftp_ogf,VCMRwacF sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/ogf/output/OGF_GASTOS_NOTIF_ERR_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/tecnotramit/output

echo "Gestoria TECNOTRAMIT - TECNOTRAMIT_GASTOS_NOTIF_ERR_RG_${1}.dat"
lftp -u sftp_tecnotramit,XuPOjpUT sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/tecnotramit/output/TECNOTRAMIT_GASTOS_NOTIF_ERR_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/tinsa_certify/output

echo "Gestoria TINSACERTIFY - TINSACERTIFY_GASTOS_NOTIF_ERR_RG_${1}.dat"
lftp -u sftp_tinsa,SaQbBvMf sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/tinsa_certify/output/TINSACERTIFY_GASTOS_NOTIF_ERR_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"
echo "Fin del proceso de volcado de los ficheros de errores de gastos a las gestorias"
