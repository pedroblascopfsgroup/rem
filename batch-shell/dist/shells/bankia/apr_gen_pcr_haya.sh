#!/bin/bash
# Generado manualmente

SERVER=10.64.132.59
USER=ftpsocpart
PASSW=tempo.99
PORT=2153
DIR_LOCAL=/mnt/fs_servicios/recovecb/datos/usuarios/recovecb/etl/output/haya/troncal/
DIR_DESTINO=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya/out/aprovisionamiento/troncal/ 
DIR_BASE_ETL=/aplicaciones/recovecb/programas/etl

	filename=$(basename $0)
	nameETL="${filename%.*}"

	export DIR_ETL=$DIR_BASE_ETL/$nameETL
	export DIR_CONFIG=$DIR_BASE_ETL/config/
	export CFG_FILE=config.ini
	export MAINSH="$nameETL"_run.sh
	
	cd "$DIR_ETL" &> null
	if [ $? = 1 ] ; then
	   echo "$(basename $0) Error en $filename: directorio inexistente $DIR_ETL"
	   exit 1
	fi
	
	ROOT_PATH=`pwd`
	
	if [ -f $MAINSH ]; then
	    CLASS="$(cat $MAINSH | grep "^ java" | cut -f10 -d" ")"
        CLASS2=`echo $CLASS | sed -e 's/$ROOT_PATH/./g'`
	    CLASEINICIO="$(cat $MAINSH | grep "^ java" | cut -f11 -d" ")"
	    java -Xms512M -Xmx1536M -Dconfig.dir=$DIR_CONFIG -Dconfig.file.mask=$CFG_FILE  -Duser.country=ES -Duser.language=es -cp $CLASS2 $CLASEINICIO --context=Default "$@"

           if [ $? = 0 ] ; then


                 > $DIR_LOCAL/apr_env_pcr_haya.txt

                 rm -f $DIR_LOCAL/backup/PCR-*
                 rm -f $DIR_LOCAL/backup/ZONAS*
                 rm -f $DIR_LOCAL/backup/OFICINAS*

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
                       put apr_env_pcr_haya.txt
                 
                       bye
END_OF_SESSION

                 mv -f $DIR_LOCAL/PCR-*     $DIR_LOCAL/backup/
                 mv -f $DIR_LOCAL/ZONAS*    $DIR_LOCAL/backup/
                 mv -f $DIR_LOCAL/OFICINAS* $DIR_LOCAL/backup/
                 rm -f $DIR_LOCAL/apr_env_pcr_haya.txt

	   else
	      echo "$(basename $0) Error en $filename: error en el ETL"
	      exit 1
	   fi
	else
	    echo "$(basename $0) Error en $filename: no se ha encontrado  $MAINSH"
	    exit 1
	fi




