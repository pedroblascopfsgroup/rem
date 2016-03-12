#!/bin/bash
 
ficheros=STOCK_ACU_ACU,STOCK_ACU_ANA,STOCK_ACU_TEA,STOCK_ACU_BIT,STOCK_ACU_TEC,STOCK_ACU_AAR,STOCK_ACU_AEA,STOCK_ACU_OPE

if [ -z "$1" ]; then
    echo "$(basename $0) Error: parámetro de entrada YYYYMMDD no definido."
    exit 1
fi

mascara='_'$1
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
	ficheroSem=$DIR_INPUT_AUX$fichero$mascara$extensionSem
    ficheroZip=$DIR_INPUT_AUX$fichero$mascara$extensionZip

    echo "$ficheroSem"
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
	    mascaraSem=$DIR_INPUT_AUX$fichero$mascara$extensionSem
        mascaraZip=$DIR_INPUT_AUX$fichero$mascara$extensionZip
        ficheroSem=`ls -Art $mascaraSem | tail -n 1`
        ficheroZip=`ls -Art $mascaraZip | tail -n 1`
	
        sed -i 's/ //g' $ficheroSem
        mv $ficheroZip $DIR_HRE_INPUT
	    mv $ficheroSem $DIR_HRE_INPUT
   done
   echo "$(basename $0) Ficheros encontrados"
   exit 0
fi

