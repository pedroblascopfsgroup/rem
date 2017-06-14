#!/bin/bash
if [ "$#" -eq 2 ]; then
	fecha_ini=`date +%Y%m%d_%H%M%S`
	sed "s/#USUARIO_MIGRACION#/$2/g" PROD/BORRADO_MIGRACION_FASEB.sql > PROD/BORRADO_MIGRACION_FASEB_$2.sql
	echo "Borrando..."
	$ORACLE_HOME/bin/sqlplus "$1" @PROD/BORRADO_MIGRACION_FASEB_$2.sql > PROD/Logs/000_borrado_migracion_$2_$fecha_ini.log
	if [ $? != 0 ] ; then 
	   	echo -e "\n\n======>>> "Error en @PROD/BORRADO_MIGRACION_FASEB_$2.sql
	   	exit 1
	else
		rm -f PROD/BORRADO_MIGRACION_FASEB_$2.sql
		echo "Revise log: PROD/Logs/000_borrado_migracion_$2_$fecha_ini.log"
	fi
else
	echo "Parametros: <pass@host:puerto/ORACLE_SID>"
	echo "Parametros: <USUARIO_MIGRACION>"
	exit 1
fi

exit 0