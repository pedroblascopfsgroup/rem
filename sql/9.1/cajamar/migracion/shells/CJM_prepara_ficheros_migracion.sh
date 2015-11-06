#!/bin/bash

dat_dir="dat/"

echo "Directorio DAT: ""$dat_dir"

rm "$dat_dir"*.dat

for ZIP in `ls "$dat_dir" | grep .zip` 
do echo  $dat_dir$ZIP
   unzip -d $dat_dir $dat_dir$ZIP;
done   

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> Error en CJM_prepara_ficheros_migracion.sh" ; 
   exit 1; 
fi

echo "Fin preparación de ficheros de aprovisionamiento de migración."

exit

