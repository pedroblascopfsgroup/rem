#!/bin/bash

SERVER=10.64.132.59
USER=ftpsocpart
PASSW=tempo.99
PORT=2153
DIR_LOCAL=/mnt/fs_servicios/recovecb/datos/usuarios/recovecb/etl/output/haya/troncal/
DIR_DESTINO=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya/out/aprovisionamiento/troncal/
 
> $DIR_LOCAL/apr_env_grupos_haya.txt

rm -f $DIR_LOCAL/backup/GCL-*

ftp -vn $SERVER <<END_OF_SESSION
       user $USER $PASSW
       lcd $DIR_LOCAL
       cd $DIR_DESTINO
       bin
       put GCL-*.zip
       put GCL-*.sem
       put apr_env_grupos_haya.txt

       bye
END_OF_SESSION

mv -f $DIR_LOCAL/GCL-*  $DIR_LOCAL/backup/
rm -f $DIR_LOCAL/apr_env_grupos_haya.txt

exit 0
