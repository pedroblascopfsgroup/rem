#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <pass@host:puerto/ORACLE_SID>"
    exit
fi

fichero="DML/DMLs.list"

echo "INICIO DEL SCRIPT $0"

while read line
do
	if [ -f "DML/""$line" ] ; then
		echo "########################################################"
		echo "#####    INICIO $line"
		echo "########################################################"
		echo " "
		$ORACLE_HOME/bin/sqlplus "$1" @"DML/""$line"
		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @"DML/""$line"
		   exit 1
		fi

		echo "Fin $line"
	fi
done < "$fichero"

exit 0
