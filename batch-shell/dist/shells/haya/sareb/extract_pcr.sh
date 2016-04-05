#!/bin/bash
# Generado manualmente por PBO
 
ENTIDAD=5074
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
        mascaraZip=$DIR_INPUT_TR$fichero$mascara$extensionZip
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

rm $DIR_DESTINO/$mascCONTRATOS
rm $DIR_DESTINO/$mascPERSONAS
rm $DIR_DESTINO/$mascRELACION


if [ -f "$ficheroZip" ] ; then
   unzip $ficheroZip "$mascCONTRATOS" "$mascPERSONAS" "$mascRELACION" -d $DIR_DESTINO
   exit 0
else 
   exit 1
fi
