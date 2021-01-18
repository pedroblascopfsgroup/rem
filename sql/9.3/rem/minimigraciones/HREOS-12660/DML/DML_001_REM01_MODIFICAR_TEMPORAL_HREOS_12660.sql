--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210107
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12660
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizacion tarifas Divarian en la tabla ACT_CFT_CONFIG_TARIFA.
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	
	V_TABLA_TMP VARCHAR2(30 CHAR) := 'AUX_HREOS_12660'; -- Variable para tabla de salida para el borrado	
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error	
	V_SQL VARCHAR2(4000 CHAR);--Sentencia a ejecutar	
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-12660';
    V_PVE_COD_REM NUMBER(16):=10007550; --Variable para almacenar el codigo del proveedor a obtener, no viene en la excell
	

BEGIN

	--Adapto los campos insertados en la temporal para luego volcarlos al tarifario
	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));	
	DBMS_OUTPUT.PUT_LINE('[INFO] PREPARANDO LOS DATOS DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_TMP||'.');

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP
				USING (
					SELECT DISTINCT TMP2.CODIGO, TTR.DD_TTR_ID,STR.DD_STR_ID
					FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP2
					LEFT JOIN '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO STR ON TRIM(TMP2.SUBTIPO_TRABAJO)=STR.DD_STR_CODIGO 
					LEFT JOIN '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO TTR ON STR.DD_TTR_ID = TTR.DD_TTR_ID					
				) AUX
				ON (TMP.CODIGO = AUX.CODIGO) 
				WHEN MATCHED THEN UPDATE SET 
				TMP.TIPO_TRABAJO = AUX.DD_TTR_ID,
				TMP.SUBTIPO_TRABAJO = AUX.DD_STR_ID';
					
	
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han mergeado en total '||SQL%ROWCOUNT||' registros en la tabla '||V_TABLA_TMP);
	COMMIT;

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP
				USING (
					SELECT DISTINCT TMP2.CODIGO, CRA.DD_CRA_ID
					FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP2
					LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON TMP2.CARTERA=CRA.DD_CRA_CODIGO
				) AUX
				ON (TMP.CODIGO = AUX.CODIGO) 
				WHEN MATCHED THEN UPDATE SET 
				TMP.CARTERA = AUX.DD_CRA_ID';
					
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han mergeado en total '||SQL%ROWCOUNT||' registros en la tabla '||V_TABLA_TMP);
	COMMIT;

    V_SQL :='MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP
                USING (
                    SELECT DISTINCT TMP2.CODIGO,PVE.PVE_ID
                    FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP2
                    LEFT JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON TMP2.NIF_PROVEEDOR=PVE.PVE_DOCIDENTIF
                    WHERE PVE.DD_TPR_ID=(SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO=TMP2.TIPO_PROVEEDOR)
                    AND PVE_COD_REM='||V_PVE_COD_REM||'
                ) AUX
                ON (TMP.CODIGO=AUX.CODIGO)
                WHEN MATCHED THEN UPDATE SET
                TMP.NIF_PROVEEDOR=AUX.PVE_ID';

    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Se han mergeado en total '||SQL%ROWCOUNT||' registros en la tabla '||V_TABLA_TMP);
    COMMIT;
	
	PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

EXCEPTION
    WHEN OTHERS THEN
      PL_OUTPUT := PL_OUTPUT ||'[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE)||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||'-----------------------------------------------------------'||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||SQLERRM||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||V_SQL||CHR(10);
      DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
      ROLLBACK;
      RAISE;
END;
/
EXIT;