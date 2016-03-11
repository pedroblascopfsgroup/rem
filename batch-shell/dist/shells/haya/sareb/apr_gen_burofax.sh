#!/bin/bash
# Generado automaticamente a las mié jul 23 13:32:51 CEST 2014

DIR_BASE_ETL=/etl/HRE/programas/etl

filename=$(basename $0)
nameETL="${filename%.*}"

NOM_ETL=ENVIO_BUROFAX_
ENVIO_DOCALIA=/sftp_docalia/burofax/envio
DIR_DESTINO=/home/ops-haya/etl/output

export DIR_ETL=$DIR_BASE_ETL/$nameETL
export DIR_CONFIG=$DIR_BASE_ETL/config/
export CFG_FILE=config.ini
export MAINSH="$nameETL"_run.sh

echo "Nombre del directorio= $DIR_ETL"

if [ ! -d $DIR_ETL ] ; then
	echo "$(basename $0) Error en $filename: directorio inexistente $DIR_ETL"
	exit 1
fi

cd $DIR_ETL

if [ -f $MAINSH ]; then
    CLASS="$(cat $MAINSH | grep "^ java" | cut -f10 -d" ")"
    CLASS2=`echo $CLASS | sed -e 's/$ROOT_PATH/./g'`
    CLASEINICIO="$(cat $MAINSH | grep "^ java" | cut -f11 -d" ")"
    java -Xms512M -Xmx1536M -Dconfig.dir=$DIR_CONFIG -Dconfig.file.mask=$CFG_FILE -Duser.country=ES -Duser.language=es -cp $CLASS2 $CLASEINICIO --context=Default "$@"
     result=$?
    if [ $result -eq 0 ]; then
        mv $DIR_DESTINO/$NOM_ETL*.txt $ENVIO_DOCALIA
        exit $result
    else
        exit $result
    fi

else
    echo "$(basename $0) Error en $filename: no se ha encontrado  $MAINSH"
    exit 1
fi
