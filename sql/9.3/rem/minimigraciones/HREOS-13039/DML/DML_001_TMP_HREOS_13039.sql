--/*
--#########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210208
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13039
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización de ID WEBCOM de las ofertas creadas por la migración de BBVA
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	
	V_TABLA_TMP VARCHAR2(30 CHAR) := 'TMP_HREOS_13039'; -- Variable para tabla de salida para el borrado	
	V_TABLA_ADJ VARCHAR2(30 CHAR) := 'ACT_AJD_ADJJUDICIAL'; -- Variable para tabla de salida para el borrado	
	V_TABLA_ADN VARCHAR2(30 CHAR) := 'ACT_ADN_ADJNOJUDICIAL'; -- Variable para tabla de salida para el borrado
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error	
	V_SQL VARCHAR2(4000 CHAR);--Sentencia a ejecutar	
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-13039';
	
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));

	V_SQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP 
	WHERE TMP.ACT_NUM_ACTIVO IN( SELECT TMP.ACT_NUM_ACTIVO
	FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = TMP.ACT_NUM_ACTIVO AND ACT.BORRADO = 0 
	GROUP BY TMP.ACT_NUM_ACTIVO HAVING COUNT(*) > 1)';
	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('[INFO]  SE HAN ELIMINADO '||SQL%ROWCOUNT||' FILAS DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_TMP||'');

	DBMS_OUTPUT.PUT_LINE('[INFO] FUSIONANDO LOS DATOS DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_TMP||' EN LA TABLA '||V_TABLA_ADJ||'');

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_ADJ||' T1
		USING (
			SELECT ADJ.AJD_ID, TMP.ID_ASUNTO
			FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP
			JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = TMP.ACT_NUM_ACTIVO AND ACT.BORRADO = 0
			JOIN '||V_ESQUEMA||'.'||V_TABLA_ADJ||' ADJ ON ACT.ACT_ID = ADJ.ACT_ID AND ADJ.BORRADO = 0
			WHERE UPPER(TMP.TIPO) IN (''LITIGIO'',''CONCURSO'')
		) T2
		ON (T1.AJD_ID = T2.AJD_ID)
		WHEN MATCHED THEN
			UPDATE SET T1.AJD_ID_ASUNTO = T2.ID_ASUNTO
				, T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
				, T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han fusionado un total de '||SQL%ROWCOUNT||' filas de la tabla '||V_TABLA_ADJ);

	DBMS_OUTPUT.PUT_LINE('[INFO] FUSIONANDO LOS DATOS DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_TMP||' EN LA TABLA '||V_TABLA_ADN||'');

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_ADN||' T1
		USING (
			SELECT ADN.ADN_ID, TMP.ID_ASUNTO
			FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP
			JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = TMP.ACT_NUM_ACTIVO AND ACT.BORRADO = 0
			JOIN '||V_ESQUEMA||'.'||V_TABLA_ADN||' ADN ON ACT.ACT_ID = ADN.ACT_ID AND ADN.BORRADO = 0
			WHERE UPPER(TMP.TIPO) IN (''DACIÓN'',''COMPRA'')
		) T2
		ON (T1.ADN_ID = T2.ADN_ID)
		WHEN MATCHED THEN
			UPDATE SET T1.ADN_ID_ASUNTO_REC = T2.ID_ASUNTO
				, T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
				, T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han fusionado un total de '||SQL%ROWCOUNT||' filas de la tabla '||V_TABLA_ADN);

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
	DBMS_OUTPUT.PUT_LINE(V_SQL);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
