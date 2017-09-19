#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <Fichero log del proceso de reubicación de ficheros>"
    exit
fi
ruta="CTLs_DATs/DATs/"
ruta_old="Ficheros_entrada/"

echo "SE INICIA EL PROCESO DE RENOMBRADO DE LOS FICHEROS"
echo "Descomprimiendo ficheros"

unzip -o "$ruta_old"*_FaseI_*.zip >> $1
unzip -o "$ruta_old"*_FaseII_*.zip >> $1

cat Fich_Trabajo1.dat > Fich_Trabajo.dat
cat Fich_Trabajo2.dat >> Fich_Trabajo.dat

rm -rf Fich_Trabajo1.dat
rm -rf Fich_Trabajo2.dat

fichero_update=Updates_migracion_Cajamar_*.csv
if [ -s $ruta_old$fichero_update ] ; then
	echo $ruta_old$fichero_update
	cp $ruta_old$fichero_update .
fi

echo "Borrado de ficheros antiguos"

rm -f $ruta/*.dat

echo "Se inicia el movimiento a destino de los ficheros"

while read line
do
	fichero_old=`echo "$line" | cut -d ";" -f 1`
	echo $fichero_old
	fichero_new=`echo "$line" | cut -d ";" -f 2`
	echo $fichero_new

	if [ -s $fichero_old ] ; then
		mv -f $fichero_old "$ruta""$fichero_new"
		echo $fichero_old "-->" $ruta$fichero_new
	else
		echo [ WARNING ] $fichero_old no encontrado o vacío
	fi

done < "$ruta_old""renombrado.list"

echo "Borrando ficheros renombrados"

rm -f *.dat
rm -f *.csv

echo "Nombres cambiados, verificar cambios"
exit 0
