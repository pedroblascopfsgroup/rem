#!/bin/bash
##Comprobamos que el número de parámetros en correcto.
if [ "$#" -ne 3 ]; then
    echo "Parametros: <pass@host:puerto/ORACLE_SID>" >> $3
    exit
fi

##Comienza el proceso
echo "[INICIO] Comienza el proceso $0" >> $3
echo "--------------------------------------------------------------------" >> $3

##Rutas y variables necesarias. Se crea el SPs_lanza.list y se borra el SP/SPs.list
echo "[INFO] Creando fichero lista de SPs [SP/SPs_lanza.list]..." >> $3
export fichero_old="SP/SPs.list"
export fichero="SP/SPs_lanza.list"
sed 's/SP\///g' $fichero_old > $fichero
rm -f $fichero_old

##Se ejecutan los SPs de la carpeta [SP/]
echo "[INFO] Ejecutando los SPs de la carpeta [SP/*.sql]" >> $3
$ORACLE_HOME/bin/sqlplus "$1" << ETIQUETA >> $3
	EXECUTE REM01.OPERACION_DDL.DDL_TABLE('ANALYZE','VALIDACIONES_RESULTADOS','1');
ETIQUETA

while read line
do
	if [ -f SP/"$line".sql ] ; then
		echo "--------------------------------------------------------------------------------------------" >> $3
		echo "-----	[INFO] Ejecutando $line" >> $3
		echo "--------------------------------------------------------------------------------------------" >> $3
		echo " " >> $3
		inicio=`date +%s`
		echo "	[INFO] Ejecutando el SP de Validacion "$line
		$ORACLE_HOME/bin/sqlplus "$1" << ETIQUETA >> ./LOGS/006_ejecuta_procedimientos_almacenados_$2.log >> $3
			EXECUTE "$line";
			EXECUTE REM01.OPERACION_DDL.DDL_TABLE('ANALYZE','VALIDACIONES_RESULTADOS','1');
ETIQUETA
		#if [ $? != 0 ] ; then 
		#   echo -e "\n\n======>>> "Error en @"$line"
		#   echo "SP ejecutado en $total minutos"
		#   exit 1
		#fi
		fin=`date +%s`
		let total=($fin-$inicio)/60
		nr_errors=`grep -i -c ^ORA-.....: ./LOGS/006_ejecuta_procedimientos_almacenados_$2.log`
		if [ $nr_errors != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @"$line" >> $3
		   echo "SP ejecutado en $total minutos" >> $3
		   break
		fi
		fin=`date +%s`
		let total2=($fin-$inicio)
		let total=($fin-$inicio)/60
		
		posicion=`echo ${line:5:1}`
		letra=`echo ${line:18:1}`
		texto=`echo ${line:18:5}`
		
		QUERY=$($ORACLE_HOME/bin/sqlplus -S $1 <<-EOF
		SET HEADING OFF FEEDBACK OFF SERVEROUTPUT ON TRIMOUT ON PAGESIZE 0
		SELECT '{}', COUNT(*), MOTIVO_RECHAZO FROM VALIDACIONES_RESULTADOS WHERE MOTIVO_RECHAZO LIKE '%$texto%' GROUP BY MOTIVO_RECHAZO ORDER BY 2 ASC;
		EOF
		)

		echo $QUERY | sed -e s/"SP2.*sql\""/""/g | tr '{' '\n' | sed -e s/"\}"/"		\[INFO\] "/g | sed -e s/"\[$letra"/"	\[$letra"/g

		echo "		[TIEMPO] $total2 segundos"
		echo ""
		echo "SP ejecutado en $total minutos" >> $3
		echo "Fin $line" >> $3
		echo " " >> $3
	fi
done < "$fichero"

##[FIN] Fin del proceso
mv -f $fichero $fichero_old
rm -f $fichero
echo "[FIN] Acaba la compilación de SPs correctamente." >> $3
exit 0
