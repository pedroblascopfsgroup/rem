#!/bin/bash

ficheros=OFICINAS,ZONAS

if [ -z "$1" ]; then
    echo "$(basename $0) Error: parámetro de entrada YYYYMMDD no definido."
    exit 1
fi

mascara='_'$ENTIDAD'_'$1
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
	ficheroSem=$DIR_BACKUP$fichero$mascara$extensionSem
    ficheroZip=$DIR_BACKUP$fichero$mascara$extensionZip

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
		ficheroSem=$DIR_BACKUP$fichero$mascara$extensionSem
        ficheroZip=$DIR_BACKUP$fichero$mascara$extensionZip
	
	    sed -i 's/ //g' $ficheroSem
	
	    cp $ficheroZip $DIR_HRE_OUTPUT
	    cp $ficheroSem $DIR_HRE_OUTPUT
   done
   echo "$(basename $0) Ficheros encontrados"
   exit 0
fi
