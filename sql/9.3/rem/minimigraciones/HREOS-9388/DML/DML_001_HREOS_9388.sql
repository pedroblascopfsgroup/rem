--/*
--#########################################
--## AUTOR=JOaquin Bahamonde
--## FECHA_CREACION=20200212
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9388
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
	
	V_TABLA_TMP VARCHAR2(30 CHAR) := 'TMP_ACT_CFT_CONFIG_TARIFA'; -- Variable para tabla de salida para el borrado	
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error	
	V_SQL VARCHAR2(4000 CHAR);--Sentencia a ejecutar	
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-9388';
	

BEGIN

	--Adapto los campos insertados en la temporal para luego volcarlos al tarifario
	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));	
	DBMS_OUTPUT.PUT_LINE('[INFO] PREPARANDO LOS DATOS DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_TMP||'.');

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_TMP||' TMP
				USING (
					SELECT TMP.CODIGO, TTR.DD_TTR_ID,STR.DD_STR_ID
					FROM REM01.TMP_ACT_CFT_CONFIG_TARIFA TMP
					LEFT JOIN REM01.DD_STR_SUBTIPO_TRABAJO STR ON UPPER(TMP.SUBTIPO_TRABAJO) = UPPER(STR.DD_STR_DESCRIPCION) 
					LEFT JOIN REM01.DD_TTR_TIPO_TRABAJO TTR ON STR.DD_TTR_ID = TTR.DD_TTR_ID
					WHERE TTR.DD_TTR_CODIGO NOT IN (''07'')
				) AUX
				ON (TMP.CODIGO = AUX.CODIGO) 
				WHEN MATCHED THEN UPDATE SET 
				TMP.TIPO_TRABAJO = AUX.DD_TTR_ID,
				TMP.SUBTIPO_TRABAJO = AUX.DD_STR_ID';
					
	DBMS_OUTPUT.PUT_LINE(V_SQL);
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
