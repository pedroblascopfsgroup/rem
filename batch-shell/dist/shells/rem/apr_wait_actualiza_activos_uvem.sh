#!/bin/bash
 
ficheros=DATOS_ACTIVOS,CALIDADES_ACTIVOS,DISTRIBUCION_ACTIVOS
ficherosrm=DATOS_ACTIVOS*,CALIDADES_ACTIVOS*,DISTRIBUCION_ACTIVOS*

if [[ -z ${DIR_DESTINO} ]] || [[ ! -d ${DIR_DESTINO} ]]; then
    echo "$(basename $0) Error: DIR_DESTINO no definido o no es un directorio. Compruebe invocación previa a setBatchEnv.sh"
    exit 1
fi

mascara='_'$1
extensionSem=".sem"
extensionZip=".dat"

OIFS=$IFS
IFS=','
arrayFicheros=$ficheros
arrayFicherosrm=$ficherosrm

for fichero in $arrayFicherosrm
do

rm -f ${DIR_DESTINO}$fichero

done

#Calculo de hora limite
hora_limite=`date --date="$MAX_WAITING_MINUTES minutes" +%Y%m%d%H%M%S`
hora_actual=`date +%Y%m%d%H%M%S`
echo "Hora actual: $hora_actual - Hora limite: $hora_limite"

for fichero in $arrayFicheros
do
	ficheroSem=$DIR_INPUT_AUX$fichero$mascara$extensionSem
    ficheroZip=$DIR_INPUT_AUX$fichero$mascara$extensionZip

    echo "$ficheroSem"
    if [[ "$#" -gt 1 ]] && [[ "$2" -eq "-ftp" ]]; then
        ./ftp/ftp_get_aux_files.sh $1 $fichero
    fi
	while [[ "$hora_actual" -lt "$hora_limite" ]] && [[ ! -e $ficheroSem || ! -e $ficheroZip ]]; do
	    sleep 10
	    hora_actual=`date +%Y%m%d%H%M%S`
        if [[ "$#" -gt 1 ]] && [[ "$2" -eq "-ftp" ]]; then
	        ./ftp/ftp_get_aux_files.sh $1 $fichero
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
	    ficheroSem=$DIR_INPUT_AUX$fichero$mascara$extensionSem
        ficheroZip=$DIR_INPUT_AUX$fichero$mascara$extensionZip
	
	    sed -i 's/ //g' $ficheroSem
	    mv $ficheroZip $DIR_DESTINO
	    mv $ficheroSem $DIR_DESTINO
   done
   echo "$(basename $0) Ficheros encontrados"
   exit 0
fi

