echo "Inicio del proceso de volcado de los ficheros de stock de activos a las gestorias"

cd $INSTALL_DIR/control/etl/ogf/output
echo "Gestoria OGF - OGF_STOCK_RG_${1}.dat"
lftp -u sftp_ogf,VCMRwacF sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/ogf/output/OGF_STOCK_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/tecnotramit/output

echo "Gestoria TECNOTRAMIT - TECNOTRAMIT_STOCK_RG_${1}.dat"
lftp -u sftp_tecnotramit,XuPOjpUT sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/tecnotramit/output/TECNOTRAMIT_STOCK_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/tinsa_certify/output

echo "Gestoria TINSACERTIFY - TINSACERTIFY_STOCK_RG_${1}.dat"
lftp -u sftp_tinsa,SaQbBvMf sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/tinsa_certify/output/TINSACERTIFY_STOCK_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/garsa/output

echo "Gestoria GARSA - GARSA_STOCK_RG_${1}.dat"
lftp -u sftp_garsa,bMqBKpiL sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/garsa/output/GARSA_STOCK_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/gutierrez_labrador/output

echo "Gestoria GUTIERREZ_LABRADOR - GUTIERREZL_STOCK_RG_${1}.dat"
lftp -u sftp_gutierrez,xWySWrwQ sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/gutierrez_labrador/output/GUTIERREZL_STOCK_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/montalvo/output

echo "Gestoria MONTALVO - MONTALVO_STOCK_RG_${1}.dat"
lftp -u sftp_montalvo,ghBTFtDz sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/montalvo/output/MONTALVO_STOCK_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/pinos/output

echo "Gestoria PINOS - PINOS_STOCK_RG_${1}.dat"
lftp -u sftp_pinos,leChDHxh sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/pinos/output/PINOS_STOCK_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/uniges/output

echo "Gestoria UNIGES - UNIGES_STOCK_RG_${1}.dat"
lftp -u sftp_uniges,IOViuMTI sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/uniges/output/UNIGES_STOCK_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

echo "Fin del proceso de volcado de los ficheros de stock de activos a las gestorias"
