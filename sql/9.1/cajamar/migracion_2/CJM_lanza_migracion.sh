#!/bin/bash
if [ "$#" -ne 2 ] ; then
    echo "Parametros: <CM01/CM01_pass@host:puerto/ORACLE_SID> <fecha_datos YYYYMMDD> " 
    echo "  <entorno>: desa, pre, pro"
    exit 1
fi

export NLS_LANG=SPANISH_SPAIN.AL32UTF8

echo "[INFO] Se ha establecido la variable de entorno NLS_LANG=SPANISH_SPAIN.AL32UTF8"

echo "[INFO] Cogiendo información del entorno correspondiente"
#cd /recovery/batch-server/migracion
#cp etls/config/$3/config.ini etls/config/

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

#echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_script_borrado.sh"                      
#./"$sh_dir"CJM_script_borrado.sh "$1"          
#if [ $? != 0 ] ; then 
#    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_script_borrado.sh"
#    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
#    exit 1
#fi
#echo "[OK] ""$sh_dir""CJM_script_borrado.sh ejecutado correctamente"            

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


#Este script instancia los litigios
echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_instancia_BPMs.sh"                               
./"$sh_dir"CJM_instancia_BPMs.sh "$1"   
if [ $? != 0 ] ; then 
  echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_instancia_BPMs.sh"
  echo -e "\n\n======>>> [ERROR] en CJM_instancia_BPMs.sh"          
  exit 1
fi
echo "[OK] ""$sh_dir""CJM_instancia_BPMs.sh ejecutado correctamente"        


echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_migracion_volumetria_carga.sh"                      
./"$sh_dir"CJM_migracion_volumetria_carga.sh "$1" "$2" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_migracion_volumetria_carga.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CJM_migracion_volumetria_carga.sh ejecutado correctamente"      



#####################################
### BLOQUE Correccion incidencias y Cambios
#####################################

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


echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC-1797_carterizacion_CAJAMAR_postmigracion.sh"                               
./"$sh_dir"CMREC-1797_carterizacion_CAJAMAR_postmigracion.sh "$1"   
if [ $? != 0 ] ; then 
  echo -e "\n\n======>>> [ERROR] en "$sh_dir"CMREC-1797_carterizacion_CAJAMAR_postmigracion.sh"
  echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"          
  exit 1
fi
echo "[OK] ""$sh_dir""CMREC-1797_carterizacion_CAJAMAR_postmigracion.sh ejecutado correctamente" 


echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC-1797_Carterizacion_LETRADOS_y_PROCURADORES.sh"                               
./"$sh_dir"CMREC-1797_Carterizacion_LETRADOS_y_PROCURADORES.sh "$1"   
if [ $? != 0 ] ; then 
  echo -e "\n\n======>>> [ERROR] en "$sh_dir"CMREC-1797_Carterizacion_LETRADOS_y_PROCURADORES.sh"
  echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"          
  exit 1
fi
echo "[OK] ""$sh_dir""CMREC-1797_Carterizacion_LETRADOS_y_PROCURADORES.sh ejecutado correctamente" 

echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_CMREC_3078_INSERT_SUBASTAS_FICTICIAS_NO_ENVIADAS.sh"                               
./"$sh_dir"CJM_CMREC_3078_INSERT_SUBASTAS_FICTICIAS_NO_ENVIADAS.sh "$1"   
if [ $? != 0 ] ; then 
  echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_CMREC_3078_INSERT_SUBASTAS_FICTICIAS_NO_ENVIADAS.sh"
  echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"          
  exit 1
fi
echo "[OK] ""$sh_dir""CJM_CMREC_3078_INSERT_SUBASTAS_FICTICIAS_NO_ENVIADAS.sh ejecutado correctamente" 


echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC-2102_Corrige_estados_subastas.sh"                               
./"$sh_dir"CMREC-2102_Corrige_estados_subastas.sh "$1"   
if [ $? != 0 ] ; then 
  echo -e "\n\n======>>> [ERROR] en "$sh_dir"CMREC-2102_Corrige_estados_subastas.sh"
  echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"          
  exit 1
fi
echo "[OK] ""$sh_dir""CMREC-2102_Corrige_estados_subastas.sh ejecutado correctamente" 


echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC-2339_Transiciones_automaticas_CM01.sh"                               
./"$sh_dir"CMREC-2339_Transiciones_automaticas_CM01.sh "$1"   
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


echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC_1671_Gestion_asunto_por_marca_haya.sh"                      
./"$sh_dir"CMREC_1671_Gestion_asunto_por_marca_haya.sh "$1" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CMREC_1671_Gestion_asunto_por_marca_haya.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CMREC_1671_Gestion_asunto_por_marca_haya.sh ejecutado correctamente"   


echo "[INFO] Comienza ejecución de: ""$sh_dir""CMREC_2874_Modifica_Descripcion_expediente.sh"                      
./"$sh_dir"CMREC_2874_Modifica_Descripcion_expediente.sh "$1" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CMREC_2874_Modifica_Descripcion_expediente.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CMREC_2874_Modifica_Descripcion_expediente.sh ejecutado correctamente"         


echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_Inclusion_Bur_Doc_otros_estados.sh"                      
./"$sh_dir"CJM_Inclusion_Bur_Doc_otros_estados.sh "$1" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_Inclusion_Bur_Doc_otros_estados.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CJM_Inclusion_Bur_Doc_otros_estados.sh ejecutado correctamente"         


echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_MIGRACION_EMBARGOS.sh"                      
./"$sh_dir"CJM_MIGRACION_EMBARGOS.sh "$1" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_MIGRACION_EMBARGOS.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CJM_MIGRACION_EMBARGOS.sh ejecutado correctamente"         
     
echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_BORRA_TEX_DECISION.sh"                      
./"$sh_dir"CJM_BORRA_TEX_DECISION.sh "$1" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_BORRA_TEX_DECISION.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CJM_BORRA_TEX_DECISION.sh ejecutado correctamente"	 
	 
echo "[INFO] Comienza ejecución de: ""$sh_dir""CJM_LAMINACION_Y_MIG_TAREAS_PERENTORIAS.sh"                      
./"$sh_dir"CJM_LAMINACION_Y_MIG_TAREAS_PERENTORIAS.sh "$1" 
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en "$sh_dir"CJM_LAMINACION_Y_MIG_TAREAS_PERENTORIAS.sh"
    echo -e "\n\n======>>> [ERROR] en CJM_lanza_migracion.sh"
    exit 1           
fi
echo "[OK] ""$sh_dir""CJM_LAMINACION_Y_MIG_TAREAS_PERENTORIAS.sh ejecutado correctamente"  


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
