#!/bin/bash
# Generado automaticamente a las mié jul 23 13:32:51 CEST 2014
 
DIR_BASE_ETL=/aplicaciones/recovecb/programas/etl

filename=$(basename $0)
nameETL="${filename%.*}"

#./extract_wait.sh $filename

case "$1" in
4)  sleep 30
    ;;
5)  sleep 30
    ;;
6)  sleep 30
    ;;
7)  sleep 60
    ;;
104)  sleep 60
    ;;
105)  sleep 90
    ;;
106)  sleep 90
    ;;
107)  sleep 90
    ;;
110)  sleep 120
    ;;
115)  sleep 120
    ;;
502)  sleep 120
    ;;
8)  sleep 150
    ;;
esac

export DIR_ETL=$DIR_BASE_ETL/$nameETL
export DIR_CONFIG=$DIR_BASE_ETL/config/
export CFG_FILE=config.ini
export MAINSH="$nameETL"_run.sh

cd "$DIR_ETL" &> null
if [ $? = 1 ] ; then
   echo "$(basename $0) Error en $filename: directorio inexistente $DIR_ETL"
   exit 1
fi

#echo "Variable de entrada:> $1";
echo "Direccion del ETL:> $DIR_ETL";
echo "Direccion fichero de configuracion:> $DIR_CONFIG";
echo "Nombre fichero configuracion:> $CFG_FILE";
echo "Nombre del ETL a ejecutar:> $MAINSH";



if [ -f $MAINSH ]; then
    CLASS="$(cat $MAINSH | grep "^ java" | cut -f10 -d" ")"
    CLASS2=`echo $CLASS | sed -e 's/$ROOT_PATH/./g'`
    CLASEINICIO="$(cat $MAINSH | grep "^ java" | cut -f11 -d" ")"
    java -Xms512M -Xmx1536M -Dconfig.dir=$DIR_CONFIG -Dconfig.file.mask=$CFG_FILE -Duser.country=ES -Duser.language=es -Dconfig.param=$1 -cp $CLASS2 $CLASEINICIO --context=Default "$@"
    if [ "$?" != "0" ] ; then
        sleep 10
        java -Xms512M -Xmx1536M -Dconfig.dir=$DIR_CONFIG -Dconfig.file.mask=$CFG_FILE -Duser.country=ES -Duser.language=es -Dconfig.param=$1 -cp $CLASS2 $CLASEINICIO --context=Default "$@"
        exit $?
    else
        exit 0
    fi
else
    echo "$(basename $0) Error en $filename: no se ha encontrado  $MAINSH"
    exit 1
fi

