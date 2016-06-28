#!/bin/bash
# Generado jun 20 Wait que espera ficheros del mismo día, si no están no hace nada.
 
MAX_WAITING_MINUTES=360
ficheros=BIENES,BIENCNT,BIENPER

#echo $(basename $0)
fechabien=`date --date= +%Y%m%d`
mascara='_'$ENTIDAD_AUXILIAR'_'$fechabien
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
   exit 1
else
   for fichero in $arrayFicheros
   do
	mascaraSem=$DIR_INPUT_AUX/$fichero$mascara$extensionSem
        mascaraZip=$DIR_INPUT_AUX/$fichero$mascara$extensionZip
        ficheroSem=`ls -A $mascaraSem | tail -n 1`
        ficheroZip=`ls -A $mascaraZip | tail -n 1`

	sed -i 's/ //g' $ficheroSem
	mv $ficheroZip $DIR_DESTINO
	mv $ficheroSem $DIR_DESTINO
   done
   echo "$(basename $0) Ficheros encontrados"

fi
