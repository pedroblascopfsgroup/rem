#!/bin/bash
if [ "$#" -ne 2 ] ; then
    echo "Parametros: <CM01/CM01_pass@host:puerto/ORACLE_SID> <fecha_datos YYYYMMDD>" 
    exit 1
fi

export NLS_LANG=SPANISH_SPAIN.AL32UTF8

echo "[INFO] Se ha establecido la variable de entorno NLS_LANG=SPANISH_SPAIN.AL32UTF8"

echo "[INFO] Cogiendo información correpondiente"
cp ../programas/etl/config/config.ini etls/config/

sh_dir="shells/"

echo "[INFO] INICIO EJECUCION MIGRACION_MIM  $0" `date` 
echo "[INFO] ########################################################"  
echo "[INFO] #####    INICIO CJM_lanza_migracion_MIM.sh"  
echo "[INFO] ########################################################"  

echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_prepara_ficheros_migracion_MIM.sh"           
./"$sh_dir"CJM_prepara_ficheros_migracion.sh 
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_prepara_ficheros_migracion_MIM.sh" 
   echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion_MIM.sh"         
   exit 1 
fi
echo "[OK] ""$sh_dir""CJM_prepara_ficheros_migracion_MIM.sh ejecutado correctamente"

echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_loader_migracion_MIM.sh"
./"$sh_dir"CJM_loader_migracion_MIM.sh "$1" "$2"
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_loader_migracion_MIM.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion_MIM.sh"
    exit 1
fi
echo "[OK] ""$sh_dir""CJM_loader_migracion_MIM.sh ejecutado correctamente"        

echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_backup_ficheros_migracion_MIM.sh"                  
./"$sh_dir"CJM_backup_ficheros_migracion.sh "$2"
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_backup_ficheros_migracion.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1
fi
echo "[OK] ""$sh_dir""CJM_backup_ficheros_migracion_MIM.sh ejecutado correctamente"

echo "[INFO] Comienza ejecución de: ""$sh_dir""HR-2391_Carterizacion_LETRADOS_y_PROCURADORES.sh"                  
./"$sh_dir"HR-2391_Carterizacion_LETRADOS_y_PROCURADORES.sh "$2"
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"HR-2391_Carterizacion_LETRADOS_y_PROCURADORES.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1
fi
echo "[OK] ""$sh_dir""HR-2391_Carterizacion_LETRADOS_y_PROCURADORES.sh ejecutado correctamente"               

  

echo "[INFO] FIN CJM_lanza_migracion_MIM.sh. Revise el fichero de log" `date` 
exit 0
