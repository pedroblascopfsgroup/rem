--/*
--#########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210208
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14471
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	
	V_TABLA_TMP VARCHAR2(30 CHAR) := 'APR_AUX_HREOS_14471'; -- Variable para tabla de salida para el borrado	
	V_TABLA VARCHAR2(30 CHAR) := 'ACT_ASI_HAYA'; -- Variable para tabla de salida para el borrado	
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error	
	V_SQL VARCHAR2(4000 CHAR);--Sentencia a ejecutar	
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-14471';
	
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));
	DBMS_OUTPUT.PUT_LINE('[INFO] FUSIONANDO LOS DATOS DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_TMP||' EN LA TABLA '||V_TABLA||'');

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
		USING (
			SELECT TMP.ID_HAYA ACT_NUM_ACTIVO, TMP.ID_CAIXA
			FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP
		) T2
		ON (T1.ACT_NUM_ACTIVO = T2.ACT_NUM_ACTIVO)
		WHEN MATCHED THEN
			UPDATE SET T1.ACT_NUM_ACTIVO_CAIXA = T2.ID_CAIXA
				, T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
				, T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han fusionado un total de '||SQL%ROWCOUNT||' filas de la tabla '||V_TABLA);
	
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTAMOS EN '||V_ESQUEMA||'.'||V_TABLA||' LOS ACTIVOS QUE NO ESTÉN Y YA ESTÉN DADOS DE ALTA EN REM');
	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
			(
			ACT_NUM_ACTIVO_CAIXA
			, ACT_NUM_ACTIVO_UVEM
			, ACT_NUM_ACTIVO
			, FEC_ASIGNACION
			, FEC_ALTA_ACTIVO
			, USUARIOCREAR
			, FECHACREAR
			)
			SELECT 
			ACT.ACT_NUM_ACTIVO_CAIXA
			, ACT.ACT_NUM_ACTIVO_UVEM
			, ACT.ACT_NUM_ACTIVO
			, SYSDATE FEC_ASIGNACION
			, SYSDATE FEC_ALTA_ACTIVO
			, '''||V_USUARIO||''' USUARIOCREAR
			, SYSDATE FECHACREAR
			FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
			WHERE ACT.BORRADO = 0
			AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
			AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA||' ASI WHERE ASI.ACT_NUM_ACTIVO_CAIXA = ACT.ACT_NUM_ACTIVO_CAIXA)';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Insertados '||SQL%ROWCOUNT||' filas en '||V_TABLA);
	
	DBMS_OUTPUT.PUT_LINE('[INFO] BORRAMOS REGISTROS DEL '||V_ESQUEMA||'.'||V_TABLA||' POR NO EXISTIR EN '||V_ESQUEMA||'.'||V_TABLA_TMP||'');
	V_SQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA||' T1 WHERE NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP WHERE TMP.ID_CAIXA = T1.ACT_NUM_ACTIVO_CAIXA)';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han fusionado un total de '||SQL%ROWCOUNT||' filas de la tabla '||V_TABLA);

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
