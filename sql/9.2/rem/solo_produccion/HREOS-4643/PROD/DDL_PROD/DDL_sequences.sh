#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <pass@host:puerto/ORACLE_SID>"
    exit
fi

fichero="PROD/DDL_PROD/DDLs.list"
ls --format=single-column PROD/DDL_PROD/*.sql > $fichero
echo "INICIO DEL SCRIPT $0"

while read line
do
	if [ -f "$line" ] ; then
		echo "########################################################"
		echo "#####    INICIO $line"
		echo "########################################################"
		username=$(echo $line | cut -d '_' -f4)
		echo $username
		$ORACLE_HOME/bin/sqlplus "$username"/"$1" @"$line"
		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @"$line"
		   exit 1
		fi
	fi
done < "$fichero"

exit 0
