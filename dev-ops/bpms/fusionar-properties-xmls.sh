#!/bin/bash

#Este shell requiere un ficheros de entrada:
# * fichero fusionado servirá para corregir los xmls que tengan -1 en la versión de los BPMs
#Buscará los ficheros xml y sustituirá el -1 por el número de versión que venga en el fichero fusionado

if [[ "$#" != "1" ]]; then
	echo -e "\nUso: $0 <fichero-fusionado>\n"
	exit 1
fi

F_PROPS=$1
if [[ ! -f $F_PROPS ]]; then
	echo -e "\nEl fichero '$F_PROPS' no existe\n"
	exit 1
fi

for linea in `cat $F_PROPS` ; do
	fichero=`echo $linea | cut -d':' -f 1`
	nombre=`echo $linea | cut -d':' -f 2`
	version=`echo $linea | cut -d':' -f 3`
	if [[ "$version" != "" ]] ; then
		sed -e "s/\/${nombre}\" p:version=\".*\"/\/${nombre}\" p:version=\"${version}\"/g" -i $fichero
		echo "-- Actualizada versión $version del trámite $nombre en $fichero."
	else
		echo "** Versión del trámite $nombre en $fichero no se modifica porque está vacía"
	fi
done

echo "Fin: Procesado el fichero $F_PROPS"

