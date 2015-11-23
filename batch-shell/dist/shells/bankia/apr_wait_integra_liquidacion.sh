#!/bin/bash
# Generado automaticamente a las mié jul 23 13:32:51 CEST 2014
 
ENTIDAD=2038
DIR_INPUT=/datos/usuarios/recovecb/transferencia/aprov_auxiliar/
MAX_WAITING_MINUTES=10
ficheros=LQ

#echo $(basename $0)

DIR_DESTINO=/datos/usuarios/recovecb/etl/input/

mascara=??.txt

OIFS=$IFS
IFS=','
arrayFicheros=$ficheros

#Calculo de hora limite
hora_limite=`date --date="$MAX_WAITING_MINUTES minutes" +%Y%m%d%H%M%S`
hora_actual=`date +%Y%m%d%H%M%S`
#echo "Hora actual: $hora_actual - Hora limite: $hora_limite"

for fichero in $arrayFicheros
do
	ficheroTxt=$DIR_INPUT$fichero$mascara

	while [ "$hora_actual" -lt "$hora_limite" -a ! -e $ficheroTxt ]; do
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
	ficherosTxt=$DIR_INPUT$fichero$mascara
	mv $ficherosTxt $DIR_DESTINO
   done
   echo "$(basename $0) Ficheros encontrados"
   exit 0
fi
