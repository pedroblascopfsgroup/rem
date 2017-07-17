#!/bin/bash
inicio=`date +%s`
if [ "$#" -ne 2 ]; then
    echo "Parametros: <user/pass@host:puerto/ORACLE_SID>"
    echo "Parametros: <USUARIO_MIGRACION> {CAJAMAR,SAREB,BANKIA}"
    exit 1
fi

if [[ "$2" != "SAREB" ]] && [[ "$2" != "CAJAMAR" ]] && [[ "$2" != "BANKIA" ]]; then
    echo "[INFO] Entidad no válida."
    echo "[INFO] Valores aceptados [SAREB, CAJAMAR, BANKIA]"
    exit 1
fi
hora=`date +%H:%M:%S`
echo "########################################################"
echo "#####    ACTUALIZANDO Secuencias"
echo "########################################################"
fecha_ini=`date +%Y%m%d_%H%M%S`
if [ -f PROD/Logs/004_* ] ; then
	mv -f PROD/Logs/004_* PROD/Logs/backup
fi
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
echo "********************************************************"
echo "USUARIOCREAR="$usuario
echo "********************************************************"
echo

borrado_parcial=$2
echo "********************************************************"
echo "BORRADO_PARCIAL="$borrado_parcial
echo "********************************************************"
echo

ruta_descarterizada="PROD/DML_PROD/DMLs_DESCARTERIZADOS"
ruta_carterizada="PROD/DML_PROD"
dml_list="DMLs.list"
rm -f $ruta_carterizada/*.sql
cd $ruta_descarterizada
ls --format=single-column *.sql > ../$dml_list
cd ../../../

fecha_ini=`date +%Y%m%d_%H%M%S`
if [ -f PROD/Logs/005_* ] ; then
	mv -f PROD/Logs/005_* PROD/Logs/backup
fi
while read line
do
	sed "s/#USUARIO_MIGRACION#/$usuario/g" $ruta_descarterizada/$line | sed "s/#CARTERA#/$borrado_parcial/g" > $ruta_carterizada/$line
	if [ $? != 0 ] ; then 
	   echo -e "\n\n======>>> "Error sustituyendo cartera en @$line
	   exit 1
	fi
	if [ -f $ruta_carterizada/$line ] ; then
		echo "########################################################"
		echo "#####    INICIO $line"
		echo "########################################################"
		username=$(echo $line | cut -d '_' -f3)
		echo "########################################################" >> PROD/Logs/005_volcado_"$usuario"_"$fecha_ini".log
		echo "#####    INICIO $line" >> PROD/Logs/005_volcado_"$usuario"_"$fecha_ini".log
		echo "########################################################" >> PROD/Logs/005_volcado_"$usuario"_"$fecha_ini".log
		$ORACLE_HOME/bin/sqlplus $username/$1 @$ruta_carterizada/$line >> PROD/Logs/005_volcado_"$usuario"_"$fecha_ini".log
		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @$line
		   exit 1
		fi
		echo >> PROD/Logs/005_volcado_"$usuario"_"$fecha_ini".log
		echo Fin $line
		echo
	else
		echo No existe $line
	fi
done < $ruta_carterizada/$dml_list

echo Revise log: PROD/Logs/005_volcado_"$usuario"_"$fecha_ini".log
fin=`date +%s`
let total=($fin-$inicio)/60
echo "###############################################################"
echo "####### [END] Volcado completado en [$total] minutos"
echo "###############################################################"

exit 0
