#!/bin/bash

DIR_OUTPUT=/sftp_docalia/burofax/envio

ficheros=ENVIO_BUROFAX_
mascara=????????
extension=".txt"
existe_fichero=""

ficherotxt=$DIR_CONTROL_OUTPUT/$ficheros$mascara$extension
ficherosalida=$DIR_OUTPUT

existe_fichero=$(echo $ficherotxt | cut -d'_' -f3)

if [ $existe_fichero == "????????.txt" ]
then
	echo "No existe fichero"
else
	mv $ficherotxt $ficherosalida
	echo "Fichero movido a directorio de envío Docalia"
fi
