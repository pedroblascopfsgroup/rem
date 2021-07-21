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
	
	V_TABLA_TMP VARCHAR2(30 CHAR) := 'APR_AUX_HREOS_14718'; -- Variable para tabla de salida para el borrado	
	V_TABLA VARCHAR2(30 CHAR) := 'ACT_ACTIVO'; -- Variable para tabla de salida para el borrado	
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error	
	V_SQL VARCHAR2(4000 CHAR);--Sentencia a ejecutar	
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-14718';
	
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));
	DBMS_OUTPUT.PUT_LINE('[INFO] FUSIONANDO LOS DATOS DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_TMP||' EN LA TABLA '||V_TABLA||'');

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' ACT
				USING(
					SELECT
					ACT.ACT_ID
					, REPLACE(AUX.ID_CAIXA,CHR(13),'''') ACT_NUM_ACTIVO_CAIXA
					, CASE 
						WHEN AUX.SOCIEDAD = ''0001'' THEN ''CBX''
						WHEN AUX.SOCIEDAD = ''0015'' THEN ''LVC''
						WHEN AUX.SOCIEDAD = ''3148'' THEN ''06''
						WHEN AUX.SOCIEDAD IN (''3143'', ''3149'') THEN ''CBX''
					END DD_SCR_CODIGO
					FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' AUX
					JOIN '||V_ESQUEMA||'.'||V_TABLA||' ACT ON ACT.ACT_NUM_ACTIVO_UVEM = AUX.ID_UVEM AND ACT.BORRADO = 0
				) AUX
				ON (ACT.ACT_ID = AUX.ACT_ID)
				WHEN MATCHED THEN
				UPDATE SET
					ACT.ACT_NUM_ACTIVO_CAIXA = AUX.ACT_NUM_ACTIVO_CAIXA
					, ACT.DD_SCR_ID = (SELECT DD_SCR_ID FROM '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = AUX.DD_SCR_CODIGO) 
					, ACT.USUARIOMODIFICAR = '''||V_USUARIO||'''
					, ACT.FECHAMODIFICAR = SYSDATE';
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
