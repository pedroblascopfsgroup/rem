#!/bin/bash

USUARIO=$BATCH_USER
DIR_BASE=/home/$USUARIO

. $DIR_BASE/.bash_profile

RM=`which rm`
FECHA=`date +%G%m%e`
DIR_ORI=/backup/dumps_HAYA-BANKIA
BANDERA=/backup/dumps_HAYA-BANKIA/BANDERA.txt

echo "**********************************"
echo "**** DUMPS $FECHA *******"
echo "**********************************"

FICHERO="pfsreco*"

function download_files {
	ORIGEN=$1
	DESTINO=$2
	MASK=$3
        echo "Descargando fichero $MASK desde SFTP (${HOST})..."

	cd $ORIGEN

lftp -u ${USER},${PASS} -p ${PORT} sftp://${HOST} <<EOF
cd $DESTINO
mget $MASK
mrm -f $MASK
bye
EOF

	rm -f $BANDERA
}

if [ -f $BANDERA ]; then
	echo "Ya se esta ejecutando"
else
	echo " " > $BANDERA
	download_files $DIR_ORI $SFTP_DIR_BNK_OUT_APR $FICHERO
fi

exit 0
