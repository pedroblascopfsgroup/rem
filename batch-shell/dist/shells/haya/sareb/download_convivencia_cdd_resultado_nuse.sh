#!/bin/bash

USUARIO=$BATCH_USER
DIR_BASE=/home/$USUARIO

. $DIR_BASE/.bash_profile

RM=`which rm`
CP=`which cp`
FECHA=`date +%G%m%e`
MKDIR=`which mkdir`
HORA=`date +%T`
ESPERA=1

echo "********************************************************"
echo "**** DESCARGA DE FICHEROS CONVIVENCIA CDD RESULTADO NUSE $FECHA *******"
echo "********************************************************"

FICHEROS=('rechazos.dat' 'rechazos.txt')

function download_files {
	ORIGEN=$1
	DESTINO=$2
	MASK=$3
        echo "Descargando fichero $MASK desde SFTP (${HOST})..."

	cd $ORIGEN
	rm $MASK
	
	./ftp/ftp_get_conv_files.sh $ORIGEN $DESTINO $MASK $BANDERA_T

	echo "Eliminando y copiando fichero de ORIGEN a SFTP_HAYA ($DIR_SFT_HAYA_RECEPCION)"
    $RM -f $DIR_SFT_HAYA_RECEPCION/$MASK
	$RM -rf -mtime +7 $DIR_SFT_HRE_RECEPCION
	echo "Copiando fichero de ORIGEN a SFTP_HAYA ($DIR_SFT_HAYA_RECEPCION)"
    $CP $MASK $DIR_SFT_HAYA_RECEPCION
	$MKDIR -p $DIR_SFT_HRE_RECEPCION/$FECHA
	$CP $MASK $DIR_SFT_HRE_RECEPCION/$FECHA
}


while [ `date +%H` -ne 21 ]; do

	BANDERA=`lftp -u ${USER},${PASS} -p ${PORT} sftp://${HOST} <<EOF
cd $SFTP_DIR_BNK_OUT_APR_TR
dir
bye
EOF`

	BANDERA_T=(`echo "$BANDERA" | awk '{print $9}' | grep rechazos.txt`)

	if [ "$BANDERA_T" == "rechazos.txt" ]; then
		for FMASK in "${FICHEROS[@]}";	
		do
			if [[ "$#" -gt 0 ]] && [[ "$1" -eq "-ftp" ]]; then
				download_files $DIR_INPUT_CONV $SFTP_DIR_BNK_OUT_APR_TR ${FMASK} $BANDERA_T
			else
				echo "Llamada sin parámetro SFTP. No mueve ficheros."
			fi
			$DIR_SHELLS/convivencia_cdd_resultado_nuse.sh >> $DIR_SHELLS/convivencia_cdd_resultado_nuse.log
            $DIR_SHELLS/nuseMail.sh >> $DIR_SHELLS/nuseMail.log
			echo "Fin de la ejecucion!! $HORA"
			exit 0
		done
	fi
	echo "En ejecucion....."
	sleep 30m

done





exit 0
