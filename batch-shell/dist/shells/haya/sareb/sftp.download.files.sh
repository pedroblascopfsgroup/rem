#!/bin/bash

USUARIO=$BATCH_USER
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
FECHA_PR=`date +%Y%m%d --date="1 day ago"`
LOG=$DIR_LOG/sftp_download_files-$FECHAYYYYMMDD.log

TIPO_ORI=envio
DIR_SFTP_ORI=/sftp_haya/$TIPO_ORI
DIR_APROV_ORI=$DIR_SFTP_ORI/aprovisionamiento

TIPO_DES=recepcion
DIR_SFTP_DES=/sftp_haya/$TIPO_DES
DIR_APROV_DES=$DIR_SFTP_DES/aprovisionamiento

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

FICHEROS_T_PR=`lftp -u ${USER},${PASS} -p ${PORT} sftp://${HOST} <<EOF
cd $SFTP_DIR_BASE_BNK/out/aprovisionamiento/troncal_PR
dir
bye
EOF`

FICHEROS_A_PR=`lftp -u ${USER},${PASS} -p ${PORT} sftp://${HOST} <<EOF
cd $SFTP_DIR_BASE_BNK/out/aprovisionamiento/auxiliar_PR
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
mget $BANDERA
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
	cp *.* $DIR_CONTROL_ETL/$TIPO/$TIPO2/$TIPO3
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

BANDERA_T_PR=(`echo "$FICHEROS_T_PR" | awk '{print $9}' | grep .sem`)

for i in "${BANDERA_T_PR[@]}"
do
                if [ "${i}" = "PCR_5074_${FECHA_PR}.sem" ]; then
                        FILES_DOWN_AT=(`echo "$FICHEROS_T_PR" | awk '{print $9}' | egrep -i '(PCR)'`)
                        file_list "$(echo ${FILES_DOWN_AT[@]})" troncal_PR "PCR_5074_${FECHA_PR}.sem"
                fi
		if [ "${i}" = "GCL_5074_${FECHA_PR}.sem" ]; then
                        FILES_DOWN_AT=(`echo "$FICHEROS_T_PR" | awk '{print $9}' | egrep -i '(GCL)'`)
                        file_list "$(echo ${FILES_DOWN_AT[@]})" troncal_PR "GCL_5074_${FECHA_PR}.sem"
                fi
		if [ "${i}" = "ZONAS_5074_${FECHA_PR}.sem" ]; then
                        FILES_DOWN_AT=(`echo "$FICHEROS_T_PR" | awk '{print $9}' | egrep -i '(ZONAS)'`)
                        file_list "$(echo ${FILES_DOWN_AT[@]})" troncal_PR "ZONAS_5074_${FECHA_PR}.sem"
                fi
		if [ "${i}" = "OFICINAS_5074_${FECHA_PR}.sem" ]; then
                        FILES_DOWN_AT=(`echo "$FICHEROS_T_PR" | awk '{print $9}' | egrep -i '(OFICINAS)'`)
                        file_list "$(echo ${FILES_DOWN_AT[@]})" troncal_PR "OFICINAS_5074_${FECHA_PR}.sem"
                fi
		if [ "${i}" = "JERARQUIA_5074_${FECHA_PR}.sem" ]; then
                        FILES_DOWN_AT=(`echo "$FICHEROS_T_PR" | awk '{print $9}' | egrep -i '(JERARQUIA)'`)
                        file_list "$(echo ${FILES_DOWN_AT[@]})" troncal_PR "JERARQUIA_5074_${FECHA_PR}.sem"
                fi
done

BANDERA_A_PR=(`echo "$FICHEROS_A_PR" | awk '{print $9}' | grep .sem`)

for i in "${BANDERA_A_PR[@]}"
do
                if [ "${i}" = "DIRECCIONES_5074_${FECHA_PR}.sem" ]; then
                        FILES_DOWN_AA=(`echo "$FICHEROS_A_PR" | awk '{print $9}' | egrep -i '(DIRECCIONES)'`)
                        file_list "$(echo ${FILES_DOWN_AA[@]})" auxiliar_PR "DIRECCIONES_5074_${FECHA_PR}.sem"
                fi
                if [ "${i}" = "TELEFONOS_5074_${FECHA_PR}.sem" ]; then
                        FILES_DOWN_AA=(`echo "$FICHEROS_A_PR" | awk '{print $9}' | egrep -i '(TELEFONOS)'`)
                        file_list "$(echo ${FILES_DOWN_AA[@]})" auxiliar_PR "TELEFONOS_5074_${FECHA_PR}.sem"
                fi
                if [ "${i}" = "CIRBE_5074_${FECHA_PR}.sem" ]; then
                        FILES_DOWN_AA=(`echo "$FICHEROS_A_PR" | awk '{print $9}' | egrep -i '(CIRBE)'`)
                        file_list "$(echo ${FILES_DOWN_AA[@]})" auxiliar_PR "CIRBE_5074_${FECHA_PR}.sem"
                fi
                if [ "${i}" = "CANCELADOS_5074_${FECHA_PR}.sem" ]; then
                        FILES_DOWN_AA=(`echo "$FICHEROS_A_PR" | awk '{print $9}' | egrep -i '(CANCELADOS)'`)
                        file_list "$(echo ${FILES_DOWN_AA[@]})" auxiliar_PR "CANCELADOS_5074_${FECHA_PR}.sem"
                fi
                if [ "${i}" = "BIENES_5074_${FECHA_PR}.sem" ]; then
                        FILES_DOWN_AA=(`echo "$FICHEROS_A_PR" | awk '{print $9}' | egrep -i '(BIENES)'`)
                        file_list "$(echo ${FILES_DOWN_AA[@]})" auxiliar_PR "BIENES_5074_${FECHA_PR}.sem"
                fi
                if [ "${i}" = "BIENCNT_5074_${FECHA_PR}.sem" ]; then
                        FILES_DOWN_AA=(`echo "$FICHEROS_A_PR" | awk '{print $9}' | egrep -i '(BIENCNT)'`)
                        file_list "$(echo ${FILES_DOWN_AA[@]})" auxiliar_PR "BIENCNT_5074_${FECHA_PR}.sem"
                fi
                if [ "${i}" = "BIENPER_5074_${FECHA_PR}.sem" ]; then
                        FILES_DOWN_AA=(`echo "$FICHEROS_A_PR" | awk '{print $9}' | egrep -i '(BIENPER)'`)
                        file_list "$(echo ${FILES_DOWN_AA[@]})" auxiliar_PR "BIENPER_5074_${FECHA_PR}.sem"
                fi
                if [ "${i}" = "RECIBOS_5074_${FECHA_PR}.sem" ]; then
                        FILES_DOWN_AA=(`echo "$FICHEROS_A_PR" | awk '{print $9}' | egrep -i '(RECIBOS)'`)
                        file_list "$(echo ${FILES_DOWN_AA[@]})" auxiliar_PR "RECIBOS_5074_${FECHA_PR}.sem"
                fi
                if [ "${i}" = "EFECTOS_5074_${FECHA_PR}.sem" ]; then
                        FILES_DOWN_AA=(`echo "$FICHEROS_A_PR" | awk '{print $9}' | egrep -i '(EFECTOS)'`)
                        file_list "$(echo ${FILES_DOWN_AA[@]})" auxiliar_PR "EFECTOS_5074_${FECHA_PR}.sem"
                fi
                if [ "${i}" = "EFECTOS_PERSONAS_5074_${FECHA_PR}.sem" ]; then
                        FILES_DOWN_AA=(`echo "$FICHEROS_A_PR" | awk '{print $9}' | egrep -i '(EFECTOS_PERSONAS)'`)
                        file_list "$(echo ${FILES_DOWN_AA[@]})" auxiliar_PR "EFECTOS_PERSONAS_5074_${FECHA_PR}.sem"
                fi
                if [ "${i}" = "COBROS_5074_${FECHA_PR}.sem" ]; then
                        FILES_DOWN_AA=(`echo "$FICHEROS_A_PR" | awk '{print $9}' | egrep -i '(COBROS)'`)
                        file_list "$(echo ${FILES_DOWN_AA[@]})" auxiliar_PR "COBROS_5074_${FECHA_PR}.sem"
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
                                             
