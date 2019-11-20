#!/bin/bash
 
fichero=AR_FACTCON

if [[ -z ${DIR_DESTINO} ]] || [[ ! -d ${DIR_DESTINO} ]]; then
    echo "$(basename $0) Error: DIR_DESTINO no definido o no es un directorio. Compruebe invocación previa a setBatchEnv.sh"
    exit 1
fi
rm -f ${DIR_DESTINO}$fichero*

extensionTxt=".dat"

OIFS=$IFS
IFS=','
arrayfichero=${fichero}

#Calculo de hora limite
hora_limite=`date --date="$MAX_WAITING_MINUTES minutes" +%Y%m%d%H%M%S`
hora_actual=`date +%Y%m%d%H%M%S`
echo "Hora actual: $hora_actual - Hora limite: $hora_limite"

for fichero in $arrayfichero
do
     ficheroTxt=$DIR_INPUT_AUX${fichero}_$1$extensionTxt
    echo "fichero .dat: $ficheroTxt"
    if [[ "$#" -eq 1 ]]; then
        ./ftp/ftp_get_aspro_files.sh $1 ${fichero}_$1
    fi

        while [[ "$hora_actual" -lt "$hora_limite" ]] && [[ ! -e $ficheroTxt ]]; do
		echo "$hora_actual: No existe el fichero $ficheroTxt"
            sleep 10
            hora_actual=`date +%Y%m%d%H%M%S`
        if [[ "$#" -eq 1 ]]; then
            ./ftp/ftp_get_aspro_files.sh $1 ${fichero}_$1
        fi
        done
done

if [ "$hora_actual" -ge "$hora_limite" ]
then
   echo "$(basename $0) Error: Tiempo límite alcanzado: fichero $fichero no encontrados"
   exit 1
else
   for fichero in $arrayfichero
   do
	echo "Existe el fichero"
	    ficheroTxt=$DIR_INPUT_AUX${fichero}_$1$extensionTxt	
	echo "$ficheroTxt"
         mv $ficheroTxt $DIR_DESTINO
	echo "Fichero movido al destino $DIR_DESTINO"

   done
   echo "$(basename $0) fichero encontrado"
   exit 0
fi
