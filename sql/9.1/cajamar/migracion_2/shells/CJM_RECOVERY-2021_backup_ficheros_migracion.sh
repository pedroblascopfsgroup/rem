#!/bin/bash
if [ "$#" -ne 1 ] ; then
    echo "Parametros: <fecha_datos YYYYMMDD>" 
    exit 1
fi

echo "#################################################################"
echo "#####    INICIO CJM_RECOVERY-2021_backup_ficheros_migracion.sh"
echo "#################################################################"

echo "[INFO] Comienzo del backup"

fecha="$1"
dat_dir="dat/"
bck_dir="dat_backup"

echo "Directorio backup: ""$bck_dir"

if [ -d "$bck_dir" ]; then 
    cp "$dat_dir"*.csv "$bck_dir"
else 
    echo "creando directorio ""$bck_dir"
    mkdir "$bck_dir"
    cp "$dat_dir"*.csv "$bck_dir"
fi 

#Borramos los .dat si se han copiado los .dat correctamente en el dir de backup.
if [ $? != 0 ] ; then 
   echo "Fallo en la copia de ficheros a backup"
   exit 1
fi

rm "$dat_dir"*.csv       

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> Error en CJM_RECOVERY-2021_backup_ficheros_migracion.sh"
   exit 1
fi

echo "Fin backup de ficheros de aprovisionamiento de migración."
exit 0
