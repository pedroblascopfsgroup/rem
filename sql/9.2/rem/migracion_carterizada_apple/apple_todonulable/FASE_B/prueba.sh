#!/bin/bash
##############################################################################################
#1.- Se comprueba que los parámetros de ejecución son correctos.
##############################################################################################
if [ "$#" -ne 2 ]; then
    echo "Parametros:"
    echo "$ ./borrado_FASEB.sh usuario/pass@host:puerto/ORACLE_SID USUARIO_MIGRACION"
    echo "*************************************************************************************************"
    echo "USUARIO_MIGRACION ---> MIG_SAREB, MIG_CAJAMAR, MIG_BANKIA, MIG_COOPER, MIG_LIBERBANK, MIG_APPLE"
    echo "Ejecutar desde: /migracion_carterizada_apple/FASE_B/"
    exit 1
fi

migracion_correcta=0
for resultado in $2; do
    if [[ $resultado = "MIG_"* ]] ; then 
		if [ $resultado = $2 ] ; then	
			migracion_correcta=1
	    fi
	fi
done

if [ $migracion_correcta = 1 ] ; then
    echo ""
    echo "#########################################################################"
	echo "####### [INFO] USUARIO DE LA MIGRACIÓN CORRECTO ["$2"]"
	echo "#########################################################################"

else
	echo ""
    echo "#########################################################################"
	echo "####### [ERROR] USUARIO DE LA MIGRACIÓN INCORRECTO ["$2"]"
	echo "####### [ERROR] El usuario [$2] no existe en la tabla REM01.MIG2_USUARIOCREAR_CARTERIZADO"
	echo "#########################################################################"

	exit 1
fi

hora=`date +%H:%M:%S`
inicio=`date +%s`
echo " "
echo "#########################################################################"
echo "####### [INICIO] [`date +%H:%M:%S`] Comienza el borrado (FASE_B) de $2"
echo "#########################################################################"
echo " "

$ORACLE_HOME/bin/sqlplus -S $1 << EOF
SET SERVEROUTPUT ON;
PROMPT .
PROMPT [INICIO MERGE]
MERGE INTO ACT_ACTIVO T1
USING (
    SELECT ACT_ID, ACT_NUM_ACTIVO
    FROM ACT_ACTIVO
    WHERE USUARIOCREAR = 'MIG_APPLE'
) T2
ON (T1.ACT_ID = T2.ACT_ID)
WHEN MATCHED THEN UPDATE SET
    T1.BORRADO = 1,
    T1.ACT_NUM_ACTIVO = TO_NUMBER('-'||T2.ACT_NUM_ACTIVO),
    T1.USUARIOCREAR = 'MIG_APPLE_BORRADOS';
COMMIT;
/
EOF

rm -f sqlnet.log
fin=`date +%s`
let total=($fin-$inicio)/60
echo "#########################################################################"
echo "####### [FIN] [`date +%H:%M:%S`] Borrado Fase B completada en [$total] minutos"
echo "#########################################################################"
echo " "
exit 0
