#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <user/pass@host:puerto/ORACLE_SID>"
    exit 1
fi

fichero="PROD/SP/SPs.list"
ls --format=single-column PROD/SP/*.sql | sed 's/.sql//g' > $fichero
fecha_ini=`date +%Y%m%d_%H%M%S`

while read line
do
	if [ -f "$line".sql ] ; then
		echo "########################################################"
		echo "#####    COMPILANDO "$line
		echo "########################################################"
		echo >> PROD/Logs/002_compila_$fecha_ini.log
		echo "########################################################" >> PROD/Logs/002_compila_$fecha_ini.log
		echo "#####    COMPILANDO "$line >> PROD/Logs/002_compila_$fecha_ini.log
		echo "########################################################" >> PROD/Logs/002_compila_$fecha_ini.log
		$ORACLE_HOME/bin/sqlplus $1 @"$line".sql >> PROD/Logs/002_compila_$fecha_ini.log
		if [ $? != 0 ] ; then 
		   	echo -e "\n\n======>>> "Error en @"$line".sql
		   	exit 1
		fi

		echo "Fin $line".sql
		echo ""
	fi
done < "$fichero"

exit 0
