--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190402
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.20
--## INCIDENCIA_LINK=REMVIP-3847
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
    
    V_SQL :=   'MERGE INTO '||V_ESQUEMA||'.OKU_DEMANDA_OCUPACION_ILEGAL T1
				USING (
					SELECT DISTINCT
					       ACT.ACT_NUM_ACTIVO, 
						   ACT.ACT_ID,
						   OKU.OKU_ID,
						   AUX.*
					FROM '||V_ESQUEMA||'.AUX_MMC_REMVIP_3847_1                AUX
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO                           ACT ON AUX.ID_ACTIVO_HAYA = ACT.ACT_NUM_ACTIVO
					LEFT JOIN '||V_ESQUEMA||'.OKU_DEMANDA_OCUPACION_ILEGAL    OKU ON OKU.ACT_ID = ACT.ACT_ID
					WHERE ACT.USUARIOCREAR = ''MIG_APPLE''
				) T2
				ON (T1.OKU_ID = T2.OKU_ID AND T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET
						T1.OKU_NUM_ASUNTO = T2.ASUNTO,
						T1.OKU_FECHA_INICIO_ASUNTO = TO_DATE(T2.FECHA_INICIO_ASUNTO,''YYYY-MM-DD''),
						T1.OKU_FECHA_FIN_ASUNTO = TO_DATE(T2.FECHA_FIN_ASUNTO,''YYYY-MM-DD''),
						T1.OKU_FECHA_LANZAMIENTO = TO_DATE(T2.FECHA_LANZAMIENTO,''YYYY-MM-DD''),
						T1.DD_TAO_ID = CASE WHEN TIPO_ASUNTO = ''Terminado'' THEN (SELECT DD_TAO_ID FROM '||V_ESQUEMA||'.DD_TAO_OKU_TIPO_ASUNTO WHERE DD_TAO_CODIGO = ''10'')
											WHEN TIPO_ASUNTO = ''Preparando demanda'' THEN (SELECT DD_TAO_ID FROM '||V_ESQUEMA||'.DD_TAO_OKU_TIPO_ASUNTO WHERE DD_TAO_CODIGO = ''2'')
											ELSE NULL
									   END,
						T1.DD_TCO_ID = (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_OKU_TIPO_ACTUACION WHERE DD_TCO_CODIGO = ''04''),
						T1.USUARIOMODIFICAR = ''MIG_APPLE_POST'',
						T1.FECHAMODIFICAR = SYSDATE
				WHEN NOT MATCHED THEN
				INSERT (T1.OKU_ID, T1.ACT_ID, T1.OKU_NUM_ASUNTO, T1.OKU_FECHA_INICIO_ASUNTO, T1.OKU_FECHA_FIN_ASUNTO, T1.OKU_FECHA_LANZAMIENTO, T1.DD_TAO_ID, T1.DD_TCO_ID, T1.USUARIOCREAR, T1.FECHACREAR, T1.BORRADO)
				VALUES (
						'||V_ESQUEMA||'.S_OKU_DEMANDA_OCUPACION_ILEGAL.NEXTVAL,
						T2.ACT_ID,
						T2.ASUNTO,
						TO_DATE(T2.FECHA_INICIO_ASUNTO,''YYYY-MM-DD''),
						TO_DATE(T2.FECHA_FIN_ASUNTO,''YYYY-MM-DD''),
						TO_DATE(T2.FECHA_LANZAMIENTO,''YYYY-MM-DD''),
						CASE WHEN TIPO_ASUNTO = ''Terminado'' THEN (SELECT DD_TAO_ID FROM '||V_ESQUEMA||'.DD_TAO_OKU_TIPO_ASUNTO WHERE DD_TAO_CODIGO = ''10'')
							 WHEN TIPO_ASUNTO = ''Preparando demanda'' THEN (SELECT DD_TAO_ID FROM '||V_ESQUEMA||'.DD_TAO_OKU_TIPO_ASUNTO WHERE DD_TAO_CODIGO = ''2'')
							 ELSE NULL
						END,
						(SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_OKU_TIPO_ACTUACION WHERE DD_TCO_CODIGO = ''04''),
						''MIG_APPLE_POST'',
						SYSDATE,
						0
				)
	';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado/insertado '||SQL%ROWCOUNT||' registros con la info. suministrada. En la OKU_DEMANDA_OCUPACION_ILEGAL.'); 
	
	
	V_SQL :=   'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1
				USING (
					SELECT ACT_NUM_ACTIVO,
						   ACT.ACT_ID
					FROM '||V_ESQUEMA||'.AUX_MMC_REMVIP_3847_2    AUX
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO               ACT ON AUX.ID_ACTIVO_HAYA = ACT.ACT_NUM_ACTIVO
					WHERE ACT.USUARIOCREAR = ''MIG_APPLE''
				) T2
				ON (T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.ACT_ACTIVO_DEMANDA_AFECT_COM = 1,
					T1.USUARIOMODIFICAR = ''MIG_APPLE_POST'',
					T1.FECHAMODIFICAR = SYSDATE
	';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se ha actualizado el campo ACT_ACTIVO_DEMANDA_AFECT_COM de '||SQL%ROWCOUNT||' activos. En la ACT_ACTIVO.');


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
