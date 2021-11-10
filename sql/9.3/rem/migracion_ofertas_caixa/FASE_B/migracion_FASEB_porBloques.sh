#!/bin/bash
##############################################################################################
#1.- Se comprueba que los parámetros de ejecución son correctos.
##############################################################################################
if [ "$#" -ne 3 ]; then
    echo "Parametros:"
    echo "[ERROR] Uso del script: Parámetro 1: <REM01/pass@IP:PORT/SID> Parámetro 2: 'USUARIO_MIGRACION' Parámetro 3: 'BLOQUE' (BLOQUE1, BLOQUE2, BLOQUE3, POSICIONA_OFERTAS o TODOS (Todos solo incluye los bloques principales))"
    echo "*************************************************************************************************"
    echo "USUARIO_MIGRACION ---> MIG_SAREB, MIG_CAJAMAR, MIG_BANKIA, MIG_COOPER, MIG_LIBERBANK, MIG_APPLE, MIG_DIVARIAN, [MIG_BBVA]"
    echo "Ejecutar desde: sql/9.3/rem/migracion_bbva/FASE_B/"
    exit 1
fi
QUERY=$($ORACLE_HOME/bin/sqlplus -S $1 <<-EOF
SET HEADING OFF FEEDBACK OFF SERVEROUTPUT ON TRIMOUT ON PAGESIZE 0
SELECT USUARIOCREAR FROM REM01.MIG2_USUARIOCREAR_CARTERIZADO WHERE UPPER(USUARIOCREAR) LIKE UPPER('%$2%');
/
EOF
)
migracion_correcta=0
for resultado in $QUERY; do
    if [[ $resultado = "MIG_"* ]] ; then 
		if [ $resultado = $2 ] ; then	
			migracion_correcta=1
	    fi
	fi
done

inicio=`date +%s`
hora=`date +%H:%M:%S`
fecha_ini=`date +%Y%m%d_%H%M%S`
migracion="$(echo $2 | cut -d '_' -f2)"

##############################################################################################
#2.- Se guardan los logs anteriores en la carpeta "/LOGS/LOGS_ANTERIORES/" y se crea nuevo log en "/LOGS/migracion_completo_FECHA.log"
##############################################################################################
mkdir -p LOGS/LOGS_ANTERIORES
mv -f LOGS/*.log LOGS/LOGS_ANTERIORES 2> /dev/null

##############################################################################################
#3.- Comienza la FASE_B de la migración
##############################################################################################
hora=`date +%H:%M:%S`
echo " "
echo "#########################################################################"
echo "####### [INICIO] Comienza la migración (FASE_B) $3 de $migracion: $hora"
echo "#########################################################################"
echo " "
if [ $migracion_correcta = 1 ] ; then
    echo "	-------------------------------------------------------------------------------------"
	echo "	------ [INFO] USUARIO DE LA MIGRACIÓN CORRECTO ["$2"]"
	echo "	-------------------------------------------------------------------------------------"
else
    echo "	-------------------------------------------------------------------------------------"
	echo "	------ [ERROR] USUARIO DE LA MIGRACIÓN INCORRECTO ["$2"]"
	echo "	------ [ERROR] El usuario [$2] no existe en la tabla REM01.MIG2_USUARIOCREAR_CARTERIZADO"
	echo "	-------------------------------------------------------------------------------------"
	exit 1
fi

##############################################################################################
######3.1.- Se actualizan las secuencias (PRE FASEB)
##############################################################################################
######[EJECUTABLE] 
######			   "./DDL/DDL_sequences.sh"
######[PROCESO] 
######             Ejecuta todos los scripts que haya en "DDL/*.sql" para actualizar las secuencias de las tablas de REM.
######			   (Esto se hace para evitar secuenciales que alguien haya podido meter a piñón en alguna tabla)
######[LOG]
######             Se guarda el log en "/LOGS/001_actualizacion_secuencias_REM_previo_FASEB_FECHA.log"
##############################################################################################
echo "	-------------------------------------------------------------------------------------"
echo "	------ [INFO] [`date +%H:%M:%S`] Comienza la actualización de secuencias de tablas de REM (PRE FASEB)"
echo "	-------------------------------------------------------------------------------------"
fecha_ini=`date +%Y%m%d_%H%M%S`
log1="LOGS/001_actualizacion_secuencias_REM_previo_FASEB_$fecha_ini.log"
./DDL/DDL_sequences.sh $1 > $log1
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en actualización de secuencias. Consultar log: $log1
   exit 1
fi
echo "	Secuencias actualizadas correctamente."
echo " "

##############################################################################################
######3.2.- Se ejecutan todos los scripts de la FASEB
##############################################################################################
######[PROCESO] 
######             1.- Se borran todos los scripts de la carpeta /TEMPORAL.
######             2.- Se crea un DMLs.list con los scripts a ejecutar y se recorre.
######             3.- Para cada script:
######             	 3.1.- Se cambia la variable #USUARIO_MIGRACION# por el usuario de migración pasado como parámetro y se mueve el script modificado a la carpeta /TEMPORAL.
######             	 3.2.- Se ejecuta el script
######             	 3.3.- Se mueve script a la carpeta DML/SCRIPTS_YA_EJECUTADOS
######			   4.- Se mueven todos los scripts de la ruta DML/SCRIPTS_YA_EJECUTADOS a la DML/SCRIPTS_A_EJECUTAR
######[LOG]
######             Se guarda el log en "/LOGS/002_migracion_completo_FASEB_MIGUSER_FECHA.log"
##############################################################################################
echo "	-------------------------------------------------------------------------------------"
echo "	------ [INFO] [`date +%H:%M:%S`] Comienza la ejecución de scripts (FASEB) (de tablas migra a tablas de REM)"
echo "	-------------------------------------------------------------------------------------"
fecha_ini=`date +%Y%m%d_%H%M%S`
log_completo="LOGS/002_migracion_completo_FASEB_"$2"_"$3"_"$fecha_ini".log"

ruta_scripts_ya_ejecutados="DML/SCRIPTS_YA_EJECUTADOS"
ruta_scripts_a_ejecutar="DML/SCRIPTS_A_EJECUTAR"
ruta_temporal="DML/TEMPORAL"
fichero_scripts="DMLs.list"

cd $ruta_scripts_a_ejecutar

if [ "$3" == "TODOS" ] ; then
	ls --format=single-column BLOQUE1/*.sql > $fichero_scripts
	ls --format=single-column BLOQUE2/*.sql >> $fichero_scripts
	ls --format=single-column BLOQUE3/*.sql >> $fichero_scripts
elif [ "$3" == "BLOQUE1" ] || [ "$3" == "BLOQUE2" ] || [ "$3" == "BLOQUE3" ] || [ "$3" == "POSICIONA_OFERTAS" ] ; then
	ls --format=single-column $3/*.sql > $fichero_scripts
else
	echo "[ERROR] No se ha indicado ningún bloque válido: "
	echo "[ERROR] Los bloques válidos son: BLOQUE1, BLOQUE2, BLOQUE3, POSICIONA_OFERTAS o TODOS (Todos solo incluye los bloques principales)"
	exit 0
fi

cd ../../
rm -f $ruta_temporal/*.sql
#mv -f $ruta_scripts_a_ejecutar/$fichero_scripts $ruta_temporal

#movemos los ficheros de todos los bloques necesarios al TEMPORAL
while read linea
do
	destino="$(echo $linea | cut -d'/' -f2)" 
	echo $destino
	sed "s/#USUARIO_MIGRACION#/$2/g" $ruta_scripts_a_ejecutar/$linea > $ruta_temporal/$destino
done < "$ruta_scripts_a_ejecutar"/"$fichero_scripts"	

cd $ruta_temporal
ls --format=single-column *.sql > $fichero_scripts
cd ../../

while read line
do
	
	
	if [ $? != 0 ] ; then 
	   echo -e "			\n\n======>>> "Error sustituyendo el usuario de migración en el @$line
	   exit 1
	fi
	if [ -f $ruta_temporal/$line ] ; then
		echo " "
		echo "			----------------------------------------------------------------------------------------------------------"
		echo "			------ [INFO] [`date +%H:%M:%S`] Comienza la ejecución del $line"
		echo "			----------------------------------------------------------------------------------------------------------"
		echo "##################################################################" >> $log_completo
		echo "#####    INICIO $line" >> $log_completo
		echo "##################################################################" >> $log_completo
		usuarioBD="$(echo $line | cut -d '_' -f3)"
		conexionBD="$(cut -d'/' -f2 <<<"$1")""/""$(cut -d'/' -f3 <<<"$1")"
		var="$(echo $line | sed 's/\.sql//g')"
		$ORACLE_HOME/bin/sqlplus $usuarioBD/$conexionBD @$ruta_temporal/$line >> $log_completo	
		#$ORACLE_HOME/bin/sqlplus $1 @$ruta_temporal/$line >> $log_completo	
		if [ $? != 0 ] ; then 
		   awk '/'$var'/,/Desconectado de Oracle Database/' $log_completo  | grep -a 'ORA-\|\ERROR\|INFO' | tr -d '\t' | sed 's/ERROR en/\[ERROR\] en/g' | sed 's/\[INFO/                                  \[INFO/g' | sed 's/\[ERROR/                                  \[ERROR/g' | sed 's/ORA-/                                  ORA-/g' | sed 's/Error en/                                  Error en/g'
		   echo -e "			\n\n======>>> "Error en la ejecución del @$line
		   echo -e "======>>> "Revise el log $log_completo
		   exit 1
		fi	
		awk '/'$var'/,/Desconectado de Oracle Database/' $log_completo  | grep -a 'ORA-\|\ERROR\|INFO' | tr -d '\t' | sed 's/ERROR en/\[ERROR\] en/g' | sed 's/\[INFO/                                  \[INFO/g' | sed 's/\[ERROR/                                  \[ERROR/g' | sed 's/ORA-/                                  ORA-/g' | sed 's/Error en/                                  Error en/g'
		echo " " >> $log_completo
		echo "Fin del $line" >> $log_completo
		echo "			Fin del $line"
		#mv -f $ruta_temporal/$line $ruta_scripts_ya_ejecutados
	else
		echo "			No existe el $line"
	fi
	echo " "
	#sed "s/$2/#USUARIO_MIGRACION#/g" $ruta_temporal/$line > $ruta_temporal/$line
done < "$ruta_temporal"/"$fichero_scripts"

#mv -f $ruta_temporal/*.sql $ruta_scripts_ya_ejecutados
#rm -f $ruta_temporal/*.sql
#rm -f $ruta_temporal/*.list

##############################################################################################
######3.3.- Se actualizan las secuencias (POST FASEB)
##############################################################################################
######[EJECUTABLE] 
######			   "./DDL/DDL_sequences.sh"
######[PROCESO] 
######             Ejecuta todos los scripts que haya en "DDL/*.sql" para actualizar las secuencias de las tablas de REM.
######			   (Esto se hace para evitar secuenciales que alguien haya podido meter a piñón en alguna tabla)
######[LOG]
######             Se guarda el log en "/LOGS/003_actualizacion_secuencias_REM_posterior_FASEB_FECHA.log"
##############################################################################################
echo "	-------------------------------------------------------------------------------------"
echo "	------ [INFO] [`date +%H:%M:%S`] Comienza la actualización de secuencias de tablas de REM (POST FASEB)"
echo "	-------------------------------------------------------------------------------------"
fecha_ini=`date +%Y%m%d_%H%M%S`
log3="LOGS/003_actualizacion_secuencias_REM_posterior_FASEB_$fecha_ini.log"
./DDL/DDL_sequences.sh $1 > $log3
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en actualización de secuencias. Consultar log: $log3
   exit 1
fi
echo "	Secuencias actualizadas correctamente."

##############################################################################################
#4.-Finaliza la FASE_B de la migración
##############################################################################################
echo " "
echo "	-------------------------------------------------------------------------------------"
echo "	------ [INFO] [`date +%H:%M:%S`] Revise los logs:"
echo "	-------------------------------------------------------------------------------------"
echo "	$log1"
echo "	$log_completo"
echo "	$log3"
fin=`date +%s`
let total=($fin-$inicio)/60
rm -f sqlnet.log
echo " "
echo "#########################################################################"
echo "####### [FIN] Migración Fase B completada en [$total] minutos"
echo "#########################################################################"
echo " "
exit 0


