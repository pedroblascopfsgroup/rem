#!/bin/bash
if [ "$#" -ne 2 ] ; then
    echo "Parametros: <CM01/CM01_pass@host:puerto/ORACLE_SID> <fecha_datos YYYYMMDD>" 
    exit 1
fi

export NLS_LANG=SPANISH_SPAIN.AL32UTF8

echo "[INFO] Se ha establecido la variable de entorno NLS_LANG=SPANISH_SPAIN.AL32UTF8"

echo "[INFO] Creamos el soft link al ETL apr_main_observaciones.sh"

if [ -f  ./shells/apr_main_observaciones.sh ] ;  then 
  echo "El link a ../shells/apr_main_observaciones.sh ya existe" 
else
  ln -s ../../shells/apr_main_observaciones.sh ./shells/apr_main_observaciones.sh
  echo "Link a ../../shells/apr_main_observaciones.sh creado correctamente"
fi

sh_dir="shells/"

echo "[INFO] INICIO EJECUCION MIGRACION  $0" `date` 
echo "[INFO] ########################################################"  
echo "[INFO] #####    INICIO CJM_lanza_migracion.sh"  
echo "[INFO] ########################################################"  

echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_prepara_ficheros_migracion.sh"           
./"$sh_dir"CJM_prepara_ficheros_migracion.sh 
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_prepara_ficheros_migracion.sh" 
   echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"         
   exit 1 
fi
echo "[OK] ""$sh_dir""CJM_prepara_ficheros_migracion.sh ejecutado correctamente"

echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_loader_migracion.sh"
./"$sh_dir"CJM_loader_migracion.sh "$1" "$2"
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_loader_migracion.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1
fi
echo "[OK] ""$sh_dir""CJM_loader_migracion.sh ejecutado correctamente"        

echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_backup_ficheros_migracion.sh"                  
./"$sh_dir"CJM_backup_ficheros_migracion.sh "$2"
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_backup_ficheros_migracion.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1
fi
echo "[OK] ""$sh_dir""CJM_backup_ficheros_migracion.sh ejecutado correctamente"               

echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_migracion_a_tabla_intermedia.sh"                      
./"$sh_dir"CJM_migracion_a_tabla_intermedia.sh "$1" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_migracion_a_tabla_intermedia.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CJM_migracion_a_tabla_intermedia.sh ejecutado correctamente"            

echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_script_borrado.sh"                      
./"$sh_dir"CJM_script_borrado.sh "$1"          
if [ $? != 0 ] ; then 
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_script_borrado.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1
fi
echo "[OK] ""$sh_dir""CJM_script_borrado.sh ejecutado correctamente"            

echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_migracion_a_recovery.sh"                               
./"$sh_dir"CJM_migracion_a_recovery.sh "$1"   
if [ $? != 0 ] ; then 
  echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_migracion_a_recovery.sh"
  echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"          
  exit 1
fi
echo "[OK] ""$sh_dir""CJM_migracion_a_recovery.sh ejecutado correctamente"        

echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_migracion_anotaciones.sh"                      
./"$sh_dir"CJM_migracion_anotaciones.sh "$1"   
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_migracion_anotaciones.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CJM_migracion_anotaciones.sh ejecutado correctamente"  

echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_usuarios_procuradores.sh"                               
./"$sh_dir"CJM_usuarios_procuradores.sh "$1"   
if [ $? != 0 ] ; then 
  echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_usuarios_procuradores.sh"
  echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"          
  exit 1
fi
echo "[OK] ""$sh_dir""CJM_usuarios_procuradores.sh ejecutado correctamente" 


echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_migracion_caracteriza_validadores.sh"                               
./"$sh_dir"CJM_migracion_caracteriza_validadores.sh "$1"   
if [ $? != 0 ] ; then 
  echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_migracion_caracteriza_validadores.sh"
  echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"          
  exit 1
fi
echo "[OK] ""$sh_dir""CJM_migracion_caracteriza_validadores.sh ejecutado correctamente" 



echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_instancia_BPMs_concursal.sh"                               
./"$sh_dir"CJM_instancia_BPMs_concursal.sh "$1"   
if [ $? != 0 ] ; then 
  echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_instancia_BPMs_concursal.sh"
  echo -e "\n\n======>>> [ERROR] en CJM_instancia_BPMs_concursal.sh"          
  exit 1
fi
echo "[OK] ""$sh_dir""CJM_instancia_BPMs_concursal.sh ejecutado correctamente"        


echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_migracion_volumetria_carga.sh"                      
./"$sh_dir"CJM_migracion_volumetria_carga.sh "$1" "$2" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_migracion_volumetria_carga.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CJM_migracion_volumetria_carga.sh ejecutado correctamente"      


echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_migracion_a_recovery_precontencioso.sh"                      
./"$sh_dir"CJM_migracion_a_recovery_precontencioso.sh "$1" "$2" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_migracion_a_recovery_precontencioso.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CJM_migracion_a_recovery_precontencioso.sh ejecutado correctamente"      

echo "[INFO] Comienza ejecución de: ""$sh_dir""apr_main_observaciones.sh"                      
./"$sh_dir"apr_main_observaciones.sh 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"apr_main_observaciones.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""apr_main_observaciones.sh ejecutado correctamente"   


#####################################
### BLOQUE Correccion incidencias
#####################################

echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC_1505_migracion_paraliza_procedimientos_precontencioso.sh"                      
./"$sh_dir"CMREC_1505_migracion_paraliza_procedimientos_precontencioso.sh 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CMREC_1505_migracion_paraliza_procedimientos_precontencioso.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CMREC_1505_migracion_paraliza_procedimientos_precontencioso.sh ejecutado correctamente"   


echo "[INFO] FIN CJM_lanza_migracion.sh. Revise el fichero de log" `date` 
exit 0
