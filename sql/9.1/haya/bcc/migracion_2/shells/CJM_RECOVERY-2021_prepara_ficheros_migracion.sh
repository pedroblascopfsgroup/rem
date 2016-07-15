#!/bin/bash

dat_dir="dat"

echo "#################################################################"
echo "#####    INICIO CJM_RECOVERY-2021_prepara_ficheros_migracion.sh"
echo "#################################################################"

echo "[INFO] Directorio DAT: ""$dat_dir"

if [ ! -d $dat_dir ]; then
    echo "[ERROR] No se encuentra el directorio DAT: "$dat_dir
    exit 1
fi

ls $dat_dir/*.csv
if [ $? != 0 ] ; then
   echo -e "[ERROR] No hay ficheros .csv en "$dat_dir
   exit 1
fi

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> Error en CJM_RECOVERY-2021_prepara_ficheros_migracion.sh"
   exit 1
fi

echo "Fin preparación de ficheros de aprovisionamiento de migración."
exit 0
