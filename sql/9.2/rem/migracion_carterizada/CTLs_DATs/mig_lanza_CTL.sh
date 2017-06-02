#!/bin/bash

if [ "$#" -ne 1 ] ; then
    echo "Uso $0 <REM01/pass@IP:PORT/SID> "
    exit 1
fi

if [ "$ORACLE_HOME" == "" ] ; then
	echo "No se ha encontrado el valor de ORACLE_HOME=$ORACLE_HOME"
fi

if [ "$ORACLE_SID" == "" ] ; then      
	echo "No se ha encontrado el valor de ORACLE_SID=$ORACLE_SID"
fi

export NLS_LANG=SPANISH_SPAIN.WE8ISO8859P1

ruta="CTLs_DATs/"
fichero="CTLs.list"

if [ ! -f "$ruta""$fichero" ] ; then
	echo "No existe lista de ficheros CTL"
	exit 1
fi

rm -f "$ruta"logs/*.log
rm -f "$ruta"rejects/*.bad
rm -f "$ruta"bad/*.bad

echo "INICIO DEL SCRIPT $0"
echo "Se ha establecido la variable de entorno NLS_LANG=SPANISH_SPAIN.WE8ISO8859P1"
echo "Comienzo de la carga de las tablas MIG."
echo ""

while read line
do

	if [ -f "$ruta""$line".ctl ] ; then
		if [ -f "$ruta""DATs/""$line".dat ] ; then
			echo "########################################################"
			echo "#####    INICIO $line"
			echo "########################################################"
			echo " "
			$ORACLE_HOME/bin/sqlldr $1 control=./"$ruta""$line".ctl log=./"$ruta"logs/"$line".log
			if [ $? != 0 ] ; then 
			   echo -e "\n\n======>>> "Error en @"DDL/""$line"
			   exit 1
			fi

			echo "Fin $line"
			echo ""
		fi
	fi

done < "$ruta""$fichero"

$ORACLE_HOME/bin/sqlplus $1 aux/Mig_estadisticas.sql > ./"$ruta"logs/estadisticas.log
if [ $? != 0 ] ; then 
	echo -e "\n\n======>>> "Error en aux/Mig_estadisticas.sql >> ./"$ruta"logs/estadisticas.log ; 
	exit 1 ; 
fi
	echo "Fin de la carga de ficheros en Tablas MIG_. Revise directorio de logs y el directorio /bad."
exit

exit 0
