#!/bin/bash

ficheros=ALERTAS

mascara='_'$ENTIDAD'_'????????
extensionSem=".sem"
extensionZip=".zip"

OIFS=$IFS
IFS=','
arrayFicheros=$ficheros

#Calculo de hora limite
hora_limite=`date --date="$MAX_WAITING_MINUTES minutes" +%Y%m%d%H%M%S`
hora_actual=`date +%Y%m%d%H%M%S`
echo "Hora actual: $hora_actual - Hora limite: $hora_limite"

for fichero in $arrayFicheros
do	
	./ftp/ftp_get_aux_monthly_files.sh $fichero
	numFicherosSem=`find $DIR_INPUT_AUX -name $fichero$mascara$extensionSem | wc -l`
	numFicherosZip=`find $DIR_INPUT_AUX -name $fichero$mascara$extensionZip | wc -l`
	while [ "$hora_actual" -lt "$hora_limite" -a $numFicherosSem -eq 0 -o $numFicherosZip -eq 0 ]; do
		sleep 10
		hora_actual=`date +%Y%m%d%H%M%S`
		./ftp/ftp_get_aux_monthly_files.sh $fichero
		numFicherosSem=`find $DIR_INPUT_AUX -name $fichero$mascara$extensionSem | wc -l`
		numFicherosZip=`find $DIR_INPUT_AUX -name $fichero$mascara$extensionZip | wc -l`
	done
done

if [ "$hora_actual" -ge "$hora_limite" ]
then
   echo "$(basename $0) Error: Tiempo límite alcanzado: ficheros $ficheros no encontrados"
   exit 1
else
   for fichero in $arrayFicheros
   do
	    mascaraSem=$DIR_INPUT_AUX$fichero$mascara$extensionSem
        mascaraZip=$DIR_INPUT_AUX$fichero$mascara$extensionZip
        ficheroSem=`ls $mascaraSem | sort | tail -n 1`
        ficheroZip=`ls $mascaraZip | sort | tail -n 1`
	
	    sed -i 's/ //g' $ficheroSem
	    mv $ficheroZip $DIR_DESTINO
	    mv $ficheroSem $DIR_DESTINO
   done
   echo "$(basename $0) Ficheros encontrados"
   exit 0
fi
