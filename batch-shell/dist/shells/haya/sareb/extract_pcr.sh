#!/bin/bash
# Generado manualmente por PBO
 
ENTIDAD=2038

DIR_INPUT=/data/etl/HRE/recepcion/aprovisionamiento/troncal/
export DIR_TXT=/home/ops-haya/etl/input/

MAX_WAITING_MINUTES=10
ficheros=PCR

#echo $(basename $0)

mascara='-'$ENTIDAD'-'????????
extensionZip=".zip"

arrayFicheros=$ficheros

for fichero in $arrayFicheros
do
        mascaraZip=$DIR_INPUT$fichero$mascara$extensionZip
        ficheroZip=`ls -Art $mascaraZip | tail -n 1`
        ultFicheroZip=$ficheroZip
done
#echo $ultFicheroZip

export mascCONTRATOS=CONTRATOS*.txt
export mascPERSONAS=PERSONAS*.txt
export mascRELACION=RELACION*.txt

rm $DIR_TXT$mascCONTRATOS
rm $DIR_TXT$mascPERSONAS
rm $DIR_TXT$mascRELACION


if [ -f "$ultFicheroZip" ] ; then
   unzip $ficheroZip "$mascCONTRATOS" "$mascPERSONAS" "$mascRELACION" -d $DIR_TXT
   exit 0
else 
   exit 1
fi
