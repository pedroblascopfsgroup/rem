#!/bin/bash

DIR_ORIGEN=/backup
FILE=pfsreco_doc.zip

cd $DIR_ORIGEN

if [[ "$#" -gt 0 ]] && [[ "$1" -eq "-ftp" ]]; then

	cd $DIR_SHELLS

	./ftp/ftp_get_bk.sh $DIR_ORIGEN $fichero

	cd $DIR_ORIGEN
else
	echo "Llamada sin parámetro SFTP. No mueve ficheros."
fi

exit 
