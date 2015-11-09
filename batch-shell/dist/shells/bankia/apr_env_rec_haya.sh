#!/bin/bash

SERVER=10.64.132.59
USER=ftpsocpart
PASSW=tempo.99
PORT=2153
DIR_LOCAL=/mnt/fs_servicios/recovecb/datos/usuarios/recovecb/etl/output/haya/auxiliar/
DIR_DESTINO=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya/out/aprovisionamiento/auxiliar/

> $DIR_LOCAL/apr_env_rec_haya.txt

rm -f $DIR_LOCAL/backup/RECIBOS*

ftp -vn $SERVER <<END_OF_SESSION
        user $USER $PASSW
	lcd $DIR_LOCAL
        cd $DIR_DESTINO
        bin
        put RECIBOS*.zip
        put RECIBOS*.sem
        put apr_env_rec_haya.txt

	bye
END_OF_SESSION

mv -f $DIR_LOCAL/RECIBOS*  $DIR_LOCAL/backup/
rm -f $DIR_LOCAL/apr_env_rec_haya.txt



exit 0
