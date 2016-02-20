#!/bin/bash
 
ficheros=STOCK_PRECON_PRC,STOCK_PRECON_LIQ,STOCK_PRECON_DOC,STOCK_PRECON_SOL,STOCK_PRECON_BUR,STOCK_PRECON_ENV

mascara='_'????????
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
	ficheroSem=$DIR_HRE_INPUT$fichero$mascara$extensionSem
    ficheroZip=$DIR_HRE_INPUT$fichero$mascara$extensionZip

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
   echo "$(basename $0) Ficheros encontrados"
   exit 0
fi
