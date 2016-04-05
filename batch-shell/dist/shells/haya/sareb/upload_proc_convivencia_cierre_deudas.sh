#!/bin/bash

USUARIO=ops-haya
DIR_BASE=/home/$USUARIO

. $DIR_BASE/.bash_profile

RM=`which rm`
CP=`which cp`
FECHA=`date +%G%m%e`
MKDIR=`which mkdir`

BANDERA=$DIR_OUTPUT_CONV/CNV_CDDD.txt

echo "************************************************"
echo "**** ENVIO DE FICHEROS CNV CDDD $FECHA *******"
echo "************************************************"

FICHEROS_PREV=`ls -l $DIR_OUTPUT_CONV`
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
	echo "Eliminando y copiando fichero de ORIGEN a SFTP_HAYA ($DIR_SFT_HAYA_ENVIO)"
	$RM -f $DIR_SFT_HAYA_ENVIO/$MASK
	$RM -rf -mtime +7 $DIR_SFT_HRE_ENVIO
	$CP $MASK $DIR_SFT_HAYA_ENVIO
	$MKDIR -p $DIR_SFT_HRE_ENVIO/$FECHA
	$CP $MASK $DIR_SFT_HRE_ENVIO/$FECHA
}

if [ -f $BANDERA ]; then
	for FMASK in "${FICHEROS[@]}";
	do
       		download_files $DIR_OUTPUT_CONV $SFTP_DIR_BNK_IN_APR_TR ${FMASK}
	done
	echo "Eliminando bandera de ORIGEN $BANDERA"
	echo " "
        $RM -f $BANDERA
else
	echo "El fichero bandera $BANDERA no existe."
	echo " "
fi

exit 0
