#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <Fichero log del proceso de reubicación de ficheros>"
    exit
fi
ruta="CTLs_DATs/DATs/"
ruta_old="Ficheros_entrada/"

echo "SE INICIA EL PROCESO DE RENOMBRADO DE LOS FICHEROS"
echo "Descomprimiendo ficheros"

rm -f $ruta/*.dat

unzip -o "$ruta_old"*_FaseI_*.zip >> $1
unzip -o "$ruta_old"*_FaseII_*.zip >> $1

cat Fich_Trabajo1.dat > Fich_Trabajo.dat
cat Fich_Trabajo2.dat >> Fich_Trabajo.dat

rm -rf Fich_Trabajo1.dat
rm -rf Fich_Trabajo2.dat

cp "$ruta_old"Updates_migracion_Cajamar_v02.csv .

while read line
do
	fichero_old=`echo "$line" | cut -d ";" -f 1`
	fichero_new=`echo "$line" | cut -d ";" -f 2`
	
	if [ -s "$fichero_old" ] ; then
		mv -f "$fichero_old" "$ruta""$fichero_new"
	else
		echo [ WARNING ] "$fichero_old" no encontrado o vacío
	fi

done < "$ruta_old""renombrado.list"

rm -f *.dat
rm -f *.csv

echo "Nombres cambiados, verificar cambios"
exit 0
