#!/bin/bash
if [ "$#" -ne 3 ]; then
    echo "Parametros: <pass@host:puerto/ORACLE_SID>"
    echo "Parametros: <proceso> [01:BORRAR/02:ACTIVAR]"
    echo "Parametros: <cartera> [CAJAMAR/SAREB/BANKIA/OTROS/...DD_CRA_CARTERA]"
    exit
fi

./PROD/SP/compila_SP.sh $1
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error compilando en @"$line"
   exit 1
fi

fichero="PROD/SP/SPs.list"
sql=`grep -riC 0 $2 $fichero`
procedure=`grep -riC 0 $2 $fichero | sed "s/PROD\/SP\/SP_0"$2"_//g"`

if [ -s "$sql".sql ] ; then
	echo "########################################################"
	echo "#####    EJECUTANDO "$procedure
	echo "########################################################"
	inicio=`date +%s`
	fecha_ini=`date +%Y%m%d_%H%M%S`
	echo $2
	echo $3
	$ORACLE_HOME/bin/sqlplus "$1" << ETIQUETA #> ./Logs/002_ejecuta_$procedure_$fecha_ini.log
		EXECUTE $procedure('$3');
ETIQUETA
	if [ $? != 0 ] ; then 
	   echo -e "\n\n======>>> "Error en @$procedure
	   echo "SP ejecutado en $total minutos"
	   exit 1
	fi
	fin=`date +%s`
	let total=($fin-$inicio)/60
	echo "SP ejecutado en $total minutos"
	echo "Fin "$procedure
	echo " "
fi

exit 0
