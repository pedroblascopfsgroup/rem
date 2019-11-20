
ENTIDAD=2077
MAX_WAITING_MINUTES=1
DIR_INPUT=../../dist/shells/
ficheros="PCR,GRUPOS,GRUPOS_PERSONAS"

mascara='_'$ENTIDAD'_'`date +%Y%m%d`
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
	ficheroSem=$DIR_INPUT$fichero$mascara$extensionSem
	ficheroZip=$DIR_INPUT$fichero$mascara$extensionZip
    #echo "$ficheroSem"
	while [ "$hora_actual" -lt "$hora_limite" -a ! -e $ficheroSem -a ! -e $ficheroZip ]; do
	   sleep 10
	   hora_actual=`date +%Y%m%d%H%M%S`
	   #echo "$hora_actual"
	done
done

if [ "$hora_actual" -ge "$hora_limite" ]
then
   echo "Tiempo límite alcanzado: ficheros $ficheros no encontrados"
   exit 1
else
   echo "Ficheros encontrados"
   exit 0
fi


