#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Parametros: <pass@host:puerto/ORACLE_SID>"
    echo "Parametros: <USUARIO_MIGRACION>"
    exit 1
fi

ruta_descarterizada="PROD/DML_PROD/DMLs_DESCARTERIZADOS"
ruta_carterizada="PROD/DML_PROD"
dml_list="DMLs.list"
rm -f $ruta_carterizada/*.sql
cd $ruta_descarterizada
ls --format=single-column *.sql > ../$dml_list
cd ../../../

while read line
do
	sed "s/#USUARIO_MIGRACION#/$2/g" $ruta_descarterizada/$line > $ruta_carterizada/$line
	if [ $? != 0 ] ; then 
	   echo -e "\n\n======>>> "Error sustituyendo cartera en @$line
	   exit 1
	fi
	if [ -f $ruta_carterizada/$line ] ; then
		echo "########################################################"
		echo "#####    INICIO $line"
		echo "########################################################"
		fecha_ini=`date +%Y%m%d_%H%M%S`
		$ORACLE_HOME/bin/sqlplus "$1" @$ruta_carterizada/$line > PROD/Logs/002_volcado_produccion_$2_$fecha_ini.log
		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @$line
		   exit 1
		fi
		echo Fin $line
		echo "Revise log: PROD/Logs/001_volcado_produccion_$2_$fecha_ini.log"
	else
		echo No existe $line
	fi
done < $ruta_carterizada/$dml_list

exit 0
