#!/bin/bash
if [ "$#" -ne 2 ] ; then
    echo "Parametros: <CM01/CM01_pass@host:puerto/ORACLE_SID> <fecha_datos YYYYMMDD> " 
    echo "  <entorno>: desa, pre, pro"
    exit 1
fi

export NLS_LANG=SPANISH_SPAIN.AL32UTF8

echo "[INFO] Se ha establecido la variable de entorno NLS_LANG=SPANISH_SPAIN.AL32UTF8"

echo "[INFO] Cogiendo información del entorno correspondiente"
cd /recovery/batch-server/migracion
#cp etls/config/$3/config.ini etls/config/

sh_dir="shells/"

echo "[INFO] INICIO EJECUCION MIGRACION CCO $0" `date` 
echo "[INFO] ########################################################"  
echo "[INFO] #####    INICIO CJM_lanza_migracion_CCO.sh"  
echo "[INFO] ########################################################"  

#echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_prepara_ficheros_migracion.sh"           
#./"$sh_dir"CJM_prepara_ficheros_migracion.sh 
#if [ $? != 0 ] ; then 
#   echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_prepara_ficheros_migracion.sh" 
#   echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion_CCO.sh"         
#   exit 1 
#fi
#echo "[OK] ""$sh_dir""CJM_prepara_ficheros_migracion.sh ejecutado correctamente"

#####################################
### BLOQUE PRODUCTO-1806 HRE. CAJAMAR. Contencioso. Contabilidad de cobros. Cargar fichero histórico
#####################################

echo "[INFO] Comienza ejecución de: ""$sh_dir""DDL_001_ENTITY01_PRODUCTO_1806_crea_tabla_MIG_CCO.sh"                      
./"$sh_dir"DDL_001_ENTITY01_PRODUCTO_1806_crea_tabla_MIG_CCO.sh "$1" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"DDL_001_ENTITY01_PRODUCTO_1806_crea_tabla_MIG_CCO.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion_CCO.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""DDL_001_ENTITY01_PRODUCTO_1806_crea_tabla_MIG_CCO.sh ejecutado correctamente"   

echo "[INFO] Comienza ejecución de: ""$sh_dir""DML_001_ENTITY01_PRODUCTO_1806_insert_MIG_CCO.sh"                      
./"$sh_dir"DML_001_ENTITY01_PRODUCTO_1806_insert_MIG_CCO.sh "$1" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"DML_001_ENTITY01_PRODUCTO_1806_insert_MIG_CCO.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion_CCO.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""DML_001_ENTITY01_PRODUCTO_1806_insert_MIG_CCO.sh ejecutado correctamente"   

echo "[INFO] Comienza ejecución de: ""$sh_dir""DML_002_ENTITY01_PRODUCTO_1806_insert_CCO.sh"                      
./"$sh_dir"DML_002_ENTITY01_PRODUCTO_1806_insert_CCO.sh "$1" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"DML_002_ENTITY01_PRODUCTO_1806_insert_CCO.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion_CCO.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""DML_002_ENTITY01_PRODUCTO_1806_insert_CCO.sh ejecutado correctamente"   

echo "[INFO] Comienza ejecución de: ""$sh_dir""DML_003_ENTITY01_PRODUCTO_1806_informe_CCO.sh"                      
./"$sh_dir"DML_003_ENTITY01_PRODUCTO_1806_informe_CCO.sh "$1" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"DML_003_ENTITY01_PRODUCTO_1806_informe_CCO.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion_CCO.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""DML_003_ENTITY01_PRODUCTO_1806_informe_CCO.sh ejecutado correctamente"   
  

echo "[INFO] FIN CJM_lanza_migracion_CCO.sh. Revise el fichero de log" `date` 
exit 0
