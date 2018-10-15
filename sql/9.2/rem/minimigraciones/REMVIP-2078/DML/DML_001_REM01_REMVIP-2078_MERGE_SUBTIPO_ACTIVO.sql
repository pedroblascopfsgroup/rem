--/*
--######################################### 
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180927
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-2078
--## PRODUCTO=NO
--## 
--## Finalidad: MERGE de tabla temporal para el subtipo de activo
--##                    
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial SOG
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

V_SQL VARCHAR2(4000 CHAR);
TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
V_TABLESPACE_IDX VARCHAR2(30 CHAR) := '#TABLESPACE_INDEX#';
V_TABLA_TMP VARCHAR2(40 CHAR) := 'TMP_UPD_SUBTIPOS_LBK';
V_TABLA_ACT VARCHAR2(40 CHAR) := 'ACT_ACTIVO';
V_TABLA_SAC VARCHAR2(40 CHAR) := 'DD_SAC_SUBTIPO_ACTIVO';

BEGIN


	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_ACT||' T1
			USING(
				SELECT 
				ACT.ACT_ID
				, SAC.DD_SAC_ID
				FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP
				JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON ACT.ACT_NUM_ACTIVO = TMP.ACT_NUM_ACTIVO
				JOIN '||V_ESQUEMA||'.'||V_TABLA_SAC||' SAC ON SAC.DD_SAC_DESCRIPCION = TMP.DD_SAC_DESCRIPCION) T2
			ON (T1.ACT_ID = T2.ACT_ID)
			WHEN MATCHED THEN UPDATE SET
			T1.DD_SAC_ID = T2.DD_SAC_ID,
			T1.USUARIOMODIFICAR = ''REMVIP-2078'',
			T1.FECHAMODIFICAR = SYSDATE';
			
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('MERGEADOS '||SQL%ROWCOUNT||' REGISTROS EN LA TABLA '||V_TABLA_ACT);
	
	
	COMMIT;	  
 


EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;
