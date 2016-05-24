#!/bin/bash

dat_dir="dat"
dat_aprov_dir="../../../transferencia/bcc/aprov_migracion"

echo "[INFO] Directorio DAT: ""$dat_dir"
echo "[INFO] Directorio DAT Aprov: ""$dat_aprov_dir"

rm -f $dat_dir/*.dat

if [ ! -d $dat_aprov_dir ]; then
    echo "[ERROR] No se encuentra el directorio DAT Aprov: "$dat_aprov_dir
    exit 1
fi

ls $dat_aprov_dir/*.zip
if [ $? != 0 ] ; then
   echo -e "[ERROR] No hay ficheros .zip en "$dat_aprov_dir
   exit 1
fi

for ZIP in `ls $dat_aprov_dir/*.zip` 
do 
    echo $dat_aprov_dir/$ZIP
    unzip -d $dat_dir $dat_aprov_dir/$ZIP
done   

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> Error en CJM_prepara_ficheros_migracion.sh"
   exit 1
fi

echo "Fin preparación de ficheros de aprovisionamiento de migración."
exit 0
