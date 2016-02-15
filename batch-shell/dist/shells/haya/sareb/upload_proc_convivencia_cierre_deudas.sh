#!/bin/bash

USUARIO=ops-haya
DIR_BASE=/home/$USUARIO

. $DIR_BASE/.bash_profile

RM=`which rm`
CP=`which cp`
FECHA=`date +%G%m%e`
MKDIR=`which mkdir`

HOST=192.168.235.59
USER=ftpsocpart
PASS=tempo.99
PORT=2153
SFTP_DIR_BNK=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya/in/aprovisionamiento/troncal
DIR_ORI=/data/etl/HRE/recepcion/aprovisionamiento/convivencia/salida
BANDERA=$DIR_ORI/CNV_CDDD.txt
DIR_SFT_HAYA=/sftp_haya/envio/convivencia
DIR_SFT_HRE=/sftp_hre/envio

echo "************************************************"
echo "**** ENVIO DE FICHEROS CNV CDDD $FECHA *******"
echo "************************************************"

FICHEROS_PREV=`ls -l $DIR_ORI`
FICHEROS=(`echo "$FICHEROS_PREV" | awk '{print $9}' | grep conv_ccdd`)

function download_files {
	ORIGEN=$1
	DESTINO=$2
	MASK=$3
        echo "Subiendo fichero $MASK hacia BANKIA desde SFTP (${HOST})..."

	cd $ORIGEN

lftp -u ${USER},${PASS} -p ${PORT} sftp://${HOST} <<EOF
cd $DESTINO
mput $MASK
bye
EOF
	echo "Eliminando y copiando fichero de ORIGEN a SFTP_HAYA ($DIR_SFT_HAYA)"
	$RM -f $DIR_SFT_HAYA/$MASK
	$RM -rf -mtime +7 $DIR_SFT_HRE
	$CP $MASK $DIR_SFT_HAYA
	$MKDIR -p $DIR_SFT_HRE/$FECHA
	$CP $MASK $DIR_SFT_HRE/$FECHA
}

if [ -f $BANDERA ]; then
	for FMASK in "${FICHEROS[@]}";
	do
       		download_files $DIR_ORI $SFTP_DIR_BNK ${FMASK}
	done
	echo "Eliminando bandera de ORIGEN $BANDERA"
	echo " "
        $RM -f $BANDERA
else
	echo "El fichero bandera $BANDERA no existe."
	echo " "
fi

exit 0
