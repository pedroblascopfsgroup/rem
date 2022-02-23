#!/bin/bash

source ./setBatchEnv.sh

filename=$(basename $0)
nameETL="${filename%.*}"

export DIR_ETL=$DIR_BASE_ETL/$nameETL
export DIR_CONFIG=$DIR_BASE_ETL/config/
export CFG_FILE=config.ini
export MAINSH="$nameETL"_run.sh

cd "$DIR_ETL" &> /dev/null
if [ $? -ne 0 ] ; then
   echo "$(basename $0) Error en $filename: directorio inexistente $DIR_ETL"
   exit 1
fi

if [ -f $MAINSH ]; then
    CLASS="$(cat $MAINSH | grep "^ java" | cut -f10 -d" ")"
    CLASS2=`echo $CLASS | sed -e 's/$ROOT_PATH/./g'`
    CLASEINICIO="$(cat $MAINSH | grep "^ java" | cut -f11 -d" ")"
    java -Xms512M -Xmx1536M -Dconfig.dir=$DIR_CONFIG -Dconfig.file.mask=$CFG_FILE -Duser.country=ES -Duser.language=es -cp $CLASS2 $CLASEINICIO --context=Default  "$@"
    SALIDA_SHELL=$?
    if [[ "$SALIDA_SHELL" == "0" ]] ; then
        DIR_SALIDA=$(cat ${DIR_CONFIG}${CFG_FILE} | grep 'output_dir;' | cut -d';' -f2)
        cd "$DIR_SALIDA"  &> /dev/null
        FECHA=$(date +%Y%m%d)
        NUEVA_FECHA=$(date +%Y%m%d -d "+1 days")
        fichero=`ls -tr STOCK_ACTIVOS_HH_${FECHA}_*.csv | tail -1` ; mv $fichero STOCK_ACTIVOS_HH_${NUEVA_FECHA}.csv
        fichero=`ls -tr STOCK_AGRUPACIONES_HH_${FECHA}_*.csv | tail -1` ; mv $fichero STOCK_AGRUPACIONES_HH_${NUEVA_FECHA}.csv
        fichero=`ls -tr STOCK_API_HH_${FECHA}_*.csv | tail -1` ; mv $fichero STOCK_API_HH_${NUEVA_FECHA}.csv
        fichero=`ls -tr STOCK_GESTORES_HH_${FECHA}_*.csv | tail -1` ; mv $fichero STOCK_GESTORES_HH_${NUEVA_FECHA}.csv
        fichero="STOCK_*_HH_${NUEVA_FECHA}.csv"
        if [[ `ls $fichero 2> /dev/null | wc -l` -gt 0  ]] ; then
            echo "Subiendo ficheros $fichero al FTP..."
lftp -u $SFTP_HH_USER,$SFTP_HH_PASS sftp://${SFTP_HH_HOST} <<EOF
cd "$SFTP_HH_RUTA"
mput $fichero
bye
EOF
            exit 0
        else
            echo "##### ERROR: No existe el fichero $fichero #####"
            exit 1
        fi
    fi
else
    echo "$(basename $0) Error en $filename: no se ha encontrado  $MAINSH"
    exit 1
fi
