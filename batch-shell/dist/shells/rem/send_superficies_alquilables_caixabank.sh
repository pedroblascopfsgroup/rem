#!/bin/bash
# Generado automaticamente a las mar nov 16 11:17:51 CEST 2021
 
filename=$(basename $0)
nameETL="${filename%.*}"

export DIR_ETL=$DIR_BASE_ETL/$nameETL
export DIR_CONFIG=$DIR_BASE_ETL/config/
export CFG_FILE=config.ini
export MAINSH="$nameETL"_run.sh

if [ ! -d "$DIR_ETL" ] ; then
   echo "$(basename $0) Error en $filename: directorio inexistente $DIR_ETL"
   exit 1
fi

cd $DIR_ETL

if [ -f $MAINSH ]; then
    CLASS="$(cat $MAINSH | sed 's/ /\n/g' | grep '$ROOT_PATH' | sed -e 's/$ROOT_PATH/./g')"
    CLASEINICIO="$(cat $MAINSH | sed 's/ /\n/g' | grep -v '$ROOT_PATH' | grep $nameETL)"
    java -Xms512M -Xmx1536M -Dconfig.dir=$DIR_CONFIG -Dconfig.file.mask=$CFG_FILE -Duser.country=ES -Duser.language=es -cp "$CLASS" "$CLASEINICIO" --context=Default "$@"
    exit $?
else
    echo "$(basename $0) Error en $filename: no se ha encontrado  $MAINSH"
    exit 1
fi
