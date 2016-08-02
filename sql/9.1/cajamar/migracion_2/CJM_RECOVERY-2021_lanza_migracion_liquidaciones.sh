#!/bin/bash
if [ "$#" -ne 2 ] ; then
    echo "Parametros: <CM01/CM01_pass@host:puerto/ORACLE_SID> <fecha_datos YYYYMMDD> " 
    exit 1
fi

clear

export NLS_LANG=SPANISH_SPAIN.AL32UTF8

echo "[INFO] Se ha establecido la variable de entorno NLS_LANG=SPANISH_SPAIN.AL32UTF8"

sh_dir="shells/"

echo "##########################################################################"  
echo "#####    INICIO CJM_RECOVERY-2021_lanza_migracion_liquidaciones.sh   #####"
echo "##########################################################################"  

# Comprobar CSV
echo ""
echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_RECOVERY-2021_prepara_ficheros_migracion.sh"           
./"$sh_dir"CJM_RECOVERY-2021_prepara_ficheros_migracion.sh 
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_RECOVERY-2021_prepara_ficheros_migracion.sh" 
   echo -e "\n\n======>>> [ERROR] en CJM_RECOVERY-2021_lanza_migracion_liquidaciones.sh"         
   exit 1 
fi
echo "[OK] ""$sh_dir""CJM_RECOVERY-2021_prepara_ficheros_migracion.sh ejecutado correctamente"

# Create MIG_EXPEDIENTES_LIQUIDACIONES
echo ""
echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_RECOVERY-2021_CREATE_MIG_EXPEDIENTES_LIQUIDACIONES.sh"                      
./"$sh_dir"CJM_RECOVERY-2021_CREATE_MIG_EXPEDIENTES_LIQUIDACIONES.sh "$1" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_RECOVERY-2021_CREATE_MIG_EXPEDIENTES_LIQUIDACIONES.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_RECOVERY-2021_lanza_migracion_liquidaciones.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CJM_RECOVERY-2021_CREATE_MIG_EXPEDIENTES_LIQUIDACIONES.sh ejecutado correctamente"  

# Loader
echo ""
echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_RECOVERY-2021_loader_migracion.sh"
./"$sh_dir"CJM_RECOVERY-2021_loader_migracion.sh "$1" "$2"
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_RECOVERY-2021_loader_migracion.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_RECOVERY-2021_lanza_migracion_liquidaciones.sh"
    exit 1
fi
echo "[OK] ""$sh_dir""CJM_RECOVERY-2021_loader_migracion.sh ejecutado correctamente"        

# BackUp
echo ""
echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_RECOVERY-2021_backup_ficheros_migracion.sh"                  
./"$sh_dir"CJM_RECOVERY-2021_backup_ficheros_migracion.sh "$2"
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_RECOVERY-2021_backup_ficheros_migracion.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_RECOVERY-2021_lanza_migracion_liquidaciones.sh"
    exit 1
fi
echo "[OK] ""$sh_dir""CJM_RECOVERY-2021_backup_ficheros_migracion.sh ejecutado correctamente"               

# Volcado de datos 
echo ""
echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_RECOVERY-2021_MIGRACION_LIQUIDACIONES.sh"                      
./"$sh_dir"CJM_RECOVERY-2021_MIGRACION_LIQUIDACIONES.sh "$1" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_RECOVERY-2021_MIGRACION_LIQUIDACIONES.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_RECOVERY-2021_lanza_migracion_liquidaciones.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CJM_RECOVERY-2021_MIGRACION_LIQUIDACIONES.sh ejecutado correctamente"            

# Analyze
#echo ""
#echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_Analiza_cm01.sh"                      
#./"$sh_dir"CJM_Analiza_cm01.sh "$1" 
#if [ $? != 0 ] ; then
#    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_Analiza_cm01.sh"
#    echo -e "\n\n======>>> [ERROR] en CJM_RECOVERY-2021_lanza_migracion_liquidaciones.sh"
#    exit 1           
#fi
#echo "[OK] ""$sh_dir""CJM_Analiza_cm01.sh ejecutado correctamente"        

echo "[INFO] FIN CJM_RECOVERY-2021_lanza_migracion_liquidaciones.sh. Revise el fichero de log" `date` 
exit 0
