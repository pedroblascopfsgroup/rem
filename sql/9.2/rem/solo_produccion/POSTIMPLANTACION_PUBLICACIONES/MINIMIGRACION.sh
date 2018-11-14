#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "[ERROR] Parametros: <user/pass@host:puerto/ORACLE_SID>"
    exit
fi

inicio=`date +%s`
hora=`date +%H:%M:%S`
fecha_ini=`date +%Y%m%d_%H%M%S`

if [ "$ORACLE_HOME" == "" ] ; then
	echo "[INFO] No se ha encontrado el valor de ORACLE_HOME=$ORACLE_HOME"
fi

if [ "$ORACLE_SID" == "" ] ; then      
	echo "[INFO] No se ha encontrado el valor de ORACLE_SID=$ORACLE_SID"
fi

echo "[INICIO] INICIO CONFIGURACION $0"
echo "[INFO] $hora"
echo ""
export NLS_LANG=SPANISH_SPAIN.WE8ISO8859P1
echo "[INFO] Se ha establecido la variable de entorno NLS_LANG=SPANISH_SPAIN.WE8ISO8859P1"

if [ -d Logs/ ] ; then
	echo "[INFO] Ya existe el directorio Logs/"
else 
	mkdir Logs/
fi

if [ -d List/ ] ; then
	echo "[INFO] Ya existe el directorio List/"
else 
	mkdir List/
fi

echo ""
echo "[FIN] FIN CONFIGURACION $0"
echo ""
echo "-----------------------------------------------------------------"
echo ""
echo "[INICIO] INICIO EJECUCION CARPETA 001"
hora=`date +%H:%M:%S`
fecha_ini=`date +%Y%m%d_%H%M%S`
echo "[INFO] $hora"

fichero="List/001.list"
ls --format=single-column 001_*/*.sql > $fichero

while read line
do
	if [ -f "$line" ] ; then
		echo ""
		echo "[INFO] Inicio creación $line"
		$ORACLE_HOME/bin/sqlplus "$1" @"$line" > Logs/001_$line_$fecha_ini.log
		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @"$line"
		   exit 1
		fi
		echo "[INFO] Fin ejecución $line"
		echo ""
	fi
done < $fichero
echo "[FIN] FIN 001"
echo ""
echo "-----------------------------------------------------------------"
echo ""
echo "[INICIO] INICIO EJECUCION CARPETA 002"
hora=`date +%H:%M:%S`
fecha_ini=`date +%Y%m%d_%H%M%S`
echo "[INFO] $hora"

fichero="List/002.list"
ls --format=single-column 002_*/*.sql > $fichero

while read line
do
	if [ -f "$line" ] ; then
		echo ""
		echo "[INFO] Inicio creación $line"
		$ORACLE_HOME/bin/sqlplus "$1" @"$line" > Logs/002_$line_$fecha_ini.log
		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @"$line"
		   exit 1
		fi
		echo "[INFO] Fin ejecución $line"
		echo ""
	fi
done < $fichero
echo "[FIN] FIN 002"
echo ""
echo "-----------------------------------------------------------------"
echo ""
echo "[INICIO] INICIO EJECUCION CARPETA 003"
hora=`date +%H:%M:%S`
fecha_ini=`date +%Y%m%d_%H%M%S`
echo "[INFO] $hora"

fichero="List/003.list"
ls --format=single-column 003_*/*.sql > $fichero

while read line
do
	if [ -f "$line" ] ; then
		echo ""
		echo "[INFO] Inicio creación $line"
		$ORACLE_HOME/bin/sqlplus "$1" @"$line" > Logs/003_$line_$fecha_ini.log
		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @"$line"
		   exit 1
		fi
		echo "[INFO] Fin ejecución $line"
		echo ""
	fi
done < $fichero
echo "[FIN] FIN 003"
echo ""
fin=`date +%s`
hora=`date +%H:%M:%S`
let total_seg=($fin-$inicio)
let total_min=$total_seg/60
echo ""
echo "-----------------------------------------------------------------"
echo ""
echo "[RESUMEN]"
echo "[INFO] $hora"
echo "[FIN] Script ejecutado por completo en [$total_min] minutos / [$total_seg] segundos"

exit 0
