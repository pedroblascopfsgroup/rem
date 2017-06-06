#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <pass@host:puerto/ORACLE_SID>"
    exit
fi

fichero="SP/SPs.list"
echo " "
echo "INICIO DEL SCRIPT $0"

$ORACLE_HOME/bin/sqlplus "$1" << ETIQUETA
	EXECUTE REM01.OPERACION_DDL.DDL_TABLE('ANALYZE','VALIDACIONES_MIGRACION','10');
ETIQUETA

while read line
do
	if [ -f "SP/""$line".sql ] ; then
		echo "########################################################"
		echo "#####    EJECUTANDO $line"
		echo "########################################################"
		echo " "
		inicio=`date +%s`
		$ORACLE_HOME/bin/sqlplus "$1" << ETIQUETA > ./Logs/exec_"$line".log
			EXECUTE "$line";
			EXECUTE REM01.OPERACION_DDL.DDL_TABLE('ANALYZE','VALIDACIONES_MIGRACION','10');
ETIQUETA
		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @"$line"
		   echo "SP ejecutado en $total minutos"
		   exit 1
		fi
		fin=`date +%s`
		let total=($fin-$inicio)/60
		echo "SP ejecutado en $total minutos"
		echo "Fin $line"
		echo " "
	fi
done < "$fichero"

exit 0
