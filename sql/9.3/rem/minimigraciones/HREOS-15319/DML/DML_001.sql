--/*
--#########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210721
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15319
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
	
	V_TABLA_TMP VARCHAR2(30 CHAR) := 'APR_AUX_HREOS_15319'; -- Variable para tabla de salida para el borrado	
	V_TABLA VARCHAR2(30 CHAR) := 'ACT_PVE_PROVEEDOR'; -- Variable para tabla de salida para el borrado	
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error	
	V_SQL VARCHAR2(4000 CHAR);--Sentencia a ejecutar	
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-15319';
	
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));
	DBMS_OUTPUT.PUT_LINE('[INFO] FUSIONANDO LOS DATOS DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_TMP||' EN LA TABLA '||V_TABLA||'');

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_TMP||'
				(COD_BANKIA
				, NOMBRE_BANKIA
				, COD_CAIXABANK
				, NOMBRE_CAIXABANK)
				SELECT 
				NULL
				, NULL
				, LPAD(COD_CAIXABANK, 4, ''0'') COD_CAIXABANK
				, ''Caixa - Oficina '' || LPAD(COD_CAIXABANK, 4, ''0'') NOMBRE_CAIXABANK
				FROM (SELECT MIN_A - 1 + LEVEL COD_CAIXABANK
				FROM (SELECT 
				MIN(1) MIN_A
				, MAX(9999) MAX_A
				FROM DUAL)
				CONNECT BY LEVEL <= MAX_A - MIN_A + 1
				MINUS
				SELECT TO_NUMBER(AUX.COD_CAIXABANK) 
				FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' AUX)';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
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
