#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Parametros: <pass@host:puerto/ORACLE_SID>"
    echo "Parametros: <USUARIO_MIGRACION> {MIG_CAJAMAR,MIG_SAREB,MIG_BANKIA}"
    exit 1
fi

echo "########################################################"
echo "#####    ACTUALIZANDO Secuencias"
echo "########################################################"
fecha_ini=`date +%Y%m%d_%H%M%S`
./PROD/DDL_PROD/DDL_sequences.sh $1 > PROD/Logs/004_actualizado_secuencias_$fecha_ini.log
if [ $? != 0 ] ; then 
   echo -e "\n\n======>>> "Error en actualización de secuencias. Consultar log: PROD/Logs/004_actualizado_secuencias_$fecha_ini.log
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
echo $usuario
ruta_descarterizada="PROD/DML_PROD/DMLs_DESCARTERIZADOS"
ruta_carterizada="PROD/DML_PROD"
dml_list="DMLs.list"
rm -f $ruta_carterizada/*.sql
cd $ruta_descarterizada
ls --format=single-column *.sql > ../$dml_list
cd ../../../

fecha_ini=`date +%Y%m%d_%H%M%S`
while read line
do
	sed "s/#USUARIO_MIGRACION#/$usuario/g" $ruta_descarterizada/$line > $ruta_carterizada/$line
	if [ $? != 0 ] ; then 
	   echo -e "\n\n======>>> "Error sustituyendo cartera en @$line
	   exit 1
	fi
	if [ -f $ruta_carterizada/$line ] ; then
		echo "########################################################"
		echo "#####    INICIO $line"
		echo "########################################################"
		username=$(echo $line | cut -d '_' -f3)
		echo "$line" >> PROD/Logs/005_volcado_"$usuario"_"$fecha_ini".log
		$ORACLE_HOME/bin/sqlplus $username/$1 @$ruta_carterizada/$line >> PROD/Logs/005_volcado_"$usuario"_"$fecha_ini".log
		echo >> PROD/Logs/005_volcado_"$usuario"_"$fecha_ini".log
		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @$line
		   exit 1
		fi
		echo Fin $line
		echo
	else
		echo No existe $line
	fi
done < $ruta_carterizada/$dml_list

echo Revise log: PROD/Logs/005_volcado_"$usuario"_"$fecha_ini".log

exit 0
