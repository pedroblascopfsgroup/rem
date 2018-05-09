#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Parametros: <usuario/pass@host:puerto/ORACLE_SID> y <USUARIO_MIGRACION> (LIBERBANK,COOPER)"
    exit
fi

nombre_fichero="DDL_001_REM_COPIA_TABLA"
ruta_tmp="POST_FASEA/TMP/"
ruta_original="POST_FASEA/"$nombre_fichero".sql"

rm -f $ruta_tmp*.sql

ARRAY_1=($($ORACLE_HOME/bin/sqlplus -S REM01/$1 <<-EOF
SET HEADING OFF FEEDBACK OFF SERVEROUTPUT ON TRIMOUT ON PAGESIZE 0
SELECT TABLAS.TABLE_NAME
FROM ALL_TABLES TABLAS
JOIN USER_OBJECTS OBJ ON TABLAS.TABLE_NAME = OBJ.OBJECT_NAME
WHERE (REGEXP_LIKE(TABLAS.TABLE_NAME, '^MIG') AND NOT REGEXP_LIKE(TABLAS.TABLE_NAME, '\_[SCBL][RJKOI]$')
AND OBJ.OBJECT_TYPE = 'TABLE')
OR (REGEXP_LIKE(TABLAS.TABLE_NAME, '^VIC') AND REGEXP_LIKE(TABLAS.TABLE_NAME, 'FUNC$')
AND OBJ.OBJECT_TYPE = 'TABLE');
/
EOF
))

declare -A ARRAY_2
for i in "${ARRAY_1[@]}"
do
	ARRAY_2["$i"]=1
done

OUTPUT2=$($ORACLE_HOME/bin/sqlplus -S REM01/$1 <<-EOF
SET HEADING OFF FEEDBACK OFF SERVEROUTPUT ON TRIMOUT ON PAGESIZE 0
SELECT USUARIOCREAR
FROM REM01.MIG2_USUARIOCREAR_CARTERIZADO 
WHERE UPPER(USUARIOCREAR) LIKE UPPER('%$2%');
/
EOF
)

usuario=$(echo $OUTPUT2 | awk '{ print $1 }')

echo "##############################################################################"
echo "#####	[INICIO]"
echo "##############################################################################"
echo "     	[INFO] Se copiarán las tablas de migración de "$usuario
echo "##############################################################################"

if [ "$usuario" == "MIG_LIBERBANK" ] || [ "$usuario" == "MIG_COOPER" ]; then
	if [ "$usuario" == "MIG_LIBERBANK" ]; then
		sufijo="_LI"
	elif [ "$usuario" == "MIG_COOPER" ]; then 
		sufijo="_CO"
	fi

	for i in ${!ARRAY_2[@]}
	do
		echo "------------------------------------------------------------------------------"
		echo "-----	[INFO]  Proceso de copiado de tabla "$i
		echo "------------------------------------------------------------------------------"
		script=$ruta_tmp$nombre_fichero"_"$i$sufijo.sql
		sed "s/#TABLA_COPIADA#/$i/g" $ruta_original | sed "s/#SUFIJO#/$sufijo/g" > $script
		$ORACLE_HOME/bin/sqlplus REM01/$1 @$script
		if [ $? != 0 ] ; then 
			echo -e "\n\n======>>> "Error en @"$script"
			exit 1
		fi
		echo "------------------------------------------------------------------------------"
	done

echo "##############################################################################"
echo "#####	[FIN] Tablas copiadas"
echo "##############################################################################"

else

	echo "##############################################################################"
	echo "#####	[FIN] No se copiarán tablas por ser una migración distinta de Cooper o Liberbank"
	echo "##############################################################################"

fi

exit 0