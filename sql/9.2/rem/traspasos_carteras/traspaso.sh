#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <usuario/pass@host:puerto/ORACLE_SID>"
    exit 1
fi
inicio=`date +%s`
export NLS_LANG=SPANISH_SPAIN.UTF8

mkdir -p Logs/backup/
mv -f Logs/*.log Logs/backup/
fecha_log=`date +%Y%m%d_%H%M%S`
log_completo="Logs/traspaso_completo_"$fecha_log".log"

hora=`date +%H:%M:%S`
echo "###############################################################"
echo "####### [START] Comienza el traspaso de activos: $hora"
echo "###############################################################"
echo " "
##############################################################################################
echo "	-------------------------------------------------------"
echo "	------ [INFO] Creando tablas"
echo "	-------------------------------------------------------"
fecha_ini=`date +%Y%m%d_%H%M%S`
inicioparte=`date +%s`
salida=Logs/001_creacion_tablas_$fecha_ini.log 
./DDL/mig_lanza_DDL.sh $1 > $salida
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error creando tablas
   exit 1
fi
cat $salida >> $log_completo
fin=`date +%s`
let total=($fin-$inicioparte)/60
if [ $total = 0 ] ; then
   let total=($fin-$inicioparte)
   echo "	Tablas creadas en $total segundos."
else
   echo "	Tablas creadas en $total minutos."
fi
##############################################################################################
echo " "
echo "	-------------------------------------------------------"
echo "	------ [INFO] Rellenando tablas"
echo "	-------------------------------------------------------"
fecha=`date +%Y%m%d_%H%M%S`
inicioparte=`date +%s`
salida=Logs/002_carga_tablas_$fecha.log
./DML/mig_lanza_DML.sh $1 > $salida
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error cargando tablas de traspaso
   exit 1
fi
cat $salida >> $log_completo
fin=`date +%s`
let total=($fin-$inicioparte)/60
if [ $total = 0 ] ; then
   let total=($fin-$inicioparte)
   echo "	Tablas de traspaso rellenadas en $total segundos."
else
   echo "	Tablas de traspaso rellenadas en $total minutos."
fi
##############################################################################################
echo " "
echo "	*******************************************************"
echo "	****** [INFO] Revise log completo: $log_completo"
echo "	*******************************************************"
echo " "

fin=`date +%s`
let total=($fin-$inicio)/60
echo "###############################################################"
echo "####### [END] Traspaso completado en [$total] minutos"
echo "###############################################################"

exit 0
