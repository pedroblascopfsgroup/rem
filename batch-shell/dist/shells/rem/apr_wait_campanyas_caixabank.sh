#!/bin/bash
 
fichero=HA_EC_CAMP_Agrupadores,HA_EC_CAMP_Perimetros,HA_EC_CAMP_Fases,HA_EC_CAMP_Contenidos
fecha="_$1"

if [[ -z ${DIR_DESTINO} ]] || [[ ! -d ${DIR_DESTINO} ]]; then
    echo "$(basename $0) Error: DIR_DESTINO no definido o no es un directorio. Compruebe invocación previa a setBatchEnv.sh"
    exit 1
fi

extensionTxt=".csv"

OIFS=$IFS
IFS=','
arrayfichero=$fichero

#Calculo de hora limite
hora_limite=`date --date="$MAX_WAITING_MINUTES minutes" +%Y%m%d%H%M%S`
hora_actual=`date +%Y%m%d%H%M%S`
echo "Hora actual: $hora_actual - Hora limite: $hora_limite"

for fichero in $arrayfichero
do
    var=$(ls ${DIR_DESTINO}$fichero*)
    if [ -f $var ]; then
        mv ${DIR_DESTINO}$fichero* ${DIR_BACKUP}
    fi

    ficheroTxt=$DIR_INPUT_AUX$fichero$fecha$extensionTxt

    echo "$ficheroTxt"
    if [[ "$#" -eq 1 ]]; then
        ./ftp/ftp_get_from_bc.sh $fichero$fecha$extensionTxt
    fi
        while [[ "$hora_actual" -lt "$hora_limite" ]] && [[ ! -e $ficheroTxt ]]; do
            sleep 10
            hora_actual=`date +%Y%m%d%H%M%S`
        if [[ "$#" -eq 1 ]]; then
            ./ftp/ftp_get_from_bc.sh $fichero$fecha$extensionTxt
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
            ./ftp/ftp_mv_backup_bc.sh $fichero$fecha$extensionTxt
            ficheroTxt=$DIR_INPUT_AUX$fichero$fecha$extensionTxt
            mv $ficheroTxt $DIR_DESTINO$fichero$extensionTxt

   done
   echo "$(basename $0) fichero encontrados"
   exit 0
fi
