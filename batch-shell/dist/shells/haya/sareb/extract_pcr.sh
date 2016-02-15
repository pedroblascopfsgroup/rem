#!/bin/bash
# Generado manualmente por PBO
 
ENTIDAD=2038

DIR_INPUT=/data/etl/HRE/recepcion/aprovisionamiento/troncal/
export DIR_TXT=/home/ops-haya/etl/input/

MAX_WAITING_MINUTES=720
ficheros=PCR

#echo $(basename $0)

mascara='-'$ENTIDAD'-'????????
extensionZip=".zip"

arrayFicheros=$ficheros

#Calculo de hora limite
hora_limite=`date --date="$MAX_WAITING_MINUTES minutes" +%Y%m%d%H%M%S`
hora_actual=`date +%Y%m%d%H%M%S`
#echo "Hora actual: $hora_actual - Hora limite: $hora_limite"


for fichero in $arrayFicheros
do
        mascaraZip=$DIR_INPUT$fichero$mascara$extensionZip
        ficheroZip=`ls -Art $mascaraZip | tail -n 1` 
        #ultFicheroZip=$ficheroZip

	while [ "$hora_actual" -lt "$hora_limite" -a ! -e $ficheroZip -a ]; do
	   sleep 300
	   hora_actual=`date +%Y%m%d%H%M%S`
	   #echo "$hora_actual"
	   ficheroZip=`ls -Art $mascaraZip | tail -n 1`
	done

done
#echo $ultFicheroZip

export mascCONTRATOS=CONTRATOS*.txt
export mascPERSONAS=PERSONAS*.txt
export mascRELACION=RELACION*.txt

rm $DIR_TXT$mascCONTRATOS
rm $DIR_TXT$mascPERSONAS
rm $DIR_TXT$mascRELACION


if [ -f "$ficheroZip" ] ; then
   unzip $ficheroZip "$mascCONTRATOS" "$mascPERSONAS" "$mascRELACION" -d $DIR_TXT
   exit 0
else 
   exit 1
fi
