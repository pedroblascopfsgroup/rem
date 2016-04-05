#!/bin/bash

USUARIO=$BATCH_USER
DIR_BASE=/home/$USUARIO

. $DIR_BASE/.bash_profile

RM=`which rm`
CP=`which cp`
FECHA=`date +%G%m%e`
MKDIR=`which mkdir`

TESTIGO=testigoUVEM.sem

rm -f $DIR_SHELLS/$TESTIGO

echo "****************************************"
echo "**** ENVIO DE FICHEROS UVEM $FECHA *******"
echo "****************************************"

FICHEROS=('cargas_bienes.dat' 'stock_bienes.dat')

function download_files {
	ORIGEN=$1
	DESTINO=$2
	MASK=$3
        echo "Subiendo fichero $MASK hacia UVEM desde SFTP (${HOST})..."

	cd $ORIGEN

lftp -u ${USER},${PASS} -p ${PORT} sftp://${HOST} <<EOF
cd $DESTINO
mput $MASK
bye
EOF
	echo "Eliminando y copiando fichero de ORIGEN a SFTP_HAYA ($DIR_SFT_HAYA_ENVIO_UVEM)"
	$RM -f $DIR_SFT_HAYA_ENVIO_UVEM/$MASK
	$RM -rf -mtime +7 $DIR_SFT_HRE_ENVIO
        $CP $MASK $DIR_SFT_HAYA_ENVIO_UVEM
	$MKDIR -p $DIR_SFT_HRE_ENVIO/$FECHA
	$CP $MASK $DIR_SFT_HRE_ENVIO/$FECHA
	echo "Eliminando fichero de ORIGEN $ORIGEN/$MASK"
	$RM -f $MASK
}

	
for FMASK in "${FICHEROS[@]}";
do
       	download_files $DIR_OUTPUT_CONV $SFTP_DIR_BNK_IN_UVEM ${FMASK}
done

touch $DIR_SHELLS/$TESTIGO

exit 0
