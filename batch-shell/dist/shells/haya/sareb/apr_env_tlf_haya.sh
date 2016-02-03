#!/bin/bash

SERVER=10.64.132.59
USER=ftpsocpart
PASSW=tempo.99
PORT=2153
DIR_LOCAL=/mnt/fs_servicios/recovecb/datos/usuarios/recovecb/etl/output/haya/auxiliar/
DIR_DESTINO=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya/in/aprovisionamiento/auxiliar/

> $DIR_LOCAL/apr_env_tlf_haya.txt

rm -f $DIR_LOCAL/backup/TELEFONOS*

ftp -vn $SERVER <<END_OF_SESSION
        user $USER $PASSW
	lcd $DIR_LOCAL
        cd $DIR_DESTINO
        bin
        put stock*.dat


	bye
END_OF_SESSION

mv -f $DIR_LOCAL/stock*  $DIR_LOCAL/backup/




exit 0
