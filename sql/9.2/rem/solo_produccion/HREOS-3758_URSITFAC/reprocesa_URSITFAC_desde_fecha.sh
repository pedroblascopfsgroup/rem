#!/bin/bash
#REPROCESADO FICHERO URSITFAC.txt desde fecha_parametro hasta la actualidad

inicio=`date +%s`
if [ "$#" -ne 1 ]; then
    echo "Parametros: <Fecha YYYYMMDD>"
    exit 1
fi

#Inicializamos variables
factual=`date +"%Y%m%d"`
fecha=$1
hora_ini=`date "+%Y%m%d %H:%M:%S"`


echo "###################################################################"
echo "#####    [$hora_ini - INICIO]  REPROCESO URSITFAC.txt desde $fecha "
echo "###################################################################"

#Cargamos variables entorno
 source /recovery/rem/batch-server/shells/setBatchEnv.sh 

while [ $fecha -le $factual ] 
do
   echo "------------------------" 
   echo "Fecha a procesar $fecha "
   echo "------------------------"
   #Nos traemos el fichero del FTP de HAYA a la carpeta input
   ./apr_wait_ur_situacion_facturas.sh $fecha
   if [ $? = 0 ] 
   then
      echo "Fichero URSITFAC.txt $fecha copiado al directorio Input"
    
      #EJECUTAMOS ETL
     /recovery/rem/batch-server/shells/apr_load_ur_situacion_facturas.sh
    
     if [ $? = 0 ] 
     then
        echo "Fichero URSITFAC.txt $fecha procesado correctamente [apr_load_ur_situacion_facturas]"
     else
        echo "ERROR: Ha fallado el ETL apr_load_ur_situacion_facturas "
        exit 1
     fi 
    
   else
      echo "WARNING: No se ha podido copiar el fichero para $fecha o no existe"
      echo "WARNING: No se procesa el fichero para la fecha $fecha"
      echo "Se continua con el siguiente fichero ..."
   fi

   #Actualizamos fecha
   fecha=`date +"%Y%m%d" -d "$fecha+1 days"`   
done

fin=`date +%s`
let total=($fin-$inicio)/60
hora_fin=`date "+%Y%m%d %H:%M:%S"`

echo "####################################################################"
echo "####### [$hora_fin - FIN] REPROCESO URSITFAC.txt en [$total] minutos"
echo "####################################################################"

