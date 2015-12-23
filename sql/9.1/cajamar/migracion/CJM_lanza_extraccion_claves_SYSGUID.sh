#!/bin/bash
if [ "$#" -ne 2 ] ; then
    echo "Parametros: <CM01/CM01_pass@host:puerto/ORACLE_SID> <fecha_datos YYYYMMDD>" 
    exit 1
fi

export NLS_LANG=SPANISH_SPAIN.AL32UTF8

echo "[INFO] Se ha establecido la variable de entorno NLS_LANG=SPANISH_SPAIN.AL32UTF8"

sh_dir="shells/"

echo "[INFO] INICIO EXTRACCION SYSGUID  $0" `date` 
echo "[INFO] ########################################################"  
echo "[INFO] #####    INICIO CJM_lanza_extraccion_claves_SYSGUID.sh"  
echo "[INFO] ########################################################"  

echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_extraccion_claves_SYSGUID.sh"           
./"$sh_dir"CJM_extraccion_claves_SYSGUID.sh $1 
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_extraccion_claves_SYSGUID.sh" 
   echo -e "\n\n======>>> [ERROR] en CJM_lanza_extraccion_claves_SYSGUID.sh"         
   exit 1 
fi
echo "[OK] ""$sh_dir""CJM_extraccion_claves_SYSGUID.sh ejecutado correctamente"



echo "[INFO] FIN CJM_lanza_extraccion_claves_SYSGUID.sh Revise el fichero de log" `date` 
exit 0
