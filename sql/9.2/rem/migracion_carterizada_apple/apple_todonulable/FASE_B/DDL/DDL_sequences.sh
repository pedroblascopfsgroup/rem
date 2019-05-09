#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <user/pass@host:puerto/ORACLE_SID>"
    exit
fi

fichero="DDL/DDLs.list"
ls --format=single-column DDL/*.sql > $fichero
echo "INICIO DEL SCRIPT $0"

conexionBD="$(cut -d'/' -f2 <<<"$1")""/""$(cut -d'/' -f3 <<<"$1")"

while read line
do
	if [ -f "$line" ] ; then
		echo "########################################################"
		echo "#####    INICIO $line"
		echo "########################################################"
		
		usuarioBD="$(cut -d'_' -f3 <<<"$line")"	
		$ORACLE_HOME/bin/sqlplus "$usuarioBD""/""$conexionBD" @"$line"

		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @"$line"
		   exit 1
		fi
	fi
done < "$fichero"

exit 0
