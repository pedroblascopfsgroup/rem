#!/bin/bash
# Generado automaticamente a las mié jul 23 13:32:51 CEST 2014

MAX_WAITING_MINUTES=570
ficheros=ALTA_PROCEDIMIENTOS_,ALTA_PROCEDIMIENTOS_BIENES_,ALTA_PROCEDIMIENTOS_CONTRATOS_,ALTA_PROCEDIMIENTOS_PERSONAS_

#echo $(basename $0)

mascara=????????
extension=".dat"

OIFS=$IFS
IFS=','
arrayFicheros=$ficheros

#Calculo de hora limite
hora_limite=`date --date="$MAX_WAITING_MINUTES minutes" +%Y%m%d%H%M%S`
hora_actual=`date +%Y%m%d%H%M%S`
#echo "Hora actual: $hora_actual - Hora limite: $hora_limite"

for fichero in $arrayFicheros
do
	ficheroDat=$DIR_INPUT_TR$fichero$mascara$extension

        #echo "$ficheroSem"
	while [ "$hora_actual" -lt "$hora_limite" -a ! -e $ficheroDat ]; do
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
	mascaraDat=$DIR_INPUT_TR$fichero$mascara$extension
        ficheroDat=`ls -Art $mascaraDat | tail -n 1`

	mv $ficheroDat $DIR_INPUT_CONV
   done
   echo "$(basename $0) Ficheros encontrados"
   exit 0
fi
