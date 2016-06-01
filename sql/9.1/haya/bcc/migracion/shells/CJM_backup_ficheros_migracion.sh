#!/bin/bash
if [ "$#" -ne 1 ] ; then
    echo "Parametros: <fecha_datos YYYYMMDD>" 
    exit 1
fi

echo "Comienzo del backup"

fecha="$1"
dat_dir="dat/"
bck_dir="../../../transferencia/bcc/aprov_migracion/dat_backup/"
aprov_dir="../../../transferencia/bcc/aprov_migracion/"

echo "Directorio backup: ""$bck_dir"

if [ -d "$bck_dir" ]; then 
    cp "$aprov_dir"*.zip "$bck_dir"
else 
    echo "creando directorio ""$bck_dir"
    mkdir "$bck_dir"
    cp "$aprov_dir"*.zip "$bck_dir"
fi 

#Borramos los .dat si se han copiado los .dat correctamente en el dir de backup.
if [ $? != 0 ] ; then 
   echo "Fallo en la copia de ficheros a backup"
   exit 1
fi

rm "$dat_dir"*.dat   
rm "$aprov_dir"*.zip      

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> Error en CJM_backup_ficheros_migracion.sh"
   exit 1
fi

echo "Fin backup de ficheros de aprovisionamiento de migración."
exit 0
