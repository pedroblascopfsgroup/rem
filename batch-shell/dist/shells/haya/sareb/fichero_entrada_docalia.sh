#!/bin/bash

DIR_INPUT=/home/ops_haya/etl/output/
DIR_OUTPUT=/sftp_docalia/burofax/envio

ficheros=ENVIO_BUROFAX_
mascara=????????
extension=".txt"
existe_fichero=""

ficherotxt=$DIR_INPUT$ficheros$mascara$extension
ficherosalida=$DIR_OUTPUT

existe_fichero=$(echo $ficherotxt | cut -d'_' -f3)

if [ $existe_fichero == "????????.txt" ]
then
	echo "No existe fichero"
else
	mv $ficherotxt $ficherosalida
	echo "Fichero movido a directorio de envío Docalia"
fi
