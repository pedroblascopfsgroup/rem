ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';
--/*
--#########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200716
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7794
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-7794';

BEGIN

		DBMS_OUTPUT.PUT_LINE('[INICIO]');
        
        V_SQL := 'MERGE INTO '||V_ESQUEMA||'.BIE_VALORACIONES VAL USING(		 
    
    WITH ACTIVOS AS (
		SELECT 
			ACT.ACT_ID, 
			ACT.BIE_ID, 
			AUX.ACT_NUM_ACTIVO, 
			AUX.TAS_IMPORTE_VALOR_TASACION, 
			AUX.TAS_FECHA_FIN_TASACION, 
			AUX.TAS_F_SOL_TASACION
		FROM '||V_ESQUEMA||'.AUX_REMVIP_7794 AUX
		INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
    )
    SELECT
		  BIE.BIE_VAL_ID				BIE_VAL_ID,
		  ACT.BIE_ID                                    BIE_ID,
		  ACT.TAS_IMPORTE_VALOR_TASACION		BIE_IMPORTE_VALOR_TASACION,
		  TO_DATE(ACT.TAS_FECHA_FIN_TASACION, ''yyyymmdd'')			BIE_FECHA_VALOR_TASACION,
		  CASE WHEN ACT.TAS_F_SOL_TASACION = ''00000000'' THEN NULL ELSE TO_DATE(ACT.TAS_F_SOL_TASACION, ''yyyymmdd'')	END AS		BIE_F_SOL_TASACION
    FROM ACTIVOS ACT
    JOIN '||V_ESQUEMA||'.BIE_VALORACIONES BIE ON BIE.BIE_ID = ACT.BIE_ID
    ) AUX ON (VAL.BIE_VAL_ID = AUX.BIE_VAL_ID)
		WHEN MATCHED THEN UPDATE SET
		  VAL.BIE_IMPORTE_VALOR_TASACION = AUX.BIE_IMPORTE_VALOR_TASACION,
		  VAL.BIE_FECHA_VALOR_TASACION = AUX.BIE_FECHA_VALOR_TASACION,
		  VAL.BIE_F_SOL_TASACION = BIE_F_SOL_TASACION,
		  VAL.USUARIOMODIFICAR = ''REMVIP-7794'',
		  VAL.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han modificado en total '||SQL%ROWCOUNT||' registros en la BIE_VALORACIONES');

	V_SQL :='
	MERGE INTO '||V_ESQUEMA||'.ACT_TAS_TASACION TAS USING (
	WITH TASACIONES AS (
		SELECT DISTINCT 
			ACT.ACT_ID,
			AUX.ACT_NUM_ACTIVO,
			BIE.BIE_VAL_ID,
			AUX.TAS_CODIGO_TASA_EXTERNO,
			AUX.TAS_TIPO_TASACION,
			AUX.TAS_FECHA_INI_TASACION,
			AUX.TAS_IMPORTE_TAS_FIN,
			AUX.TAS_VALOR_MERCADO,
			AUX.TAS_CIF_TASADOR,
			AUX.TAS_FECHA_CADUCIDAD,
			AUX.TAS_CONDICIONANTE,
			AUX.TAS_ORDEN_ECO,
			AUX.TAS_PORCENTAJE_PARTICIPACION
		FROM '||V_ESQUEMA||'.AUX_REMVIP_7794 		AUX
		INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO 		ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
		INNER JOIN '||V_ESQUEMA||'.BIE_VALORACIONES BIE ON BIE.BIE_ID = ACT.BIE_ID
	)
	SELECT
		CRG.TAS_ID			TAS_ID,
		AUX.ACT_ID 											ACT_ID,
		AUX.BIE_VAL_ID 										BIE_VAL_ID,
		TTS.DD_TTS_ID 										DD_TTS_ID,
		TO_DATE(AUX.TAS_FECHA_INI_TASACION, ''yyyymmdd'')					TAS_FECHA_INI_TASACION,
		NVL(AUX.TAS_IMPORTE_TAS_FIN,AUX.TAS_VALOR_MERCADO)	TAS_IMPORTE_TAS_FIN,
		AUX.TAS_CODIGO_TASA_EXTERNO							TAS_ID_EXTERNO,
		AUX.TAS_VALOR_MERCADO								TAS_VALOR_MERCADO,
		AUX.TAS_CIF_TASADOR									TAS_CIF_TASADOR,
		TO_DATE(AUX.TAS_FECHA_CADUCIDAD, ''yyyymmdd'')							TAS_FECHA_CADUCIDAD,
		AUX.TAS_CONDICIONANTE								TAS_CONDICIONANTE,
		AUX.TAS_ORDEN_ECO									TAS_ORDEN_ECO,
		AUX.TAS_PORCENTAJE_PARTICIPACION					TAS_PORCENTAJE_PARTICIPACION
	FROM TASACIONES 						AUX
	JOIN '||V_ESQUEMA||'.BIE_VALORACIONES 				BIE_VAL ON BIE_VAL.BIE_VAL_ID = AUX.BIE_VAL_ID
	JOIN '||V_ESQUEMA||'.ACT_TAS_TASACION 		CRG 	ON CRG.BIE_VAL_ID = BIE_VAL.BIE_VAL_ID
	JOIN '||V_ESQUEMA||'.DD_TTS_TIPO_TASACION 	TTS 	ON TTS.DD_TTS_CODIGO = AUX.TAS_TIPO_TASACION) AUX ON (AUX.TAS_ID = TAS.TAS_ID)
	WHEN MATCHED THEN UPDATE SET
		TAS.DD_TTS_ID = AUX.DD_TTS_ID,
		TAS.TAS_FECHA_INI_TASACION = AUX.TAS_FECHA_INI_TASACION,
		TAS.TAS_IMPORTE_TAS_FIN = AUX.TAS_IMPORTE_TAS_FIN,
		TAS.TAS_ID_EXTERNO = AUX.TAS_ID_EXTERNO,
		TAS.TAS_VALOR_MERCADO = AUX.TAS_VALOR_MERCADO,
		TAS.TAS_CIF_TASADOR = AUX.TAS_CIF_TASADOR,
		TAS.TAS_FECHA_CADUCIDAD = AUX.TAS_FECHA_CADUCIDAD,
		TAS.TAS_CONDICIONANTE = AUX.TAS_CONDICIONANTE,
		TAS.TAS_ORDEN_ECO = AUX.TAS_ORDEN_ECO,
		TAS.TAS_PORCENTAJE_PARTICIPACION = AUX.TAS_PORCENTAJE_PARTICIPACION,
		TAS.USUARIOMODIFICAR = ''REMVIP-7794'',
		TAS.FECHAMODIFICAR = SYSDATE
	';

        EXECUTE IMMEDIATE V_SQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] Se han añadido en total '||SQL%ROWCOUNT||' registros en la ACT_TAS_TASACIONES');
		COMMIT;
		DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(V_SQL);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
