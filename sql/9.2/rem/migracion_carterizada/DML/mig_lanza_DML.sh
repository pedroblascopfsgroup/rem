#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <pass@host:puerto/ORACLE_SID>"
    exit
fi

fichero="DML/DMLs.list"
ls --format=single-column DML/*.sql > $fichero
echo "INICIO DEL SCRIPT $0"

while read line
do
	if [ -f "$line" ] ; then
		echo "########################################################"
		echo "#####    INICIO $line"
		echo "########################################################"
		$ORACLE_HOME/bin/sqlplus "$1" @"$line"
		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @"$line"
		   exit 1
		fi

		echo "Fin $line"
	fi
done < "$fichero"

exit 0
