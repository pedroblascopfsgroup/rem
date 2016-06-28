#!/bin/bash

USUARIO=$BATCH_USER
DIR_BASE=/home/$USUARIO

. $DIR_BASE/.bash_profile

RM=`which rm`
CP=`which cp`
FECHA=`date +%G%m%e`
MKDIR=`which mkdir`

echo "*****************************************************************"
echo "**** ENVIO DE FICHEROS CNT PROCEDIMIENTOS VIVOS $FECHA *******"
echo "*****************************************************************"

if [[ "$#" -gt 0 ]] && [[ "$1" -eq "-ftp" ]]; then

	BANDERA=$DIR_OUTPUT_CONV/cnt_procedimientos_vivos_haya.txt
	TESTIGO=testigoUploadLitios.sem

	rm -f $DIR_SHELLS/$TESTIGO

	FICHEROS=('cnt_procedimientos_vivos_haya.dat')

	function download_files {
		ORIGEN=$1
		DESTINO=$2
		MASK=$3
			echo "Subiendo fichero $MASK hacia BANKIA desde SFTP (${HOST})..."

		cd $DIR_SHELLS

		./ftp/ftp_put.sh $ORIGEN $DESTINO $MASK

		cd $ORIGEN
		
		echo "Eliminando y copiando fichero de ORIGEN a SFTP_HAYA ($DIR_SFT_HAYA_ENVIO)"
			$RM -f $DIR_SFT_HAYA_ENVIO/$MASK
		$RM -rf -mtime +5 $DIR_SFT_HRE_ENVIO
			$CP $MASK $DIR_SFT_HAYA_ENVIO
		$MKDIR -p $DIR_SFT_HRE_ENVIO/$FECHA
			$CP $MASK $DIR_SFT_HRE_ENVIO/$FECHA
		echo "Eliminando fichero de ORIGEN $ORIGEN/$MASK"
		$RM -f $MASK
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


	touch $DIR_SHELLS/$TESTIGO

else
	echo "Llamada sin parámetro SFTP. No mueve ficheros."
fi


exit 0
