--/*
--#########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210721
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14718
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
	
	V_TABLA_TMP VARCHAR2(30 CHAR) := 'ACT_ACTIVO'; -- Variable para tabla de salida para el borrado	
	V_TABLA VARCHAR2(30 CHAR) := 'ACT_ACTIVO_CAIXA'; -- Variable para tabla de salida para el borrado	
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error	
	V_SQL VARCHAR2(4000 CHAR);--Sentencia a ejecutar	
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-14718';
	
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));
	DBMS_OUTPUT.PUT_LINE('[INFO] INICIALIZAMOS LOS ACTIVOS QUE NO EXISTAN EN '||V_ESQUEMA||'.'||V_TABLA||'');

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
			(
				CBX_ID
				, ACT_ID
				, USUARIOCREAR
				, FECHACREAR
			) 
				SELECT 
				'||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL
				, ACT.ACT_ID
				, '''||V_USUARIO||''' USUARIOCREAR
				, SYSDATE FECHACREAR
				FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' ACT 
				WHERE ACT.BORRADO = 0
				AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
				AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA||' CX WHERE CX.BORRADO = 0 AND CX.ACT_ID = ACT.ACT_ID)';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado un total de '||SQL%ROWCOUNT||' filas de la tabla '||V_TABLA);

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
