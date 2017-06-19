#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <pass@host:puerto/ORACLE_SID>"
    exit
fi

fichero="PROD/SP/SPs.list"
ls --format=single-column PROD/SP/*.sql | sed 's/.sql//g' > $fichero

if [ -f PROD/Logs/002_*.log ] ; then
	mv -f PROD/Logs/002_*.log PROD/Logs/backup
fi

while read line
do
	if [ -f "$line".sql ] ; then
		echo "########################################################"
		echo "#####    COMPILANDO "$line
		echo "########################################################"
		fecha_ini=`date +%Y%m%d_%H%M%S`
		$ORACLE_HOME/bin/sqlplus $1 @"$line".sql >> PROD/Logs/002_compila_procedimientos_almacenados_$fecha_ini.log
		if [ $? != 0 ] ; then 
		   	echo -e "\n\n======>>> "Error en @"$line".sql
		   	exit 1
		fi

		echo "Fin $line".sql
		echo ""
	fi
done < "$fichero"

exit 0
