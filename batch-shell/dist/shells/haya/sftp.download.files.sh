#!/bin/bash

USUARIO=ops-haya
DIR_BASE=/home/$USUARIO
DIR_SCRIPTS=$DIR_BASE/shells
DIR_TMP=$DIR_SCRIPTS/tmp
DIR_LOG=$DIR_SCRIPTS/log

. $DIR_BASE/.bash_profile

DIR=$DIR_TMP
DIR2=$DIR_SCRIPTS

ZIP=`which zip`
SCP=`which scp`
RM=`which rm`
FECHA=`date +%G%m%e`
FECHA_ANT=`date +%G%m%e --date="1 day ago"`
FECHAYYYYMMDD=`date +%Y%m%d`
LOG=$DIR_LOG/sftp_download_files-$FECHAYYYYMMDD.log

HOST=192.168.235.59
USER=ftpsocpart
PASS=tempo.99
PORT=2153
ORACLE_HOME="/opt/app/oracle/product/10.2.0/db_1"
SFTP_DIR_BASE_BNK=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya

TIPO_ORI=envio
DIR_SFTP_ORI=/sftp_haya/$TIPO_ORI
DIR_APROV_ORI=$DIR_SFTP_ORI/aprovisionamiento

TIPO_DES=recepcion
DIR_SFTP_DES=/sftp_haya/$TIPO_DES
DIR_APROV_DES=$DIR_SFTP_DES/aprovisionamiento

DIR_ETL=/data/etl/HRE

echo "****************************************"
echo "**** DESCARGA DE FICHEROS $FECHA *******"
echo "****************************************"

FICHEROS_T=`lftp -u ${USER},${PASS} -p ${PORT} sftp://${HOST} <<EOF
cd $SFTP_DIR_BASE_BNK/out/aprovisionamiento/troncal
dir
bye
EOF`

FICHEROS_A=`lftp -u ${USER},${PASS} -p ${PORT} sftp://${HOST} <<EOF
cd $SFTP_DIR_BASE_BNK/out/aprovisionamiento/auxiliar
dir
bye
EOF`

function download_files {
	ORIGEN=$1
	DESTINO=$2
	MASK=$3
	BANDERA=$4
        echo "Descargando ficheros desde SFTP (${HOST})..."
	cd $DESTINO

        echo "lftp -u ${USER},${PASS} -p ${PORT} sftp://${HOST} -e ls"

	echo "$ORIGEN  $DESTINO"

lftp -u ${USER},${PASS} -p ${PORT} sftp://${HOST} <<EOF
cd $ORIGEN
mget $MASK
mrm -f $MASK
mrm -f $BANDERA
bye
EOF

}

function file_list {
	FILES_DOWN=( "$1" )
	TIPO=$2
	BANDERA=$3
	
	for FMASK in ${FILES_DOWN[*]};
	do
		echo "$SFTP_DIR_BASE_BNK/out/aprovisionamiento/$TIPO $DIR_APROV_DES/$TIPO ${FMASK} $BANDERA"
        	download_files $SFTP_DIR_BASE_BNK"/out/aprovisionamiento/$TIPO" $DIR_APROV_DES"/$TIPO" ${FMASK} $BANDERA
	done
}

function file_copy {
	TIPO=$1
	TIPO2=$2
	TIPO3=$3
	echo "Copiando $TIPO3...."
	cd $DIR_APROV_DES/$TIPO3
	cp *.* $DIR_ETL/$TIPO/$TIPO2/$TIPO3
	mv *.* backup/
}


BANDERA_T=(`echo "$FICHEROS_T" | awk '{print $9}' | grep haya.txt`)

for i in "${BANDERA_T[@]}"
do
                if [ "${i}" = "apr_env_pcr_haya.txt" ]; then
			FILES_DOWN_AT=(`echo "$FICHEROS_T" | awk '{print $9}' | egrep -i '(PCR|OFICINAS|ZONAS)'`)
			file_list "$(echo ${FILES_DOWN_AT[@]})" troncal "apr_env_pcr_haya.txt"
                	file_copy recepcion aprovisionamiento troncal
                fi
                if [ "${i}" == "apr_env_convF2_proc_haya.txt" ]; then
			FILES_DOWN_AT=(`echo "$FICHEROS_T" | awk '{print $9}' | egrep -i '(ALTA_PROCEDIMIENTOS_2|ALTA_PROCEDIMIENTOS_CONTRATOS|ALTA_PROCEDIMIENTOS_PERSONAS)'`)
			file_list "$(echo ${FILES_DOWN_AT[@]})" troncal "apr_env_convF2_proc_haya.txt"
                        file_copy recepcion aprovisionamiento troncal
                fi
                if [ "${i}" == "apr_env_convF2_bien_haya.txt" ]; then
                        FILES_DOWN_AT=(`echo "$FICHEROS_T" | awk '{print $9}' | egrep -i '(ALTA_PROCEDIMIENTOS_BIENES)'`)
			file_list "$(echo ${FILES_DOWN_AT[@]})" troncal "apr_env_convF2_bien_haya.txt"
                        file_copy recepcion aprovisionamiento troncal
                fi
		if [ "${i}" == "apr_env_grupos_haya.txt" ]; then
                        FILES_DOWN_AT=(`echo "$FICHEROS_T" | awk '{print $9}' | egrep -i '(GCL)'`)
                        file_list "$(echo ${FILES_DOWN_AT[@]})" troncal "apr_env_grupos_haya.txt"
                        file_copy recepcion aprovisionamiento troncal
                fi
