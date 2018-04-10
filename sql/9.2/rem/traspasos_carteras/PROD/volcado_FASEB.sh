#!/bin/bash
inicio=`date +%s`
if [ "$#" -ne 2 ]; then
    echo "Parametros: <pass@host:puerto/ORACLE_SID>"
    echo "Parametros: <USUARIO_MIGRACION> {CAJAMAR,SAREB,BANKIA,TANGO,GIANTS}"
    exit 1
fi

hora=`date +%H:%M:%S`
echo "########################################################"
echo "#####    ACTUALIZANDO Secuencias PRE-MIGRACION"
echo "########################################################"
fecha_ini=`date +%Y%m%d_%H%M%S`
if [ -f PROD/Logs/*.log ] ; then
	mv -f PROD/Logs/*.log PROD/Logs/backup
fi
./PROD/DDL_PROD/DDL_sequences.sh $1 > PROD/Logs/001_actualizado_secuencias_PRE_$fecha_ini.log
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en actualización de secuencias. Consultar log: PROD/Logs/001_actualizado_secuencias_PRE_$fecha_ini.log
   exit 1
fi
echo "Secuencias actualizadas."
echo

OUTPUT=$($ORACLE_HOME/bin/sqlplus -S REM01/$1 <<-EOF
SET HEADING OFF FEEDBACK OFF SERVEROUTPUT ON TRIMOUT ON PAGESIZE 0
SELECT USUARIOCREAR FROM REM01.MIG2_USUARIOCREAR_CARTERIZADO WHERE UPPER(USUARIOCREAR) LIKE UPPER('%$2%');
/
EOF
)
usuario=$(echo $OUTPUT | awk '{ print $1 }')
echo "********************************************************"
echo "USUARIOCREAR="$usuario
echo "********************************************************"
echo

#borrado_parcial=$2
#echo "********************************************************"
#echo "BORRADO_PARCIAL="$borrado_parcial
#echo "********************************************************"
#echo

ruta_descarterizada="PROD/DML_PROD/DMLs_DESCARTERIZADOS"
ruta_carterizada="PROD/DML_PROD/TMP"
ruta_noEjecutar=$ruta_descarterizada"/NO_EJECUTAR"
dml_list="DMLs.list"
rm -f $ruta_carterizada/*.sql
cd $ruta_descarterizada
ls --format=single-column *.sql > $dml_list
cd ../../../
mv -f $ruta_descarterizada/$dml_list $ruta_carterizada

fecha_ini=`date +%Y%m%d_%H%M%S`
while read line
do
	sed "s/#USUARIO_MIGRACION#/$usuario/g" $ruta_descarterizada/$line > $ruta_carterizada/$line
	#sed "s/#USUARIO_MIGRACION#/$usuario/g" $ruta_descarterizada/$line | sed "s/#CARTERA#/$borrado_parcial/g" > $ruta_carterizada/$line
	if [ $? != 0 ] ; then 
	   echo -e "\n\n======>>> "Error sustituyendo cartera en @$line
	   exit 1
	fi
	if [ -f $ruta_carterizada/$line ] ; then
		echo "########################################################"
		echo "#####    INICIO $line"
		echo "########################################################"
		username=$(echo $line | cut -d '_' -f3)
		echo "########################################################" >> PROD/Logs/002_volcado_"$usuario"_"$fecha_ini".log
		echo "#####    INICIO $line" >> PROD/Logs/002_volcado_"$usuario"_"$fecha_ini".log
		echo "########################################################" >> PROD/Logs/002_volcado_"$usuario"_"$fecha_ini".log
		$ORACLE_HOME/bin/sqlplus $username/$1 @$ruta_carterizada/$line >> PROD/Logs/002_volcado_"$usuario"_"$fecha_ini".log
		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @$line
		   exit 1
		fi
		echo >> PROD/Logs/002_volcado_"$usuario"_"$fecha_ini".log
		echo Fin $line
		mv -f $ruta_descarterizada/$line $ruta_noEjecutar
	else
		echo No existe $line
	fi
done < "$ruta_carterizada"/"$dml_list"

mv -f $ruta_noEjecutar/*.sql $ruta_descarterizada

echo Revise log: PROD/Logs/002_volcado_"$usuario"_"$fecha_ini".log

hora=`date +%H:%M:%S`
echo "########################################################"
echo "#####    ACTUALIZANDO Secuencias POST-MIGRACION"
echo "########################################################"
fecha_ini=`date +%Y%m%d_%H%M%S`
./PROD/DDL_PROD/DDL_sequences.sh $1 > PROD/Logs/003_actualizado_secuencias_POST_$fecha_ini.log
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en actualización de secuencias. Consultar log: PROD/Logs/003_actualizado_secuencias_POST_$fecha_ini.log
   exit 1
fi
echo "Secuencias actualizadas."
echo

fin=`date +%s`
let total=($fin-$inicio)/60
echo "###############################################################"
echo "####### [END] Volcado completado en [$total] minutos"
echo "###############################################################"

exit 0
