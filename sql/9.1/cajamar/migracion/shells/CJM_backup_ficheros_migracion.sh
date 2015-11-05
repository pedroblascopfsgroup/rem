#!/bin/bash
if [ "$#" -ne 1 ] ; then
    echo "Parametros: <fecha_datos YYYYMMDD>" 
    exit 1
fi

echo "Comienzo del backup"

fecha="$1"
dat_dir="DAT/"
bck_dir="dat_backup/"

echo "Directorio backup: ""$bck_dir""$fecha"

if [ -d "$bck_dir""$fecha" ]; then 
    cp "$dat_dir"*.zip "$bck_dir""$fecha"
else 
    echo "creando directorio ""$bck_dir""$fecha"      
    mkdir "$bck_dir""$fecha";
    cp "$dat_dir"*.zip "$bck_dir""$fecha";
fi 

#Borramos los .zip y .dat si se han copiado los .zip correctamente en el dir de backup.
if [ $? != 0 ] ; then 
   echo "Fallo en la copia de ficheros a backup";
   exit 1;
else 
   rm "$dat_dir"*.zip
   rm "$dat_dir"*.dat   
fi

if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> Error en CJM_backup_ficheros_migracion.sh" ; 
   exit 1; 
fi

echo "Fin backup de ficheros de aprovisionamiento de migración."

exit


