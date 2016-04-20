#!/bin/bash
# Generado automaticamente a las mié jul 23 13:32:51 CEST 2014
 
MAX_WAITING_MINUTES=720
ficheros=CIRBE

#echo $(basename $0)

mascara='_'$ENTIDAD'_'????????
extensionSem=".sem"
extensionZip=".zip"

OIFS=$IFS
IFS=','
arrayFicheros=$ficheros

#Calculo de hora limite
hora_limite=`date --date="$MAX_WAITING_MINUTES minutes" +%Y%m%d%H%M%S`
hora_actual=`date +%Y%m%d%H%M%S`
#echo "Hora actual: $hora_actual - Hora limite: $hora_limite"

for fichero in $arrayFicheros
do
	ficheroSem=$DIR_INPUT_AUX/$fichero$mascara$extensionSem
        ficheroZip=$DIR_INPUT_AUX/$fichero$mascara$extensionZip

        #echo "$ficheroSem"
	while [ "$hora_actual" -lt "$hora_limite" -a ! -e $ficheroSem -o ! -e $ficheroZip ]; do
	   sleep 10
	   hora_actual=`date +%Y%m%d%H%M%S`
	   #echo "$hora_actual"
	done
done

if [ "$hora_actual" -ge "$hora_limite" ]
then
   echo "$(basename $0) Error: Tiempo límite alcanzado: ficheros $ficheros no encontrados"
   exit 0
else
   for fichero in $arrayFicheros
   do
	mascaraSem=$DIR_INPUT_AUX/$fichero$mascara$extensionSem
        mascaraZip=$DIR_INPUT_AUX/$fichero$mascara$extensionZip
	ficheroSem=`ls -Art $mascaraSem | tail -n 1`
        ficheroZip=`ls -Art $mascaraZip | tail -n 1`
	
	sed -i 's/ //g' $ficheroSem
	mv $mascaraZip $DIR_DESTINO
	mv $mascaraSem $DIR_DESTINO
   done
   echo "$(basename $0) Ficheros encontrados"

fi

#!/bin/bash
# Generado automaticamente a las mié jul 23 13:32:51 CEST 2014

filename=$(basename $0)
nameETL="${filename%.*}"

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
    exit $?
else
    echo "$(basename $0) Error en $filename: no se ha encontrado  $MAINSH"
    exit 1
fi
