--/*
--#########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20220223
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17166
--## PRODUCTO=NO
--## 
--## Finalidad: MODIFICA EL ID EXTERNO.
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	
	V_TABLA_TMP VARCHAR2(50 CHAR) := 'AUX_HREOS_17166'; -- Variable para tabla 	
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_MSQL VARCHAR2(4000 CHAR);--Variable para consultar la existencia de registros en la tabla
	V_SQL VARCHAR2(4000 CHAR);--Sentencia a ejecutar
	V_NUM NUMBER(16); --Variable para comprobar si existen registros
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-17166';
	

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));		   


        V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_CRG_CARGAS CRG USING(
		SELECT CRG.CRG_ID, AUX.NUEVO_IDENTIFICADOR FROM '||V_ESQUEMA||'.ACT_CRG_CARGAS CRG 
		JOIN '||V_ESQUEMA||'.AUX_HREOS_17166 AUX ON AUX.ANTIGUO_IDENTIFICADOR = CRG.CRG_ID_EXTERNO
		) AUX ON (AUX.CRG_ID = CRG.CRG_ID)
		WHEN MATCHED THEN UPDATE SET
		CRG.CRG_ID_EXTERNO = AUX.NUEVO_IDENTIFICADOR,
		CRG.USUARIOMODIFICAR = ''HREOS-17166'',
		CRG.FECHAMODIFICAR = SYSDATE';


			EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se han modificado '||SQL%ROWCOUNT||' registros');  
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
