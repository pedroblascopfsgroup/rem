#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <pass@host:puerto/ORACLE_SID>"
    exit
fi

fichero="SP/SPs.list"
echo " "
echo "INICIO DEL SCRIPT $0"

while read line
do
	if [ -f "SP/""$line".sql ] ; then
		echo "########################################################"
		echo "#####    EJECUTANDO $line"
		echo "########################################################"
		echo " "
		inicio=`date +%s`
		$ORACLE_HOME/bin/sqlplus "$1" << ETIQUETA > ./Logs/exec_"$line".log
			EXECUTE "$line"
ETIQUETA
		fin=`date +%s`
		total=$fin-$inicio
		echo "SP ejecutado en $total segundos"
		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @"$line"
		   exit 1
		fi

		echo "Fin $line"
		echo " "
	fi
done < "$fichero"

exit 0
