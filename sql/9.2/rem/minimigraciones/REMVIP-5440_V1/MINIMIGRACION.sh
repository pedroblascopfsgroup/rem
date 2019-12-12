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

if [ -d Loader/logs/ ] ; then
	echo "[INFO] Ya existe el directorio Loader/logs/"
else 
	mkdir Loader/logs/
fi

if [ -d Loader/bad/ ] ; then
	echo "[INFO] Ya existe el directorio Loader/bad/"
else 
	mkdir Loader/bad/
fi

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
echo "[INICIO] INICIO CREACIÓN DE TABLAS AUXILIARES"
hora=`date +%H:%M:%S`
fecha_ini=`date +%Y%m%d_%H%M%S`
echo "[INFO] $hora"

fichero="List/DDLs.list"
ls --format=single-column DDL/DDL_*.sql > $fichero

while read line
do
	if [ -f "$line" ] ; then
		echo ""
		echo "[INFO] Inicio creación $line"
		$ORACLE_HOME/bin/sqlplus "$1" @"$line" > Logs/DDL_$line_$fecha_ini.log
		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @"$line"
		   exit 1
		fi
		echo "[INFO] Fin creación $line"
		echo ""
	fi
done < $fichero
echo "[FIN] FIN CARGA DE TABLAS AUXILIARES"
echo ""
echo "-----------------------------------------------------------------"
echo ""
echo "[INICIO] INICIO CARGA DE TABLAS AUXILIARES"
hora=`date +%H:%M:%S`
fecha_ini=`date +%Y%m%d_%H%M%S`
echo "[INFO] $hora"

fichero="List/CTLs.list"
ls --format=single-column Loader/*.ctl | sed 's/.ctl//g' > $fichero
if [ ! -f $fichero ] ; then
	echo "[INFO] No existe lista de ficheros CTL"
	exit 1
fi

while read line
do
	if [ -f $line.zip ] ; then
		unzip -oq $line.zip -d Loader/
	fi
	if [ -f $line.ctl ] ; then
		if [ -s $line.dat ] ; then
			echo ""
			auxiliar=`basename $line`
			echo "[INFO] Inicio carga auxiliar $auxiliar"
			$ORACLE_HOME/bin/sqlldr $1 control=./$line.ctl data= ./$line.dat log=./Loader/logs/$auxiliar.log bad=./Loader/bad/$auxiliar.bad > Logs/CTL_$line_$fecha_ini.log
			if [ $? != 0 ] ; then 
			   echo -e "\n\n======>>> "[ERROR] Error en @$line
			   #exit 1
			fi
			echo "[INFO] Fin carga auxiliar $auxiliar"
			echo ""
			rm -f $line.dat
		fi
	fi
done < $fichero

echo "[FIN] FIN CARGA DE TABLAS AUXILIARES"
echo ""
echo "-----------------------------------------------------------------"
echo ""
echo "[INICIO] INICIO CARGA DE TABLAS FINALES"
hora=`date +%H:%M:%S`
fecha_ini=`date +%Y%m%d_%H%M%S`
echo "[INFO] $hora"

fichero="List/DMLs.list"
ls --format=single-column DML/DML_*.sql > $fichero

while read line
do
	if [ -f $line ] ; then
		echo ""
		echo "[INFO] Inicio carga final $line"
		$ORACLE_HOME/bin/sqlplus "$1" @"$line" > Logs/DML_$line_$fecha_ini.log
		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "[ERROR] Error en @$line
		   exit 1
		fi
		echo "[INFO] Fin carga final $line"
		echo ""
	fi
done < $fichero

echo "[FIN] FIN CARGA DE TABLAS FINALES"

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
