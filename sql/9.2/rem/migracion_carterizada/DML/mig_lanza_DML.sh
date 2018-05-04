#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Parametros: <usuario/pass@host:puerto/ORACLE_SID> y <USUARIO_MIGRACION> (LIBERBANK,COOPER)"
    exit
fi

OUTPUT2=$($ORACLE_HOME/bin/sqlplus -S REM01/$1 <<-EOF
SET HEADING OFF FEEDBACK OFF SERVEROUTPUT ON TRIMOUT ON PAGESIZE 0
SELECT USUARIOCREAR
FROM REM01.MIG2_USUARIOCREAR_CARTERIZADO 
WHERE UPPER(USUARIOCREAR) LIKE UPPER('%$2%');
/
EOF
)

usuario=$(echo $OUTPUT2 | awk '{ print $1 }')

fichero=DML/DMLs.list
ruta=DML/
ruta_funcional=DML/VALIDACIONES_FUNCIONALES/

if [ "$usuario" == "MIG_LIBERBANK" ]; then
	fichero_validacion="LIBERBANK.sql"
elif [ "$usuario" == "MIG_COOPER" ]; then 
	fichero_validacion="COOPER.sql"
else
	fichero_validacion="GENERICO.sql"
fi

ls --format=single-column $ruta*.sql > $fichero
ls --format=single-column $ruta_funcional*$fichero_validacion >> $fichero
echo "############################################################################################"
echo "#####	[INICIO]"
echo "############################################################################################"

while read line
do
	if [ -f "$line" ] ; then
		echo "--------------------------------------------------------------------------------------------"
		echo "-----	[INFO] $line"
		echo "--------------------------------------------------------------------------------------------"
		$ORACLE_HOME/bin/sqlplus "$1" @"$line"
		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @"$line"
		   exit 1
		fi

		echo "--------------------------------------------------------------------------------------------"
	fi
done < "$fichero"

echo "############################################################################################"
echo "##### [FIN]"
echo "############################################################################################"

exit 0
