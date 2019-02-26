#!/bin/bash
 
ficheros=stock_bienes.dat,cargas_bienes.dat

if [[ -z ${DIR_DESTINO} ]] || [[ ! -d ${DIR_DESTINO} ]]; then
    echo "$(basename $0) Error: DIR_DESTINO no definido o no es un directorio. Compruebe invocación previa a setBatchEnv.sh"
    exit 1
fi

rm -f ${DIR_DESTINO}cargas_bienes.dat

rm -f ${DIR_DESTINO}stock_bienes.dat
 

OIFS=$IFS
IFS=','
arrayFicheros=$ficheros

#Calculo de hora limite
hora_limite=`date --date="$MAX_WAITING_MINUTES minutes" +%Y%m%d%H%M%S`
hora_actual=`date +%Y%m%d%H%M%S`
echo "Hora actual: $hora_actual - Hora limite: $hora_limite"

for fichero in $arrayFicheros
do
    ficheroDat=$DIR_INPUT_AUX$fichero

    echo "$ficheroDat"
    if [[ "$#" -gt 0 ]] && [[ "$1" -eq "-ftp" ]]; then
        ./ftp/ftp_get_stock_bienes.sh
	./ftp/ftp_get_cargas_bienes.sh
    fi
	while [[ "$hora_actual" -lt "$hora_limite" ]] && [[ ! -e $ficheroDat ]]; do
	    sleep 10
	    hora_actual=`date +%Y%m%d%H%M%S`
        if [[ "$#" -gt 0 ]] && [[ "$1" -eq "-ftp" ]]; then
	        ./ftp/ftp_get_stock_bienes.sh
		./ftp/ftp_get_cargas_bienes.sh
        fi
	done
done

if [ "$hora_actual" -ge "$hora_limite" ]
then
   echo "$(basename $0) Error: Tiempo límite alcanzado: ficheros $ficheros no encontrados"
   exit 1
else
   for fichero in $arrayFicheros
   do
        ficheroDat=$DIR_INPUT_AUX$fichero
	
	    mv $ficheroDat $DIR_DESTINO
   done
   echo "$(basename $0) Ficheros encontrados"
   exit 0
fi

