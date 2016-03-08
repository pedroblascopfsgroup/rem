#!/bin/bash
if [ "$#" -ne 3 ] ; then
    echo "Parametros: <CM01/CM01_pass@host:puerto/ORACLE_SID> <fecha_datos YYYYMMDD> <entorno>" 
    echo "  <entorno>: desa, pre, pro"
    exit 1
fi

export NLS_LANG=SPANISH_SPAIN.AL32UTF8

echo "[INFO] Se ha establecido la variable de entorno NLS_LANG=SPANISH_SPAIN.AL32UTF8"

echo "[INFO] Cogiendo información del entorno correpondiente"
cp etls/config/$3/config.ini etls/config/

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

echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_Analiza_cm01.sh"                      
./"$sh_dir"CJM_Analiza_cm01.sh "$1" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_Analiza_cm01.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CJM_Analiza_cm01.sh ejecutado correctamente"            

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

#COMENTADA POR OBSOLETA#
#echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_migracion_caracteriza_validadores.sh"                               
#./"$sh_dir"CJM_migracion_caracteriza_validadores.sh "$1"   
#if [ $? != 0 ] ; then 
#  echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_migracion_caracteriza_validadores.sh"
#  echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"          
#  exit 1
#fi
#echo "[OK] ""$sh_dir""CJM_migracion_caracteriza_validadores.sh ejecutado correctamente" 



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


echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_migracion_contratos_HRE_resto.sh"                      
./"$sh_dir"CJM_migracion_contratos_HRE_resto.sh "$1"
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_migracion_contratos_HRE_resto.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CJM_migracion_contratos_HRE_resto.sh ejecutado correctamente"     



#####################################
### BLOQUE Correccion incidencias y Cambios
#####################################

#COMENTADA POR OBSOLETA#
#echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC_1449_ARREGLA_LETRADOS_y_PROCURADORES.sh"                      
#./"$sh_dir"CMREC_1449_ARREGLA_LETRADOS_y_PROCURADORES.sh "$1"
#if [ $? != 0 ] ; then
#    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CMREC_1449_ARREGLA_LETRADOS_y_PROCURADORES.sh"
#    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
#    exit 1           
#fi
#echo "[OK] ""$sh_dir""CMREC_1449_ARREGLA_LETRADOS_y_PROCURADORES.sh ejecutado correctamente"   


echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC_1505_migracion_paraliza_procedimientos_precontencioso.sh"                      
./"$sh_dir"CMREC_1505_migracion_paraliza_procedimientos_precontencioso.sh "$1"
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CMREC_1505_migracion_paraliza_procedimientos_precontencioso.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CMREC_1505_migracion_paraliza_procedimientos_precontencioso.sh ejecutado correctamente"   


#COMENTADA POR OBSOLETA#
#echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC_1645_Asignacion_Gestores_PREContencioso.sh"                      
#./"$sh_dir"CMREC_1645_Asignacion_Gestores_PREContencioso.sh "$1" 
#if [ $? != 0 ] ; then
#    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CMREC_1645_Asignacion_Gestores_PREContencioso.sh"
#    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
#    exit 1           
#fi
#echo "[OK] ""$sh_dir""CMREC_1645_Asignacion_Gestores_PREContencioso.sh ejecutado correctamente"   


echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC_1728_Situacion_cliente_Asunto.sh"                      
./"$sh_dir"CMREC_1728_Situacion_cliente_Asunto.sh "$1" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CMREC_1728_Situacion_cliente_Asunto.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CMREC_1728_Situacion_cliente_Asunto.sh ejecutado correctamente"   

echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC_1460_Modifica_Nombre_Asunto.sh"                      
./"$sh_dir"CMREC_1460_Modifica_Nombre_Asunto.sh "$1" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CMREC_1460_Modifica_Nombre_Asunto.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CMREC_1460_Modifica_Nombre_Asunto.sh ejecutado correctamente"   

echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC_1671_Gestion_asunto_por_marca_haya.sh"                      
./"$sh_dir"CMREC_1671_Gestion_asunto_por_marca_haya.sh "$1" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CMREC_1671_Gestion_asunto_por_marca_haya.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CMREC_1671_Gestion_asunto_por_marca_haya.sh ejecutado correctamente"   


echo "[INFO] Comienza ejecución de: ""$sh_dir""apr_main_observaciones.sh"                      
./"$sh_dir"apr_main_observaciones.sh 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"apr_main_observaciones.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""apr_main_observaciones.sh ejecutado correctamente"     


echo "[INFO] Comienza ejecución de: ""$sh_dir""apr_main_obs_expediente.sh"                      
./"$sh_dir"apr_main_obs_expediente.sh 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"apr_main_obs_expediente.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""apr_main_obs_expediente.sh ejecutado correctamente"      


echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC-1797_carterizacion_CAJAMAR_postmigracion.sh"                               
./"$sh_dir"CMREC-1797_carterizacion_CAJAMAR_postmigracion.sh "$1"   
if [ $? != 0 ] ; then 
  echo -e "\n\n======>>> [ERROR] en "$sh_dir"CMREC-1797_carterizacion_CAJAMAR_postmigracion.sh"
  echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"          
  exit 1
fi
echo "[OK] ""$sh_dir""CMREC-1797_carterizacion_CAJAMAR_postmigracion.sh ejecutado correctamente" 


echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC-1797_Carga_DD_Letrados_procuradores.sh"                               
./"$sh_dir"CMREC-1797_Carga_DD_Letrados_procuradores.sh "$1"   
if [ $? != 0 ] ; then 
  echo -e "\n\n======>>> [ERROR] en "$sh_dir"CMREC-1797_Carga_DD_Letrados_procuradores.sh"
  echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"          
  exit 1
fi
echo "[OK] ""$sh_dir""CMREC-1797_Carga_DD_Letrados_procuradores.sh ejecutado correctamente" 


echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC-1797_Carterizacion_LETRADOS_y_PROCURADORES.sh"                               
./"$sh_dir"CMREC-1797_Carterizacion_LETRADOS_y_PROCURADORES.sh "$1"   
if [ $? != 0 ] ; then 
  echo -e "\n\n======>>> [ERROR] en "$sh_dir"CMREC-1797_Carterizacion_LETRADOS_y_PROCURADORES.sh"
  echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"          
  exit 1
fi
echo "[OK] ""$sh_dir""CMREC-1797_Carterizacion_LETRADOS_y_PROCURADORES.sh ejecutado correctamente" 


echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC_1811_Carga_liquidaciones_precontencioso.sh"                               
./"$sh_dir"CMREC_1811_Carga_liquidaciones_precontencioso.sh "$1"   
if [ $? != 0 ] ; then 
  echo -e "\n\n======>>> [ERROR] en "$sh_dir"CMREC_1811_Carga_liquidaciones_precontencioso.sh"
  echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"          
  exit 1
fi
echo "[OK] ""$sh_dir""CMREC_1811_Carga_liquidaciones_precontencioso.sh ejecutado correctamente" 

#PENDIENTE DE CORRECCION
#echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC_1510_MIGRACION_PROPUESTAS_FONDOS_PROPIOS.sh"                               
#./"$sh_dir"CMREC_1510_MIGRACION_PROPUESTAS_FONDOS_PROPIOS.sh "$1"   
#if [ $? != 0 ] ; then 
#  echo -e "\n\n======>>> [ERROR] en "$sh_dir"CMREC_1510_MIGRACION_PROPUESTAS_FONDOS_PROPIOS.sh"
#  echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"          
#  exit 1
#fi
#echo "[OK] ""$sh_dir""CMREC_1510_MIGRACION_PROPUESTAS_FONDOS_PROPIOS.sh ejecutado correctamente" 


echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_MIGRACION_EXPEDIENTES_NOTIFICACIONES.sh"                               
./"$sh_dir"CJM_MIGRACION_EXPEDIENTES_NOTIFICACIONES.sh "$1"   
if [ $? != 0 ] ; then 
  echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_MIGRACION_EXPEDIENTES_NOTIFICACIONES.sh"
  echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"          
  exit 1
fi
echo "[OK] ""$sh_dir""CJM_MIGRACION_EXPEDIENTES_NOTIFICACIONES.sh ejecutado correctamente" 



echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC-2102_Corrige_estados_subastas.sh"                               
./"$sh_dir"CMREC-2102_Corrige_estados_subastas.sh "$1"   
if [ $? != 0 ] ; then 
  echo -e "\n\n======>>> [ERROR] en "$sh_dir"CMREC-2102_Corrige_estados_subastas.sh"
  echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"          
  exit 1
fi
echo "[OK] ""$sh_dir""CMREC-2102_Corrige_estados_subastas.sh ejecutado correctamente" 


echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC-2339_Transiciones_automaticas_CM01.sh"                               
./"$sh_dir"CMREC-2102_Corrige_estados_subastas.sh "$1"   
if [ $? != 0 ] ; then 
  echo -e "\n\n======>>> [ERROR] en "$sh_dir"CMREC-2339_Transiciones_automaticas_CM01.sh"
  echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh [CMREC-2339_Transiciones_automaticas_CM01]"          
  exit 1
fi
echo "[OK] ""$sh_dir""CMREC-2339_Transiciones_automaticas_CM01.sh ejecutado correctamente" 


echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC-2339_Correccion_asuntos_sin_nombre_CM01.sh"                               
./"$sh_dir"CMREC-2339_Correccion_asuntos_sin_nombre_CM01.sh "$1"   
if [ $? != 0 ] ; then 
  echo -e "\n\n======>>> [ERROR] en "$sh_dir"CMREC-2339_Correccion_asuntos_sin_nombre_CM01.sh"
  echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh [CMREC-2339_Correccion_asuntos_sin_nombre_CM01]"          
  exit 1
fi
echo "[OK] ""$sh_dir""CMREC-2339_Correccion_asuntos_sin_nombre_CM01.sh ejecutado correctamente" 


echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC_1866_update_nombre_expediente_PCO.sh"                      
./"$sh_dir"CMREC_1866_update_nombre_expediente_PCO.sh "$1" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CMREC_1866_update_nombre_expediente_PCO.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CMREC_1866_update_nombre_expediente_PCO.sh ejecutado correctamente"         

echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_Analiza_cm01.sh"                      
./"$sh_dir"CJM_Analiza_cm01.sh "$1" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_Analiza_cm01.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CJM_Analiza_cm01.sh ejecutado correctamente"            



echo "[INFO] FIN CJM_lanza_migracion.sh. Revise el fichero de log" `date` 
exit 0
