#!/bin/bash
##Comprobamos que el número de parámetros en correcto.
if [ "$#" -ne 1 ]; then
    echo "Parametros incorrectos: <Fichero log del proceso de reubicación de ficheros>"
    exit
fi

##Rutas de origen y destino de los ficheros.
ruta="CTLs_DATs/DATs/"
ruta_old="FICHEROS/"
rm -f $ruta/*.dat

##Se descomprimen los ficheros en la misma carpeta del .zip
echo "[INICIO] Comienza el proceso"
echo "--------------------------------------------------------------------"
echo "[INFO] Descomprimiendo los .zip de ficheros..."

zips=0
for zipfile in "$ruta_old"*.zip
do  
    if [[ -s "$zipfile" ]] ; then
	  zips=zips+1
	  echo "Descomprimiendo el archivo: $zipfile"
	  unzip -o "$zipfile" >> $1
	else
	  echo "Archivo no existe o está vacío."
	fi
done
if [ $zips = 0 ] ; then
	exit 1
fi

ficherosDescomprimidos=`find *.dat -maxdepth 1 | wc -l`
echo "Ficheros descomprimidos:$ficherosDescomprimidos"
if [ $ficherosDescomprimidos = 0 ] ; then
	exit 1
fi

#unzip -o "$ruta_old"*_FaseI_*.zip >> $1
#unzip -o "$ruta_old"*_FaseII_*.zip >> $1

##[TRABAJOS] Se juntan los 2 ficheros de Trabajos en 1 solo fichero.
#echo "[INFO] Juntando los ficheros de trabajos en 1 solo fichero..."
#cat Fich_Trabajo1.dat > Fich_Trabajo.dat
#cat Fich_Trabajo2.dat >> Fich_Trabajo.dat
#rm -rf Fich_Trabajo1.dat
#rm -rf Fich_Trabajo2.dat

##Se borran los ficheros que hubiera en "CTLs_DATs/DATs/*.dat"
echo "[INFO] Se borran los ficheros .dat antiguos..."
rm -f $ruta/*.dat

##Se reubican los ficheros 
echo "[INFO] Reubicando los ficheros según el fichero [renombrado.list]..."
while read line
do
	fichero_old=`echo "$line" | cut -d ";" -f 1`
	fichero_new=`echo "$line" | cut -d ";" -f 2`
	
	if [ -s $fichero_old ] ; then
		mv -f $fichero_old "$ruta""$fichero_new"
		echo "	[INFO] Se reubica el fichero " $fichero_old "-->" $ruta$fichero_new
	else
		echo "	[WARNING]" $fichero_old " no encontrado o vacío"
	fi
done < "$ruta_old""renombrado.list"

##
echo "[INFO] Borrando los ficheros de la ruta de origen"
rm -f *.dat
rm -f *.csv

##[FIN] Fin del proceso
echo "[FIN] Acaba el proceso correctamente."
exit 0
