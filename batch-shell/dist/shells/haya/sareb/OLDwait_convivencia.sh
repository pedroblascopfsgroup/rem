DIR_INPUT=/data/etl/HRE/recepcion/aprovisionamiento/convivencia/entrada/
MAX_WAITING_MINUTES=1
ficheros=

OIFS=$IFS
IFS=','
arrayFicheros=$ficheros

#Calculo de hora limite
hora_limite=`date --date="$MAX_WAITING_MINUTES minutes" +%Y%m%d%H%M%S`
hora_actual=`date +%Y%m%d%H%M%S`
#echo "Hora actual: $hora_actual - Hora limite: $hora_limite"

for fichero in $arrayFicheros
do
        ficheroZip=$DIR_INPUT$fichero

        echo "$ficheroZip"
	while [ "$hora_actual" -lt "$hora_limite" -a ! -e $ficheroZip ]; do
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
   echo "$(basename $0) Ficheros encontrados"
   exit 0
fi
