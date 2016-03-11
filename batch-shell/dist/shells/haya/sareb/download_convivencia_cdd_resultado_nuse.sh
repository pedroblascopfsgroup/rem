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
HORA=`date +%T`
SFTP_DIR_BNK=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya/out/aprovisionamiento/troncal
DIR_ORI=/data/etl/HRE/recepcion/aprovisionamiento/convivencia/entrada
DIR_SFT_HAYA=/sftp_haya/recepcion/convivencia
DIR_SFT_HRE=/sftp_hre/recepcion
ESPERA=1

echo "********************************************************"
echo "**** DESCARGA DE FICHEROS CONVIVENCIA CDD RESILTADO NUSE $FECHA *******"
echo "********************************************************"

FICHEROS=('rechazos.dat' 'rechazos.txt')

function download_files {
	ORIGEN=$1
	DESTINO=$2
	MASK=$3
        echo "Descargando fichero $MASK desde SFTP (${HOST})..."

	cd $ORIGEN
	rm $MASK

lftp -u ${USER},${PASS} -p ${PORT} sftp://${HOST} <<EOF

cd $DESTINO
mget $MASK
mrm -f $MASK
mrm -f $BANDERA_T
bye
EOF
	echo "Eliminando y copiando fichero de ORIGEN a SFTP_HAYA ($DIR_SFT_HAYA)"
        $RM -f $DIR_SFT_HAYA/$MASK
	$RM -rf -mtime +7 $DIR_SFT_HRE
	echo "Copiando fichero de ORIGEN a SFTP_HAYA ($DIR_SFT_HAYA)"
        $CP $MASK $DIR_SFT_HAYA
	$MKDIR -p $DIR_SFT_HRE/$FECHA
	$CP $MASK $DIR_SFT_HRE/$FECHA
}


while [ `date +%H` -ne 21 ]; do

	BANDERA=`lftp -u ${USER},${PASS} -p ${PORT} sftp://${HOST} <<EOF
cd $SFTP_DIR_BNK
dir
bye
EOF`

	BANDERA_T=(`echo "$BANDERA" | awk '{print $9}' | grep rechazos.txt`)

	if [ "$BANDERA_T" == "rechazos.txt" ]; then
		for FMASK in "${FICHEROS[@]}";	
		do
			download_files $DIR_ORI $SFTP_DIR_BNK ${FMASK}
			/etl/HRE/shells/convivencia_cdd_resultado_nuse.sh >> /etl/HRE/shells/convivencia_cdd_resultado_nuse.log
                        /etl/HRE/shells/nuseMail.sh >> /etl/HRE/shells/nuseMail.log
			echo "Fin de la ejecucion!! $HORA"
			exit 0
		done
	fi
	echo "En ejecucion....."
	sleep 30m

done





exit 0
