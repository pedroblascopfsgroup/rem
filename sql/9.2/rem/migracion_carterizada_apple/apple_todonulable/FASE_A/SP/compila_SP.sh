#!/bin/bash
##Comprobamos que el número de parámetros en correcto.
if [ "$#" -ne 2 ]; then
    echo "Parametros: <pass@host:puerto/ORACLE_SID>"
    exit
fi

##Comienza el proceso
echo "[INICIO] Comienza el proceso"
echo "--------------------------------------------------------------------"

##Rutas y variables necesarias. Se crea el SPs.list
echo "[INFO] Creando fichero lista de SPs [SP/SPs.list]..."
fichero="SP/SPs.list"
ls --format=single-column SP/*.sql | sed 's/.sql//g' > $fichero
echo "INICIO DEL SCRIPT $0"

##Se compilan los SPs de la carpeta [SP/]
echo "[INFO] Compilando los SPs de la carpeta [SP/*.sql]"
while read line
do
	if [ -f "$line".sql ] ; then
		echo "--------------------------------------------------------------------------------------------"
		echo "-----	[INFO] Compilando $line"
		echo "--------------------------------------------------------------------------------------------"
		$ORACLE_HOME/bin/sqlplus $1 @"$line".sql >> LOGS/005_compila_procedimientos_almacenados_$2.log
		#if [ $? != 0 ] ; then 
		#   	echo -e "\n\n======>>> "Error en @"$line".sql
		#   	exit 1
		#fi
		nr_errors=`grep -i -c "Procedimiento creado con errores" LOGS/005_compila_procedimientos_almacenados_$2.log`
		if [ $nr_errors != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @"$line".sql
		   break
		fi
		echo "Fin $line".sql
	    echo ""
	fi
done < "$fichero"

##[FIN] Fin del proceso
echo "[FIN] Acaba la compilación de SPs correctamente."
exit 0
