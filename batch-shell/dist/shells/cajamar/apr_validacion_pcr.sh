#!/bin/bash
# Generado automaticamente a las mié jul 23 13:32:51 CEST 2014
 
DIR_BASE_ETL=/recovery/batch-server/programas/etl

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

echo "Variable de entrada:> $1";
echo "Direccion del ETL:> $DIR_ETL";
echo "Direccion fichero de configuracion:> $DIR_CONFIG";
echo "Nombre fichero configuracion:> $CFG_FILE";
echo "Nombre del ETL a ejecutar:> $MAINSH";

if [ -f $MAINSH ]; then
    CLASS="$(cat $MAINSH | grep "^ java" | cut -f11 -d" ")"
    CLASS2=`echo $CLASS | sed -e 's/$ROOT_PATH/./g'`
    CLASEINICIO="$(cat $MAINSH | grep "^ java" | cut -f12 -d" ")"
    java -Xms512M -Xmx1536M -Dconfig.dir=$DIR_CONFIG -Dconfig.file.mask=$CFG_FILE -Duser.country=ES -Duser.language=es -Dconfig.param=$1 -cp $CLASS2 $CLASEINICIO --context=Default "$@"
    #echo "-Dconfig.dir=$DIR_CONFIG -Dconfig.file.mask=$CFG_FILE -Duser.country=ES -Duser.language=es -Dconfig.param=$1 -cp $CLASS2 $CLASEINICIO --context=Default"
    exit $?
else
    echo "$(basename $0) Error en $filename: no se ha encontrado  $MAINSH"
    exit 1
fi


