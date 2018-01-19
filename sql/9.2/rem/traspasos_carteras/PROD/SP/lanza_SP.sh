#!/bin/bash
if [ "$#" -ne 3 ]; then
    echo "Parametros: <pass@host:puerto/ORACLE_SID>"
    echo "Parametros: <proceso> [01 para borrar cartera/02 para activarla]"
    echo "Parametros: <cartera> [CAJAMAR/SAREB/BANKIA/OTROS/...DD_CRA_CARTERA]"
    exit 1
fi

if [ -f PROD/Logs/002_* ] ; then
	mv -f PROD/Logs/002_* PROD/Logs/backup/
fi

./PROD/SP/compila_SP.sh $1
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error compilando en @"$line"
   exit 1
fi

fichero="PROD/SP/SPs.list"
sql=`grep -riC 0 $2 $fichero`
procedure=`grep -riC 0 $2 $fichero | sed "s/PROD\/SP\/SP_0$2_//g"`

if [ -f PROD/Logs/003_*.log ] ; then
	mv -f PROD/Logs/003_*.log PROD/Logs/backup
fi

if [ -s "$sql".sql ] ; then
	echo "########################################################"
	echo "#####    EJECUTANDO "$procedure
	echo "########################################################"
	inicio=`date +%s`
	fecha_ini=`date +%Y%m%d_%H%M%S`
	if [ "$2" == "01" ] ; then 
		echo "Borrando cartera... "$3
	elif [ "$2" == "02" ] ; then
		echo "Activando cartera... "$3
	fi
	$ORACLE_HOME/bin/sqlplus "$1" << ETIQUETA > ./PROD/Logs/003_ejecuta_"$procedure"_$fecha_ini.log
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
