#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Parametros: <pass@host:puerto/ORACLE_SID>"
    exit
fi

export fichero_old="SP/SPs.list"
export fichero="SP/SPs_lanza.list"
sed 's/SP\///g' $fichero_old > $fichero
rm -f $fichero_old


echo " "
echo "INICIO DEL SCRIPT $0"

$ORACLE_HOME/bin/sqlplus "$1" << ETIQUETA
	EXECUTE REM01.OPERACION_DDL.DDL_TABLE('ANALYZE','VALIDACIONES_MIGRACION','1');
ETIQUETA

while read line
do
	if [ -f SP/"$line".sql ] ; then
		echo "########################################################"
		echo "#####    EJECUTANDO $line"
		echo "########################################################"
		echo " "
		inicio=`date +%s`
		$ORACLE_HOME/bin/sqlplus "$1" << ETIQUETA >> ./Logs/006_ejecuta_procedimientos_almacenados_$2.log
			EXECUTE "$line";
			EXECUTE REM01.OPERACION_DDL.DDL_TABLE('ANALYZE','VALIDACIONES_MIGRACION','1');
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

mv -f $fichero $fichero_old
rm -f $fichero

exit 0
