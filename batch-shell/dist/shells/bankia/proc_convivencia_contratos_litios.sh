#!/bin/bash
# Generado manualmente
 
SERVER=10.64.132.59
USER=ftpsocpart
PASSW=tempo.99
PORT=2153
DIR_LOCAL=/mnt/fs_servicios/recovecb/transferencia/aprov_convivencia/salida
DIR_DESTINO=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya/in/aprovisionamiento/troncal/ 
DIR_BASE_ETL=/aplicaciones/recovecb/programas/etl



	ftp -vn $SERVER <<END_OF_SESSION
        user $USER $PASSW
        lcd $DIR_LOCAL
        cd $DIR_DESTINO
        bin
        get cnt_procedimientos_vivos_haya.dat
        bye
END_OF_SESSION
	
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
	    exit $?
	else
	    echo "$(basename $0) Error en $filename: no se ha encontrado  $MAINSH"
	    exit 1
	fi
