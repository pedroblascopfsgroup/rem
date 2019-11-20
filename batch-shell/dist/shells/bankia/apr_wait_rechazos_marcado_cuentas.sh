#!/bin/bash
# Generado automaticamente a las mié jul 23 13:32:51 CEST 2014
 
ENTIDAD=2038
DIR_INPUT=/datos/usuarios/recovecb/transferencia/aprov_auxiliar/
MAX_WAITING_MINUTES=10
ficheros=rechazos_marcado_cuentas

#echo $(basename $0)

DIR_DESTINO=/datos/usuarios/recovecb/etl/input/

mascara=.dat

OIFS=$IFS
IFS=','
arrayFicheros=$ficheros

#Calculo de hora limite
hora_limite=`date --date="$MAX_WAITING_MINUTES minutes" +%Y%m%d%H%M%S`
hora_actual=`date +%Y%m%d%H%M%S`
echo "Hora actual: $hora_actual - Hora limite: $hora_limite"

for fichero in $arrayFicheros
do
    ficheroDat=$DIR_INPUT$fichero$mascara
    echo "Esperando fichero $ficheroDat"
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
	ficherosDat=$DIR_INPUT$fichero$mascara
	mv $ficherosDat $DIR_DESTINO
   done
   echo "$(basename $0) Fichero $ficheros encontrado"
   exit 0
   
fi
