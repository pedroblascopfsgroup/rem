#!/bin/bash
 
fichero=URSITFAC

if [[ -z ${DIR_DESTINO} ]] || [[ ! -d ${DIR_DESTINO} ]]; then
    echo "$(basename $0) Error: DIR_DESTINO no definido o no es un directorio. Compruebe invocación previa a setBatchEnv.sh"
    exit 1
fi
rm -f ${DIR_DESTINO}$fichero*

extensionTxt=".txt"

OIFS=$IFS
IFS=','
arrayfichero=$fichero

#Calculo de hora limite
hora_limite=`date --date="$MAX_WAITING_MINUTES minutes" +%Y%m%d%H%M%S`
hora_actual=`date +%Y%m%d%H%M%S`
echo "Hora actual: $hora_actual - Hora limite: $hora_limite"

for fichero in $arrayfichero
do
     ficheroTxt=$DIR_INPUT_AUX$fichero$extensionTxt

    echo "$ficheroTxt"
    if [[ "$#" -eq 1 ]]; then
        ./ftp_get_URSITFAC_files.sh $1 $fichero
    fi
done

if [ ! -e $ficheroTxt ]
then
   echo "$(basename $0) Error: fichero $fichero no encontrado para $1 . No se copia"
   exit 99
else
   for fichero in $arrayfichero
   do
            ficheroTxt=$DIR_INPUT_AUX$fichero$extensionTxt

            mv $ficheroTxt $DIR_DESTINO

   done
   echo "$(basename $0) fichero encontrados"
   exit 0
fi

