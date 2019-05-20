#!/bin/bash
if [ "$#" -ne 1 ] ; then
    echo "Parametros:  <USU/PASS@host:puerto/ORACLE_SID> " 
    exit 1
fi
export NLS_LANG=SPANISH_SPAIN.AL32UTF8
DATE=$(date +"%Y%m%d")
Prueba=0
ctl_dir="ctl/"
dat_dir="dat/"
log_dir="log/"
bad_dir="bad/"
sql_dir="sql/"
sh_dir="shells/"
echo "[INFO] INICIO EJECUCION GFM_GENERA_FICHEROS_MIGRACION $0" `date` 
echo "[INFO] ########################################################"  
echo "[INFO] #####    INICIO GFM_GENERA_FICHEROS_MIGRACION.sh"  
echo "[INFO] ########################################################"  

#POR CADA INTERFAZ
for line in $(cat mapeo.csv); do 
		INTERFAZ=$(echo $line | cut -d ',' -f 1)
		echo "------------------------------------------------------------------------------------------------------------------------------------------"
		echo "************************************************************************************************************************INTERFAZ $INTERFAZ"
		echo "------------------------------------------------------------------------------------------------------------------------------------------"
		#GENERA FICHERO CSV de GFM_GENERA_FICHEROS_MIGRACION.xlsx
		./xlsx2csv.py -d ';' -n $INTERFAZ GFM_GENERA_FICHEROS_MIGRACION.xlsx  'GFM_GENERA_FICHEROS_MIGRACION.csv'
		sed -e 's/;;;;;;/''/g' 'GFM_GENERA_FICHEROS_MIGRACION.csv' | sed -e '/^$/d' > 'GFM_GENERA_FICHEROS_MIGRACION2.csv'
		mv 'GFM_GENERA_FICHEROS_MIGRACION2.csv' 'GFM_GENERA_FICHEROS_MIGRACION.csv'

		#LANZAR GENERACION DE FICHEROS
		echo "[INFO] Comienza ejecución de: ""$sh_dir""GFM_GENERAR_FICHEROS.sh"
		./"$sh_dir"GFM_GENERAR_FICHEROS.sh "$1" "$DATE" "$INTERFAZ"
		if [ $? != 0 ] ; then 
			echo -e "\n\n======>>> [ERROR] en GFM_GENERAR_FICHEROS.sh"
			exit 1
		fi
		echo "[OK] GFM_GENERAR_FICHEROS.sh ejecutado correctamente"        

		# MOVER FICHEROS GENERADOS PARA PRUEBA
		mv ./dat/GFM_GENERA_FICHEROS_MIGRACION.dat ./dat/backup/carga$INTERFAZ.dat

		#LANZAR PRUEBA SI ESTA ACTIVADO 
		if [ $Prueba = 1 ] ; then
			echo "[INFO] Comienza ejecución de: ""$sh_dir""GFM_PRUEBA_FICHEROS.sh"
			./"$sh_dir"GFM_PRUEBA_FICHEROS.sh  "$1" "$INTERFAZ"
			if [ $? != 0 ] ; then 
				echo -e "\n\n======>>> [ERROR] en ""$sh_dir""GFM_PRUEBA_FICHEROS.sh"
				exit 1
			fi
			echo "[OK] ""$sh_dir""Probar_GFM.sh ejecutado correctamente"        
			
		fi 
		
		#LANZAR MOVER FICHEROS
		echo "[INFO] Comienza ejecución de: ""$sh_dir""GFM_MOVER_FICHEROS.sh"
		./"$sh_dir"GFM_MOVER_FICHEROS.sh  "$1" "$INTERFAZ"
		if [ $? != 0 ] ; then 
			echo -e "\n\n======>>> [ERROR] en ""$sh_dir""GFM_MOVER_FICHEROS.sh"
			exit 1
		fi
		echo "[OK] ""$sh_dir""GFM_MOVER_FICHEROS.sh ejecutado correctamente"        
done

exit 0



  
