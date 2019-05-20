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
pla_origen=$(grep ^$INTERFAZ, mapeo.csv |cut -d ',' -f 2)
ctl_file=$file_base".ctl"
mv $file_base".dat" ./CTLs_DATs/DATs
mv $file_base".plan" ./PLANTILLAS


export NLS_LANG=SPANISH_SPAIN.AL32UTF8
echo $ctl_file

echo "[INFO] Se ha establecido la variable de entorno NLS_LANG=SPANISH_SPAIN.AL32UTF8"

sh_dir="shells/"

echo "[INFO] INICIO EJECUCION Mover_ficheros_GFM $0" `date` 
echo "[INFO] ########################################################"  
echo "[INFO] #####    INICIO Mover_ficheros_GFM.sh($INTERFAZ)"  
echo "[INFO] ########################################################"  


      


mv ./CTLs_DATs/DATs/$file_base".dat" ./GFM_DAT/$dat_origen
mv $sql_dir$ddl_file ./GFM_DDL
mv $ctl_file ./GFM_CTL


echo "[INFO] FIN Mover_ficheros_GFM.sh. " `date` 

exit 0