done

BANDERA_A=(`echo "$FICHEROS_A" | awk '{print $9}' | grep haya.txt`)

for i in "${BANDERA_A[@]}"
do
                if [ "${i}" = "apr_env_bien_haya.txt" ]; then
			FILES_DOWN_AA=(`echo "$FICHEROS_A" | awk '{print $9}' | egrep -i '(BIEN)'`)
			file_list "$(echo ${FILES_DOWN_AA[@]})" auxiliar "apr_env_bien_haya.txt"
                	file_copy recepcion aprovisionamiento auxiliar
                fi
                if [ "${i}" = "apr_env_cirbe_haya.txt" ]; then
			FILES_DOWN_AA=(`echo "$FICHEROS_A" | awk '{print $9}' | egrep -i '(CIRBE)'`)
			file_list "$(echo ${FILES_DOWN_AA[@]})" auxiliar "apr_env_cirbe_haya.txt"
                        file_copy recepcion aprovisionamiento auxiliar
                fi
                if [ "${i}" = "apr_env_cobros_haya.txt" ]; then
			FILES_DOWN_AA=(`echo "$FICHEROS_A" | awk '{print $9}' | egrep -i '(COBROS)'`)
                        file_list "$(echo ${FILES_DOWN_AA[@]})" auxiliar "apr_env_cobros_haya.txt"
                        file_copy recepcion aprovisionamiento auxiliar
                fi
		if [ "${i}" = "apr_env_dir_haya.txt" ]; then
			FILES_DOWN_AA=(`echo "$FICHEROS_A" | awk '{print $9}' | egrep -i '(DIRECCIONES)'`)
                        file_list "$(echo ${FILES_DOWN_AA[@]})" auxiliar "apr_env_dir_haya.txt"
                        file_copy recepcion aprovisionamiento auxiliar
                fi
                if [ "${i}" = "apr_env_efec_cnt_haya.txt" ]; then
			FILES_DOWN_AA=(`echo "$FICHEROS_A" | awk '{print $9}' | egrep -i '(EFECTOS_CONTRATOS)'`)
                        file_list "$(echo ${FILES_DOWN_AA[@]})" auxiliar "apr_env_efec_cnt_haya.txt"
                        file_copy recepcion aprovisionamiento auxiliar
                fi
                if [ "${i}" = "apr_env_efec_per_haya.txt" ]; then
			FILES_DOWN_AA=(`echo "$FICHEROS_A" | awk '{print $9}' | egrep -i '(EFECTOS_PERSONAS)'`)
                        file_list "$(echo ${FILES_DOWN_AA[@]})" auxiliar "apr_env_efec_per_haya.txt"
                        file_copy recepcion aprovisionamiento auxiliar
                fi
		if [ "${i}" = "apr_env_rec_haya.txt" ]; then
			FILES_DOWN_AA=(`echo "$FICHEROS_A" | awk '{print $9}' | egrep -i '(RECIBOS)'`)
                        file_list "$(echo ${FILES_DOWN_AA[@]})" auxiliar "apr_env_rec_haya.txt"
                        file_copy recepcion aprovisionamiento auxiliar
                fi
		if [ "${i}" = "apr_env_tlf_haya.txt" ]; then
			FILES_DOWN_AA=(`echo "$FICHEROS_A" | awk '{print $9}' | egrep -i '(TELEFONOS)'`)
                        file_list "$(echo ${FILES_DOWN_AA[@]})" auxiliar "apr_env_tlf_haya.txt"
                        file_copy recepcion aprovisionamiento auxiliar
                fi
done

#FILES_DOWN_AA=(BIEN CIRBE COBROS DIRECCIONES EFECTOS RECIBOS TELEFONOS)
#FILES_DOWN_AT=(PCR alta_procedimientos GCL)

#echo "Descarga ficheros APROVISIONAMIENTO AUXILIAR"
#file_list "$(echo ${FILES_DOWN_AA[@]})" auxiliar

#echo "Descarga ficheros APROVISIONAMIENTO TRONCAL"
#file_list $FILES_DOWN_AT troncal

#echo "Copia de ficheros a directorio ETL"
#file_copy recepcion aprovisionamiento auxiliar
#file_copy recepcion aprovisionamiento troncal

exit 0
                                             
