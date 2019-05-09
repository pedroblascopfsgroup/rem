#!/bin/bash
##Comprobamos que el número de parámetros en correcto.
if [ "$#" -ne 2 ]; then
    echo "Parametros: <usuario/pass@host:puerto/ORACLE_SID> y <USUARIO_MIGRACION> (LIBERBANK,COOPER)"
    exit
fi

##Comienza el proceso
echo "[INICIO] Comienza el proceso"
echo "--------------------------------------------------------------------"

##Rutas y variables necesarias. Se crea el DMLs.list
echo "[INFO] Creando fichero lista de DMLs [DMLS/DMLs.list]..."
fichero=DML/DMLs.list
ruta=DML/
ls --format=single-column $ruta*.sql > $fichero

##Se ejecutan los DMLs de la carpeta [DML/]
echo "[INFO] Ejecutando los DMLs de la carpeta [DML/*.sql]"
while read line
do
	if [ -f "$line" ] ; then
		echo "--------------------------------------------------------------------------------------------"
		echo "-----	[INFO] Ejecutando $line"
		echo "--------------------------------------------------------------------------------------------"
		$ORACLE_HOME/bin/sqlplus "$1" @"$line"
		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @"$line"
		   exit 1
		fi
		echo "Fin $line"
	    echo ""
	fi
done < "$fichero"

##[FIN] Fin del proceso
echo "[FIN] Acaba la ejecución de DMLs correctamente."
exit 0
