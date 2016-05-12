#!/bin/bash

DIR_INPUT=/sftp_docalia/burofax/entrega/

fichero_entrada=ENVIO_BUROFAX_
fichero_salida=RECEP_BUROFAX_
mascara_fichero=?????_
fichero_burofax=BUROFAX_
existe_fichero=""
barra=_
mascara_in=????????
extension=".txt"

fn_in=$(basename $mascara_fichero$fichero_burofax$mascara_in$extension)
existe_fichero=$(echo $fn_in | cut -d'_' -f 3)
tipofichero=$(echo $fn_in | cut -d'_' -f 1,2)$barra

fn=$(basename $fichero_entrada$mascara_in$extension)
substr=$(echo $fn | cut -d'_' -f 3)

ficherotxt=$DIR_INPUT$fichero_entrada$mascara_in$extension
ficherosalida=$DIR_DESTINO/$fichero_salida$substr
fichero=$DIR_INPUT$fichero_salida$mascara_in$extension

if [ $existe_fichero == "????????.txt" ]
then
	echo "No existe fichero de entrada"
elif [ $tipofichero == $fichero_salida ]
then
	mv -f $fichero $ficherosalida
	echo "Fichero RECEP_BUROFAX movido a directorio de destino"
else
	mv -f $ficherotxt $ficherosalida
	echo "Fichero ENVIO_BUROFAX movido a directorio de destino como RECEP_BUROFAX"
fi
