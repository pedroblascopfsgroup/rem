--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190323
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.20
--## INCIDENCIA_LINK=REMVIP-3730
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_SQL VARCHAR2(20000 CHAR);
    TABLE_COUNT NUMBER(1,0) := 0;
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso...'); 
    
    V_SQL :=   'MERGE INTO '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA T1
				USING (
					SELECT ADM.ADM_ID,
						   ACT.ACT_ID,
						   CASE WHEN AUX.ADM_FECHA_CALIFICACION IS NULL OR
									 AUX.ADM_FECHA_CALIFICACION = 0 THEN NULL
								ELSE TO_DATE(AUX.ADM_FECHA_CALIFICACION,''YYYYMMDD'') END                                 			AS ADM_FECHA_CALIFICACION,
						   AUX.ADM_NUM_EXPEDIENTE                                                                         			AS ADM_NUM_EXPEDIENTE,
						   (SELECT DD_TVP_ID FROM '||V_ESQUEMA||'.DD_TVP_TIPO_VPO WHERE DD_TVP_CODIGO = LPAD(AUX.TIPO_VPO,2,''0'')) AS DD_TVP_ID
									  
					FROM '||V_ESQUEMA||'.AUX_MMC_REMVIP_3728          AUX
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO                   ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUMERO_ACTIVO
					JOIN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA   ADM ON ADM.ACT_ID = ACT.ACT_ID
				) T2
				ON (T1.ADM_ID = T2.ADM_ID AND T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.ADM_FECHA_CALIFICACION = T2.ADM_FECHA_CALIFICACION,
					T1.ADM_NUM_EXPEDIENTE = T2.ADM_NUM_EXPEDIENTE,
					T1.DD_TVP_ID = T2.DD_TVP_ID,
					T1.USUARIOMODIFICAR = ''REMVIP-3728'',
					T1.FECHAMODIFICAR = SYSDATE
	';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros. En la ACT_ADM_INF_ADMINISTRATIVA.'); 
	

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN]');


EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT
