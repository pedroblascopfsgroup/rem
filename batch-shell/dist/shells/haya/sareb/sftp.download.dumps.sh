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

	./ftp/ftp_get_dumps.sh $ORIGEN $DESTINO $MASK

	rm -f $BANDERA
}

if [ -f $BANDERA ]; then
	echo "Ya se esta ejecutando"
else
	echo " " > $BANDERA
	if [[ "$#" -gt 0 ]] && [[ "$1" -eq "-ftp" ]]; then
		download_files $DIR_ORI $SFTP_DIR_BNK_OUT_APR $FICHERO
	else
		echo "Llamada sin parámetro SFTP. No mueve ficheros."
	fi
fi

exit 0
