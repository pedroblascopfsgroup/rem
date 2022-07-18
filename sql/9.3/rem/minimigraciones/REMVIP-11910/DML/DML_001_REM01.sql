--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220623
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11910
--## PRODUCTO=NO
--## 
--## Finalidad: MODIFICA EL DD_TDI_ID A 15 DE TODOS LOS APIS
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	
	V_TABLA VARCHAR2(50 CHAR) := 'AUX_REMVIP_11910'; -- Variable para tabla 	
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_MSQL VARCHAR2(4000 CHAR);--Variable para consultar la existencia de registros en la tabla
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-11910';
	

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));	

	DBMS_OUTPUT.PUT_LINE('[INFO] Creamos backup de los registros');    	 

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 
				USING(
					SELECT DISTINCT PVE.PVE_ID, PVE.DD_TDI_ID
					FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
					JOIN '||V_ESQUEMA||'.'||V_TABLA||' AUX ON AUX.PVE_ID = PVE.PVE_ID
					AND PVE.BORRADO = 0) T2 
				ON (T1.PVE_ID = T2.PVE_ID)
				WHEN MATCHED THEN UPDATE SET
				T1.DD_TDI_ID = T2.DD_TDI_ID';
	EXECUTE IMMEDIATE V_MSQL;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se han modificado '||SQL%ROWCOUNT||' registros');    


	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR T1 
				USING(
					SELECT DISTINCT PVE.PVE_ID
					FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
					JOIN '||V_ESQUEMA||'.'||V_TABLA||' AUX ON AUX.PVE_ID = PVE.PVE_ID
					AND PVE.BORRADO = 0) T2 
				ON (T1.PVE_ID = T2.PVE_ID)
				WHEN MATCHED THEN UPDATE SET
				T1.DD_TDI_ID = 15,
				T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
				T1.FECHACREAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se han modificado '||SQL%ROWCOUNT||' registros en tabla final');  
	COMMIT;

	PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

EXCEPTION
    WHEN OTHERS THEN
      PL_OUTPUT := PL_OUTPUT ||'[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE)||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||'-----------------------------------------------------------'||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||SQLERRM||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||V_MSQL||CHR(10);
      DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
