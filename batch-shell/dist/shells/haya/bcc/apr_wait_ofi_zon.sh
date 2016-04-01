#!/bin/bash
 

ficheros=OFICINAS,ZONAS

if [ -z ${DIR_DESTINO} ]; then
    echo "$(basename $0) Error: DIR_DESTINO no definido. Compruebe invocación previa a setBatchEnv.sh"
    exit 1
fi
rm -f $DIR_DESTINO*

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
echo "Hora actual: $hora_actual - Hora limite: $hora_limite"

for fichero in $arrayFicheros
do
	ficheroSem=$DIR_INPUT_TR$fichero$mascara$extensionSem
    ficheroZip=$DIR_INPUT_TR$fichero$mascara$extensionZip

    echo "$ficheroSem"
	./ftp/ftp_get_ofi_zon.sh $1 $fichero
	while [ "$hora_actual" -lt "$hora_limite" -a ! -e $ficheroSem -a ! -e $ficheroZip ]; do
	   sleep 10
	   hora_actual=`date +%Y%m%d%H%M%S`
	   #echo "$hora_actual"
	   ./ftp/ftp_get_ofi_zon.sh $1 $fichero
	done
done

if [ "$hora_actual" -ge "$hora_limite" ]
then
   echo "$(basename $0) Error: Tiempo límite alcanzado: ficheros $ficheros no encontrados"
   exit 1
else
   for fichero in $arrayFicheros
   do
	    mascaraSem=$DIR_INPUT_TR$fichero$mascara$extensionSem
        mascaraZip=$DIR_INPUT_TR$fichero$mascara$extensionZip
        ficheroSem=`ls -Art $mascaraSem | tail -n 1`
        ficheroZip=`ls -Art $mascaraZip | tail -n 1`
	
	    sed -i 's/ //g' $ficheroSem
	    mv $ficheroZip $DIR_DESTINO
	    mv $ficheroSem $DIR_DESTINO
   done
   echo "$(basename $0) Ficheros encontrados"
   exit 0
fi

