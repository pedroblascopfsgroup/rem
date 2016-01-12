#!/bin/bash
# Generado automaticamente a las mié jul 23 13:32:51 CEST 2014

ENTIDAD=0240 
DIR_INPUT=../control/etl/backup/
MAX_WAITING_MINUTES=1
ficheros=OFICINAS,ZONAS,USUARIOS,ZONPEFUSU

#echo $(basename $0)

DIR_DESTINO=../control/etl/output/aprov-haya/

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
	ficheroSem=$DIR_INPUT$fichero$mascara$extensionSem
    ficheroZip=$DIR_INPUT$fichero$mascara$extensionZip

       #echo "$ficheroSem"
	while [ "$hora_actual" -lt "$hora_limite" -a ! -e $ficheroSem -a ! -e $ficheroZip ]; do
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
		mascaraSem=$DIR_INPUT$fichero$mascara$extensionSem
        mascaraZip=$DIR_INPUT$fichero$mascara$extensionZip
        ficheroSem=`ls -Art $mascaraSem | tail -n 1`
        ficheroZip=`ls -Art $mascaraZip | tail -n 1`
	
	sed -i 's/ //g' $ficheroSem
	
	#echo "$ficheroZip" "$DIR_DESTINO"
	#echo "$ficheroSem" "$DIR_DESTINO"
	cp $ficheroZip $DIR_DESTINO
	cp $ficheroSem $DIR_DESTINO
   done
   echo "$(basename $0) Ficheros encontrados"
   exit 0
fi
