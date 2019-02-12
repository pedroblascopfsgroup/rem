echo "Inicio del proceso de volcado de los ficheros de errores de gastos a las gestorias"

cd $INSTALL_DIR/control/etl/ogf/output
echo "Gestoria OGF - OGF_STOCK_GASTOS_RG_${1}.dat"
lftp -u sftp_ogf,VCMRwacF sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/ogf/output/OGF_STOCK_GASTOS_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/tecnotramit/output

echo "Gestoria TECNOTRAMIT - TECNOTRAMIT_STOCK_GASTOS_RG_${1}.dat"
lftp -u sftp_tecnotramit,XuPOjpUT sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/tecnotramit/output/TECNOTRAMIT_STOCK_GASTOS_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/tinsa_certify/output

echo "Gestoria TINSACERTIFY - TINSACERTIFY_STOCK_GASTOS_RG_${1}.dat"
lftp -u sftp_tinsa,SaQbBvMf sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/tinsa_certify/output/TINSACERTIFY_STOCK_GASTOS_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/garsa/output

echo "Gestoria GARSA - GARSA_STOCK_GASTOS_RG_${1}.dat"
lftp -u sftp_garsa,bMqBKpiL sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/garsa/output/GARSA_STOCK_GASTOS_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/gutierrez_labrador/output

echo "Gestoria GUTIERREZ_LABRADOR - GUTIERREZL_STOCK_GASTOS_RG_${1}.dat"
lftp -u sftp_gutierrez,xWySWrwQ sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/gutierrez_labrador/output/GUTIERREZL_STOCK_GASTOS_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/montalvo/output

echo "Gestoria MONTALVO - MONTALVO_STOCK_GASTOS_RG_${1}.dat"
lftp -u sftp_montalvo,ghBTFtDz sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/montalvo/output/MONTALVO_STOCK_GASTOS_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/pinos/output

echo "Gestoria PINOS - PINOS_STOCK_GASTOS_RG_${1}.dat"
lftp -u sftp_pinos,leChDHxh sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/pinos/output/PINOS_STOCK_GASTOS_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/uniges/output

echo "Gestoria UNIGES - UNIGES_STOCK_GASTOS_RG_${1}.dat"
lftp -u sftp_uniges,IOViuMTI sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/uniges/output/UNIGES_STOCK_GASTOS_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/emais/output

echo "Gestoria EMAIS - EMAIS_STOCK_GASTOS_RG_${1}.dat"
lftp -u sftp_emais,"UZ-q4}{k" sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/emais/output/EMAIS_STOCK_GASTOS_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/f\&g/output

echo "Gestoria F&G - F&G_STOCK_GASTOS_RG_${1}.dat"
lftp -u sftp_fyg,"D]it&2/J" sftp://192.168.49.14 <<EOF
cd /output/
mput F\&G_STOCK_GASTOS_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/gestinova/output

echo "Gestoria GESTINOVA - GESTINOVA_STOCK_GASTOS_RG_${1}.dat"
lftp -u sftp_gestinova,"JD3Rir('" sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/gestinova/output/GESTINOVA_STOCK_GASTOS_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/maretra/output

echo "Gestoria MARETRA - MARETRA_STOCK_GASTOS_RG_${1}.dat"
lftp -u sftp_maretra,"4Dmx<HEb" sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/maretra/output/MARETRA_STOCK_GASTOS_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/qipert/output

echo "Gestoria QIPERT - QIPERT_STOCK_GASTOS_RG_${1}.dat"
lftp -u sftp_qipert,"E4GL7~|K" sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/qipert/output/QIPERT_STOCK_GASTOS_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/mediterraneo/output

echo "Gestoria MEDITERRANEO - MEDITERRANEO_STOCK_GASTOS_RG_${1}.dat"
lftp -u sftp_mediterraneo,"3qP*X8iG" sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/mediterraneo/output/MEDITERRANEO_STOCK_GASTOS_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

cd $INSTALL_DIR/control/etl/grupoBC/output

echo "Gestoria GRUPOBC - GRUPOBC_STOCK_GASTOS_RG_${1}.dat"
lftp -u sftp_grupobc,"eDRvpuxN" sftp://192.168.49.14 <<EOF
cd /output/
mput $INSTALL_DIR/control/etl/grupoBC/output/GRUPOBC_STOCK_GASTOS_RG_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

echo "Fin del proceso de volcado de los ficheros de errores de gastos a las gestorias"
