#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <pass@host:puerto/ORACLE_SID>"
    exit
fi

fichero="DDL/DDLs.list"

echo "INICIO DEL SCRIPT $0"

while read line
do
	if [ -f "DDL/""$line" ] ; then
		echo "########################################################"
		echo "#####    INICIO $line"
		echo "########################################################"
		echo " "
		$ORACLE_HOME/bin/sqlplus "$1" @"DDL/""$line"
		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @"DDL/""$line"
		   exit 1
		fi

		echo "Fin $line"
	fi
done < "$fichero"

exit 0
