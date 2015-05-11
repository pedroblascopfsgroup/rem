#! /bin/bash


function check(){
	if [ -z "$2" ]; then
		echo "$1: Variable no definida"
		exit 1
	fi	
}

check DESCRIPCION "$DESCRIPCION"
check HOST "$HOST"
check USER $USER
check PASS $PASS
check DIR_ENTRADA $DIR_ENTRADA
check FTP_DIR $FTP_DIR
check DATA_FILE_MASK $DATA_FILE_MASK
check SEM_FILE_MASK $SEM_FILE_MASK
check SEM_NEED $SEM_NEED
check ERR_CODE_DEFAULT $ERR_CODE_DEFAULT
check ERR_CODE_FILE_NOT_FOUND $ERR_CODE_FILE_NOT_FOUND
check ERR_CODE_FILE_FTP_FAILURE $ERR_CODE_FILE_FTP_FAILURE
check ENABLE_DATE_DIR $ENABLE_DATE_DIR

echo "$(date) - Subiendo $DESCRIPCION"
echo "$(date) -   [IN: $DIR_ENTRADA]"
echo "$(date) -   [OUT: ftp://${USER}@${HOST}/$FTP_DIR]"

FECHA=`date +%Y%m%d`
if [ "x$ENABLE_DATE_DIR" == "xyes" ]; then
	FTP_IN_DIR=$DIR_ENTRADA/$FECHA
else
	FTP_IN_DIR=$DIR_ENTRADA
fi

cd $FTP_IN_DIR

if [ $? -ne 0 ]; then
	echo "$(date) -   ERROR $FTP_IN_DIR: No existe el directorio"
	exit $ERR_CODE_DEFAULT
fi

FTP_IN_DIR=$(pwd)
echo "$(date) -   Subiendo los ficheros de  $FTP_IN_DIR"

FILE=$DATA_FILE_MASK

if [ ! -f $FTP_IN_DIR/$FILE ]; then
	echo "$(date) -   ERROR: $FILE No esta disponible (err: $ERR_CODE_FILE_NOT_FOUND)"
	exit $ERR_CODE_FILE_NOT_FOUND
fi

lftp -e "mirror -R ${FTP_IN_DIR} ${FTP_DIR}" -u ${USER},${PASS} sftp://${HOST} <<EOF
bye
EOF


if [ $? -ne 0 ]; then
	echo "$(date) - ERROR: $FILE no se ha podido subir al FTP (err: $ERR_CODE_FILE_FTP_FAILURE)"
	exit $ERR_CODE_FILE_FTP_FAILURE
fi



FILE=$SEM_FILE_MASK
if [ "x$SEM_NEED" == "xyes" ]; then
	echo "a" >/dev/null

	if [ ! -f $FTP_IN_DIR/$FILE ]; then
		echo "$(date) - ERROR: $FILE No esta disponible (err: $ERR_CODE_FILE_NOT_FOUND)"
		exit $ERR_CODE_FILE_NOT_FOUND
	fi

	lftp -u ${USER},${PASS} sftp://${HOST} <<EOF
cd ${FTP_DIR}
lcd ${FTP_IN_DIR}
mput $FILE
bye
EOF
	
	if [ $? -ne 0 ]; then
		echo "$(date) - ERROR: $FILE no se ha podido subir al FTP (err: $ERR_CODE_FILE_FTP_FAILURE)"
		exit $ERR_CODE_FILE_FTP_FAILURE
	fi

fi

if [ "x$CLEAN_FILES" == "xyes" ]; then
	echo "$(date) - Borrando el directorio $FTP_IN_DIR"
	if [ "x$ENABLE_DATE_DIR" == "xyes" ]; then
		rm -Rf $FTP_IN_DIR	 
	else
		rm -Rf $FTP_IN_DIR/*
	fi
fi

echo "$(date) - Fin de $DESCRIPCION"
echo ""
echo ""
exit 0 

