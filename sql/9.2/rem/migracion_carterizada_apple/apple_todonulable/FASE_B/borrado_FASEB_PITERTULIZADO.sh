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
SET SERVEROUTPUT ON
SET VERIFY ON
DECLARE

	ERR_NUM NUMBER(25);  
    ERR_MSG VARCHAR2(1024 CHAR); 
    VMSQL VARCHAR2(4024 CHAR);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
		T_TIPO_DATA('REM01.ACT_APU_ACTIVO_PUBLICACION','0','',''),
		T_TIPO_DATA('REM01.ACT_AHP_HIST_PUBLICACION','0','',''),
		T_TIPO_DATA('REM01.AIN_ACTIVO_INTEGRADO','0','',''),
		T_TIPO_DATA('REM01.ACT_PTO_PRESUPUESTO','0','',''),
		T_TIPO_DATA('REM01.GAH_GESTOR_ACTIVO_HISTORICO','1','REM01.ACT_ACTIVO','ACT_ID'),
		T_TIPO_DATA('REM01.GEH_GESTOR_ENTIDAD_HIST','0','',''),
		T_TIPO_DATA('REM01.GAC_GESTOR_ADD_ACTIVO','1','REM01.ACT_ACTIVO','ACT_ID'),
		T_TIPO_DATA('REM01.GEE_GESTOR_ENTIDAD','0','',''),
		T_TIPO_DATA('REM01.ACT_AOB_ACTIVO_OBS','0','',''),
		T_TIPO_DATA('REM01.ACT_ABA_ACTIVO_BANCARIO','0','',''),
		T_TIPO_DATA('REM01.ACT_PAC_PERIMETRO_ACTIVO','0','',''),
		T_TIPO_DATA('REM01.ACT_PRP','1','REM01.ACT_ACTIVO','ACT_ID'),	
		T_TIPO_DATA('REM01.ACT_ADO_ADMISION_DOCUMENTO','0','',''),
		T_TIPO_DATA('REM01.ACT_MLV_MOVIMIENTO_LLAVE','0','',''),
		T_TIPO_DATA('REM01.ACT_LLV_LLAVE','0','',''),
		T_TIPO_DATA('REM01.ACT_CAT_CATASTRO','0','',''),
		T_TIPO_DATA('REM01.ACT_AGO_AGRUPACION_OBS','0','',''),
		T_TIPO_DATA('REM01.ACT_AGA_AGRUPACION_ACTIVO','0','',''),
		T_TIPO_DATA('REM01.ACT_ASI_ASISTIDA','1','REM01.ACT_AGA_AGRUPACION_ACTIVO','AGR_ID'),
		T_TIPO_DATA('REM01.ACT_LCO_LOTE_COMERCIAL','1','REM01.ACT_AGA_AGRUPACION_ACTIVO','AGR_ID'),
		T_TIPO_DATA('REM01.ACT_ONV_OBRA_NUEVA','1','REM01.ACT_AGA_AGRUPACION_ACTIVO','AGR_ID'),
		T_TIPO_DATA('REM01.ACT_RES_RESTRINGIDA','1','REM01.ACT_AGA_AGRUPACION_ACTIVO','AGR_ID'),
		T_TIPO_DATA('REM01.ACT_AGR_AGRUPACION','0','',''),
		T_TIPO_DATA('REM01.ACT_DIS_DISTRIBUCION','0','',''),
		T_TIPO_DATA('REM01.ACT_APR_PLAZA_APARCAMIENTO','1','REM01.ACT_ICO_INFO_COMERCIAL','ICO_ID'),
		T_TIPO_DATA('REM01.ACT_LCO_LOCAL_COMERCIAL','1','REM01.ACT_ICO_INFO_COMERCIAL','ICO_ID'),
		T_TIPO_DATA('REM01.ACT_VIV_VIVIENDA','1','REM01.ACT_ICO_INFO_COMERCIAL','ICO_ID'),
		T_TIPO_DATA('REM01.ACT_EDI_EDIFICIO','1','REM01.ACT_ICO_INFO_COMERCIAL','ICO_ID'),		
		T_TIPO_DATA('REM01.ACT_HIC_EST_INF_COMER_HIST','0','',''),
		T_TIPO_DATA('REM01.ACT_ICO_INFO_COMERCIAL','0','',''),
		T_TIPO_DATA('REM01.ACT_PAC_PROPIETARIO_ACTIVO','0','',''),
		T_TIPO_DATA('REM01.ACT_PRO_PROPIETARIO','0','',''),
		T_TIPO_DATA('REM01.ACT_TAS_TASACION','0','',''),
		T_TIPO_DATA('REM01.BIE_VALORACIONES','0','',''),
		T_TIPO_DATA('REM01.ACT_CRG_CARGAS','0','',''),
		T_TIPO_DATA('REM01.BIE_CAR_CARGAS','0','',''),
		T_TIPO_DATA('REM01.ACT_ADN_ADJNOJUDICIAL','0','',''),
		T_TIPO_DATA('REM01.ACT_AJD_ADJJUDICIAL','0','',''),
		T_TIPO_DATA('REM01.ACT_PDV_PLAN_DIN_VENTAS','0','',''),
		T_TIPO_DATA('REM01.ACT_VAL_VALORACIONES','0','',''),
		T_TIPO_DATA('REM01.ACT_TIT_TITULO','0','',''),
		T_TIPO_DATA('REM01.ACT_LOC_LOCALIZACION','0','',''),
		T_TIPO_DATA('REM01.BIE_LOCALIZACION','0','',''),
		T_TIPO_DATA('REM01.ACT_REG_INFO_REGISTRAL','0','',''),
		T_TIPO_DATA('REM01.BIE_DATOS_REGISTRALES','0','',''),
		T_TIPO_DATA('REM01.ACT_SPS_SIT_POSESORIA','0','',''),
		T_TIPO_DATA('REM01.ACT_ADM_INF_ADMINISTRATIVA','0','',''),
		T_TIPO_DATA('REM01.BIE_ADJ_ADJUDICACION','0','',''),
		T_TIPO_DATA('REM01.BIE_BIEN','0','',''),
		T_TIPO_DATA('REM01.ACT_ACTIVO','0','',''),
		T_TIPO_DATA('REM01.ACT_CPR_COM_PROPIETARIOS','0','',''),
		T_TIPO_DATA('REM01.USD_USUARIOS_DESPACHOS','0','',''),
		T_TIPO_DATA('REM01.ZON_PEF_USU','0','',''),
		T_TIPO_DATA('REMMASTER.GRU_GRUPOS_USUARIOS','0','',''),
		T_TIPO_DATA('REMMASTER.USU_USUARIOS','0','','')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('.');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP   
    
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);
		
		IF V_TMP_TIPO_DATA(2) = '0' THEN 
		
			VMSQL := 'DELETE FROM '||TRIM(V_TMP_TIPO_DATA(1))||' WHERE USUARIOCREAR = ''$2'' ';
			EXECUTE IMMEDIATE (VMSQL);
			DBMS_OUTPUT.PUT_LINE('[INFO] Se borran '||SQL%ROWCOUNT||' registros de la tabla '||TRIM(V_TMP_TIPO_DATA(1))||'.');
		
		ELSE
			
			VMSQL := 'DELETE FROM '||TRIM(V_TMP_TIPO_DATA(1))||' T1 WHERE EXISTS (SELECT 1 FROM '||TRIM(V_TMP_TIPO_DATA(3))||' T2 WHERE T1.'||TRIM(V_TMP_TIPO_DATA(4))||' = T2.'||TRIM(V_TMP_TIPO_DATA(4))||' AND T2.USUARIOCREAR = ''$2'' ) ';
			EXECUTE IMMEDIATE (VMSQL);
			DBMS_OUTPUT.PUT_LINE('[INFO] Se borran '||SQL%ROWCOUNT||' registros de la tabla '||TRIM(V_TMP_TIPO_DATA(1))||'.');
			
		END IF;
    
    END LOOP;
    
    COMMIT;
    
EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;     
    
END;
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
