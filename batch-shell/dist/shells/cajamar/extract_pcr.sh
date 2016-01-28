#!/bin/bash

ficheros=PCR

if [ -z "$1" ]; then
    echo "$(basename $0) Error: parámetro de entrada YYYYMMDD no definido."
    exit 1
fi

mascara='-'$ENTIDAD'-'$1
extensionZip=".zip"

arrayFicheros=$ficheros

for fichero in $arrayFicheros
do
        mascaraZip=$DIR_INPUT_TR$fichero$mascara$extensionZip
        ficheroZip=`ls -Art $mascaraZip | tail -n 1`
        ultFicheroZip=$ficheroZip
done
#echo $ultFicheroZip

export mascCONTRATOS=CONTRATOS*.txt
export mascPERSONAS=PERSONAS*.txt
export mascRELACION=RELACION*.txt

rm $DIR_DESTINO$mascCONTRATOS
rm $DIR_DESTINO$mascPERSONAS
rm $DIR_DESTINO$mascRELACION

if [ -f "$ultFicheroZip" ] ; then
   unzip $ficheroZip "$mascCONTRATOS" "$mascPERSONAS" "$mascRELACION" -d $DIR_DESTINO
   exit 0
else 
   exit 1
fi

