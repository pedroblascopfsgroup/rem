#!/bin/bash

SERVER=10.64.132.59
USER=ftpsocpart
PASSW=tempo.99
PORT=2153
DIR_LOCAL=/mnt/fs_servicios/recovecb/datos/usuarios/recovecb/etl/output/haya/troncal/
DIR_DESTINO=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya/out/aprovisionamiento/troncal/
 
ftp -vn $SERVER <<END_OF_SESSION
	user $USER $PASSW
	lcd $DIR_LOCAL
        cd $DIR_DESTINO
	bin
        put PCR-*.zip
        put PCR-*.sem
	put ZONAS*.zip
        put ZONAS*.sem
	put OFICINAS*.zip
        put OFICINAS*.sem

	bye
END_OF_SESSION

rm -f $DIR_LOCAL/PCR-*
rm -f $DIR_LOCAL/ZONAS*
rm -f $DIR_LOCAL/OFICINAS*


exit 0
