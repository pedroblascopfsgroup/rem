#!/bin/bash

fichero=RESULT_TAS

if [[ -z ${DIR_DESTINO} ]] || [[ ! -d ${DIR_DESTINO} ]]; then
    echo "$(basename $0) Error: DIR_DESTINO no definido o no es un directorio. Compruebe invocación previa a setBatchEnv.sh"
    exit 1
fi

extensionTxt="-$1.csv"
OIFS=$IFS
IFS=','
arrayfichero=$fichero

#Calculo de hora limite
hora_limite=`date --date="$MAX_WAITING_MINUTES minutes" +%Y%m%d%H%M%S`
hora_actual=`date +%Y%m%d%H%M%S`
echo "Hora actual: $hora_actual - Hora limite: $hora_limite"

for fichero in $arrayfichero; do
  ficheroTxt=${DIR_DESTINO}bbva/$fichero$extensionTxt

  echo "$ficheroTxt"
  while [[ "$hora_actual" -lt "$hora_limite" ]] && [[ ! -e $ficheroTxt ]]; do
    if [[ "$#" -eq 1 ]]; then
      ./ftp/ftp_get_tasaciones_bbva_files.sh $1 $fichero
    fi
    sleep 10
    hora_actual=`date +%Y%m%d%H%M%S`
  done
done

if [ "$hora_actual" -ge "$hora_limite" ]; then
  echo "$(basename $0) Error: Tiempo límite alcanzado: fichero $fichero no encontrados"
  exit 1
else
  echo "$(basename $0) ficheros encontrados"
  exit 0
fi

