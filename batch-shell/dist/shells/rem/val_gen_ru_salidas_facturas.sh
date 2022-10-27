#!/bin/bash
# Generado por GUSTAVO MORA 20170810
 


filename=$(basename $0)
nameETL="${filename%.*}"

export DIR_ETL=$DIR_BASE_ETL/$nameETL
export DIR_CONFIG=$DIR_BASE_ETL/config/
export CFG_FILE=config.ini
export MAINSH="$nameETL"_run.sh
export OUTPUT_PATH=`cat $DIR_CONFIG$CFG_FILE | grep 'output_dir;' | cut -d';' -f2`
export PREVALIDADO_PATH=$OUTPUT_PATH/prevalidado
export FECHA_EJECUCION_ACTUAL=`date +%Y%m%d`
export FECHA_PARAMETRO=$1

cd "$DIR_ETL" &> /dev/null
if [ $? -ne 0 ] ; then
   echo "$(basename $0) Error en $filename: directorio inexistente $DIR_ETL"
   exit 1
fi

if [ -z "$FECHA_PARAMETRO" ] && [ -z "$FECHA_EJECUCION_ACTUAL" ] ; then
	echo "$(basename $0) ERROR, No se ha indicado fecha ni por parametro ni por variable"
 	exit 1
fi

if [ ! -z "$FECHA_PARAMETRO" ] ; then

	if test ! -f ${OUTPUT_PATH}/RUFACTUSP_?????_$FECHA_PARAMETRO.txt ; then
	   echo "$(basename $0) Error ${OUTPUT_PATH}/RUFACTUSP_?????_$FECHA_PARAMETRO.txt inexistente"
	   exit 1
	fi

	if test ! -f ${OUTPUT_PATH}/RUFACTUCP_?????_$FECHA_PARAMETRO.txt ; then
	   echo "$(basename $0) Error ${OUTPUT_PATH}/RUFACTUCP_?????_$FECHA_PARAMETRO.txt inexistente"
	   exit 1
	fi

	if test ! -f ${OUTPUT_PATH}/RUFACTUSP_?????_$FECHA_PARAMETRO.sem ; then
	   echo "$(basename $0) Error ${OUTPUT_PATH}/RUFACTUSP_?????_$FECHA_PARAMETRO.sem inexistente"
	   exit 1
	fi

	if test ! -f ${OUTPUT_PATH}/RUFACTUCP_?????_$FECHA_PARAMETRO.sem ; then
	   echo "$(basename $0) Error ${OUTPUT_PATH}/RUFACTUCP_?????_$FECHA_PARAMETRO.sem inexistente"
	   exit 1
	fi
	mv $OUTPUT_PATH/RUFACTU*_?????_$FECHA_PARAMETRO.* $PREVALIDADO_PATH/
	
elif [ ! -z "$FECHA_EJECUCION_ACTUAL" ] ; then

	if test ! -f ${OUTPUT_PATH}/RUFACTUSP_?????_$FECHA_EJECUCION_ACTUAL.txt ; then
	   echo "$(basename $0) Error ${OUTPUT_PATH}/RUFACTUSP_?????_$FECHA_EJECUCION_ACTUAL.txt inexistente"
	   exit 1
	fi

	if test ! -f ${OUTPUT_PATH}/RUFACTUCP_?????_$FECHA_EJECUCION_ACTUAL.txt ; then
	   echo "$(basename $0) Error ${OUTPUT_PATH}/RUFACTUCP_?????_$FECHA_EJECUCION_ACTUAL.txt inexistente"
	   exit 1
	fi

	if test ! -f ${OUTPUT_PATH}/RUFACTUSP_?????_$FECHA_EJECUCION_ACTUAL.sem ; then
	   echo "$(basename $0) Error ${OUTPUT_PATH}/RUFACTUSP_?????_$FECHA_EJECUCION_ACTUAL.sem inexistente"
	   exit 1
	fi

	if test ! -f ${OUTPUT_PATH}/RUFACTUCP_?????_$FECHA_EJECUCION_ACTUAL.sem ; then
	   echo "$(basename $0) Error ${OUTPUT_PATH}/RUFACTUCP_?????_$FECHA_EJECUCION_ACTUAL.sem inexistente"
	   exit 1
	fi
	mv $OUTPUT_PATH/RUFACTU*_?????_$FECHA_EJECUCION_ACTUAL.* $PREVALIDADO_PATH/
fi





if [ -f $MAINSH ]; then
    CLASS="$(cat $MAINSH | grep "^ java" | cut -f10 -d" ")"
    CLASS2=`echo $CLASS | sed -e 's/$ROOT_PATH/./g'`
    CLASEINICIO="$(cat $MAINSH | grep "^ java" | cut -f11 -d" ")"
    java -Xms512M -Xmx1536M -Dconfig.dir=$DIR_CONFIG -Dconfig.file.mask=$CFG_FILE -Duser.country=ES -Duser.language=es -cp $CLASS2 $CLASEINICIO --context=Default "$@"
    exit $?
else
    echo "$(basename $0) Error en $filename: no se ha encontrado  $MAINSH"
    exit 1
fi

