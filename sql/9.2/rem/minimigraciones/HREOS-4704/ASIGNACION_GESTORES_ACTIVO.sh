#!/bin/bash
if [ "$#" -ne 2 ] ; then
    echo "Parametros:  <REM01/REM01_pass@host:puerto/ORACLE_SID>  <fecha_datos YYYYMMDD>  " 
    echo "  <entorno>: desa, pre, pro"
    exit 1
fi

export NLS_LANG=SPANISH_SPAIN.AL32UTF8

echo "[INFO] Se ha establecido la variable de entorno NLS_LANG=SPANISH_SPAIN.AL32UTF8"

sh_dir="shells/"

echo "[INFO] INICIO EJECUCION ASIGNACION_GESTORES_ACTIVO $0" `date` 
echo "[INFO] ########################################################"  
echo "[INFO] #####    INICIO ASIGNACION_GESTORES_ACTIVO.sh"  
echo "[INFO] ########################################################"  


#LANZAR 
echo "[INFO] Comienza ejecución de: ""$sh_dir""ASIGNACION_GESTORES_ACTIVO.sh"
./"$sh_dir"ASIGNACION_GESTORES_ACTIVO.sh "$1" "$2"
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en ""$sh_dir""ASIGNACION_GESTORES_ACTIVO.sh"
    exit 1
fi
echo "[OK] ""$sh_dir""ASIGNACION_GESTORES_ACTIVO.sh ejecutado correctamente"        


echo "[INFO] FIN UPDATE_MASIVO_FECHAS.sh. Revise el fichero de log" `date` 
exit 0
