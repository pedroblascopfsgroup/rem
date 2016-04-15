#!/bin/bash

ficheros=PCR

if [ -z "$1" ]; then
    echo "$(basename $0) Error: parámetro de entrada YYYYMMDD no definido."
    exit 1
fi

mascara='-'$ENTIDAD'-'$1
extensionZip=".zip"

arrayFicheros=$ficheros

#Calculo de hora limite
hora_limite=`date --date="$MAX_WAITING_MINUTES_FOR_START minutes" +%Y%m%d%H%M%S`
hora_actual=`date +%Y%m%d%H%M%S`
echo "Hora actual: $hora_actual - Hora limite: $hora_limite"

for fichero in $arrayFicheros
do
    ficheroZip=$DIR_INPUT_TR$fichero$mascara$extensionZip
    if [[ "$#" -gt 1 ]] && [[ "$2" -eq "-ftp" ]]; then
        ./ftp/ftp_get_tr_files.sh $1 $fichero
    fi
    while [ "$hora_actual" -lt "$hora_limite" -a ! -e $ficheroZip ]; do
        sleep 900
        hora_actual=`date +%Y%m%d%H%M%S`
        if [[ "$#" -gt 1 ]] && [[ "$2" -eq "-ftp" ]]; then
            ./ftp/ftp_get_tr_files.sh $1 $fichero
        fi
    done
done

if [ "$hora_actual" -ge "$hora_limite" ]
then
    echo "$(basename $0) Error: Tiempo límite alcanzado: ficheros $ficheros no encontrados"
    exit 1
else
    zip -T $ficheroZip
    while [ $? -ne 0 ] ; do
        sleep 5
        zip -T $ficheroZip
    done
    for fichero in $arrayFicheros
    do
        export mascCONTRATOS=CONTRATOS*.txt
        export mascPERSONAS=PERSONAS*.txt
        export mascRELACION=RELACION*.txt
        
        rm -f $DIR_DESTINO$mascCONTRATOS
        rm -f $DIR_DESTINO$mascPERSONAS
        rm -f $DIR_DESTINO$mascRELACION
        
        mv $ficheroZip $DIR_DESTINO
        cd $DIR_DESTINO
        unzip $fichero$mascara$extensionZip "$mascCONTRATOS" "$mascPERSONAS" "$mascRELACION"
    done
    echo "$(basename $0) Ficheros encontrados"
    exit 0
fi
