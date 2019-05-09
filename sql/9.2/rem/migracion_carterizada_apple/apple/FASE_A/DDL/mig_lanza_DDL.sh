#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <pass@host:puerto/ORACLE_SID>"
    exit
fi

fichero="DDL/DDLs.list"
ls --format=single-column DDL/*.sql > $fichero
echo "INICIO DEL SCRIPT $0"

while read line
do
	if [ -f "$line" ] ; then
		echo "########################################################"
		echo "#####    [INICIO] Creacion de la tabla $line"
		echo "########################################################"
		echo " "
		$ORACLE_HOME/bin/sqlplus "$1" @"$line"
		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en la creacion de la tabla @"$line"
		   exit 1
		fi

		echo "Fin $line"
	fi
done < "$fichero"

exit 0
