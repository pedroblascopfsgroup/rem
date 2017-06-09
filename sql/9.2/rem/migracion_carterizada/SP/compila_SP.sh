#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Parametros: <pass@host:puerto/ORACLE_SID>"
    exit
fi

fichero="SP/SPs.list"
ls --format=single-column SP/*.sql | sed 's/.sql//g' > $fichero
echo "INICIO DEL SCRIPT $0"

while read line
do
	if [ -f "$line".sql ] ; then
		echo "########################################################"
		echo "#####    COMPILANDO $line"
		echo "########################################################"
		$ORACLE_HOME/bin/sqlplus $1 @"$line".sql >> Logs/005_compila_procedimientos_almacenados_$2.log
		if [ $? != 0 ] ; then 
		   	echo -e "\n\n======>>> "Error en @"$line".sql
		   	exit 1
		fi

		echo "Fin $line".sql
	fi
done < "$fichero"

exit 0
