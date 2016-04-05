#!/bin/bash
# Generado automaticamente a las mié jul 23 13:32:51 CEST 2014
 
ENTIDAD=5074
CARPETA=pcr
DIR_DESTINO=/$DEVON_HOME/tmp/pfs/$ENTIDAD/$CARPETA/
MAX_WAITING_MINUTES=10
ficheros=PCR
WAIT_FOR_JOBS=cargaPCRvalidacionesPCRJob,cargaPCRPasajeProduccionJob,precalculoPCRProduccionJob

#echo $(basename $0)

mascara='-'$ENTIDAD'-'????????
extensionSem=".sem"
extensionZip=".zip"

OIFS=$IFS
IFS=','
arrayFicheros=$ficheros

#Calculo de hora limite
hora_limite=`date --date="$MAX_WAITING_MINUTES minutes" +%Y%m%d%H%M%S`
hora_actual=`date +%Y%m%d%H%M%S`
#echo "Hora actual: $hora_actual - Hora limite: $hora_limite"

for fichero in $arrayFicheros
do
	ficheroSem=$DIR_INPUT_TR$fichero$mascara$extensionSem
        ficheroZip=$DIR_INPUT_TR$fichero$mascara$extensionZip

        #echo "$ficheroSem"
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
fi

for fichero in $arrayFicheros
do
	mascaraSem=$DIR_INPUT_TR$fichero$mascara$extensionSem
        mascaraZip=$DIR_INPUT_TR$fichero$mascara$extensionZip
        ficheroSem=`ls -Art $mascaraSem | tail -n 1`
        ficheroZip=`ls -Art $mascaraZip | tail -n 1`

	sed -i 's/ //g' $ficheroSem	
	if [ `cat $ficheroSem | grep Direccion | wc -l` -ne 1 ]; then echo "Direcciones.rowcount=0" >> $ficheroSem ; fi
	mv $ficheroZip $DIR_DESTINO
	mv $ficheroSem $DIR_DESTINO
done

cd $DIR_SHELLS

CMD=($JAVA_HOME/bin/java -jar batch-shell.jar - - - =${ENTIDAD} "${WAIT_FOR_JOBS}")
"${CMD[@]}"

exit $?
