#!/bin/bash
ctl_dir="./"
sql_dir="./"
log_dir="./CTLs_DATs/logs/"


if [ "$#" -ne 2 ] ; then
    echo "Parametros: CONEX  <INTERFAZ> " 
    exit 1
fi

INTERFAZ=$2



file_base=$(grep ^$INTERFAZ, mapeo.csv |cut -d ',' -f 3)
ddl_file=$(grep ^$INTERFAZ, mapeo.csv |cut -d ',' -f 6)
dat_origen=$(grep ^$INTERFAZ, mapeo.csv |cut -d ',' -f 2)
ctl_file=$file_base".ctl"
mv $file_base".dat" ./CTLs_DATs/DATs




export NLS_LANG=SPANISH_SPAIN.AL32UTF8
echo $ctl_file

echo "[INFO] Se ha establecido la variable de entorno NLS_LANG=SPANISH_SPAIN.AL32UTF8"

sh_dir="shells/"

echo "[INFO] INICIO EJECUCION Prueba_GFM $0" `date` 
echo "[INFO] ########################################################"  
echo "[INFO] #####    INICIO Prueba_GFM.sh($INTERFAZ)"  
echo "[INFO] ########################################################"  

#Landar DDL
echo "[INFO] Comienza ejecución de: "$sql_dir$ddl_file
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir$ddl_file"
if [ $? != 0 ] ; then
    echo -e "\n\n======>>> [ERROR] en $sql_dir$ddl_file"
    exit 1           
fi
echo "[INFO] FIN ejecución de: $sql_dir$ddl_file"


#LANZAR LOADER
echo "[INFO] Comienza la carga de la tabla Probar_GFM.sh $2"
$ORACLE_HOME/bin/sqlldr control="$ctl_file" log="$log_dir$INTERFAZ"_"$fecha".log userid=$1 DIRECT=TRUE 
if [ $? != 0 ] ; then 
    echo -e "\n\n======>>> [ERROR] en ""$sh_dir""Prueba_GFM.sh"
    exit 1
fi
echo "[OK] ""$sh_dir""Probar_GFM.sh ejecutado correctamente"        

echo "[INFO] FIN Probar_GFM.sh. " `date` 

exit 0
