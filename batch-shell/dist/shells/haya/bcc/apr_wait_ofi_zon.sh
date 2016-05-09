#!/bin/bash
 

ficheros=OFICINAS,ZONAS

if [[ -z ${DIR_DESTINO} ]] || [[ ! -d ${DIR_DESTINO} ]]; then
    echo "$(basename $0) Error: DIR_DESTINO no definido o no es un directorio. Compruebe invocación previa a setBatchEnv.sh"
    exit 1
fi
rm -f $DIR_DESTINO*

if [[ -z ${DIR_BCC_INPUT} ]] || [[ ! -d ${DIR_BCC_INPUT} ]]; then
    echo "$(basename $0) Error: DIR_BCC_INPUT no definido o no es un directorio. Compruebe invocación previa a setBatchEnv.sh"
    exit 1
fi
rm -f $DIR_BCC_INPUT*

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
hora_limite=`date --date="$MAX_WAITING_MINUTES_FOR_START minutes" +%Y%m%d%H%M%S`
hora_actual=`date +%Y%m%d%H%M%S`
echo "Hora actual: $hora_actual - Hora limite: $hora_limite"

for fichero in $arrayFicheros
do
	ficheroSem=$DIR_INPUT_TR$fichero$mascara$extensionSem
    ficheroZip=$DIR_INPUT_TR$fichero$mascara$extensionZip

    echo "$ficheroSem"
    if [[ "$#" -gt 1 ]] && [[ "$2" -eq "-ftp" ]]; then
	    ./ftp/ftp_get_tr_files.sh $1 $fichero
    fi
	while [ "$hora_actual" -lt "$hora_limite" -a ! -e $ficheroSem -o ! -e $ficheroZip ]; do
	    sleep 900
	    hora_actual=`date +%Y%m%d%H%M%S`
        if [[ "$#" -gt 1 ]] && [[ "$2" -eq "-ftp" ]]; then
	        ./ftp/ftp_get_tr_files.sh $1 $fichero
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
	    ficheroSem=$DIR_INPUT_TR$fichero$mascara$extensionSem
        ficheroZip=$DIR_INPUT_TR$fichero$mascara$extensionZip
	
	    sed -i 's/ //g' $ficheroSem
	    mv $ficheroZip $DIR_DESTINO
	    mv $ficheroSem $DIR_DESTINO
   done
   echo "$(basename $0) Ficheros encontrados"
   exit 0
fi

