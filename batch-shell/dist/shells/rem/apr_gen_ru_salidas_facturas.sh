#!/bin/bash
# Generado por GUSTAVO MORA 20170810

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
    CLASS2="$(cat $MAINSH | sed 's/ /\n/g' | grep '$ROOT_PATH' | sed -e 's/$ROOT_PATH/./g')"
    CLASEINICIO="$(cat $MAINSH | sed 's/ /\n/g' | grep -v '$ROOT_PATH' | grep $nameETL)"
    java -Xms512M -Xmx1536M -Dconfig.dir=$DIR_CONFIG -Dconfig.file.mask=$CFG_FILE -Duser.country=ES -Duser.language=es -Dconfig.param=$1 -cp $CLASS2 $CLASEINICIO --context=Default "$@"  
else
    echo "$(basename $0) Error en $filename: no se ha encontrado  $MAINSH"
    exit 1
fi

