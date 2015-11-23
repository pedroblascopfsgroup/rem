#!/bin/bash

SERVER=10.64.132.59
USER=ftpsocpart
PASSW=tempo.99
PORT=2153
DIR_LOCAL=/mnt/fs_servicios/recovecb/datos/usuarios/recovecb/etl/output/haya/troncal/
DIR_DESTINO=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya/out/aprovisionamiento/troncal/
 
> $DIR_LOCAL/apr_env_convF2_bien_haya.txt

rm -f $DIR_LOCAL/backup/ALTA_PROCEDIMIENTOS_BIENES*.dat

ftp -vn $SERVER <<END_OF_SESSION
       user $USER $PASSW
       lcd $DIR_LOCAL
       cd $DIR_DESTINO
       bin
       put ALTA_PROCEDIMIENTOS_BIENES*.dat
       put apr_env_convF2_bien_haya.txt

       bye
END_OF_SESSION

mv -f $DIR_LOCAL/ALTA_PROCEDIMIENTOS_BIENES*.dat     $DIR_LOCAL/backup/
rm -f $DIR_LOCAL/apr_env_convF2_bien_haya.txt

exit 0
