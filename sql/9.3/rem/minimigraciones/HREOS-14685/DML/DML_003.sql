--/*
--#########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210720
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14685
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
	
	V_TABLA_TMP VARCHAR2(30 CHAR) := 'APR_AUX_HREOS_14685'; -- Variable para tabla de salida para el borrado	
	V_TABLA VARCHAR2(30 CHAR) := 'ACT_PVE_PROVEEDOR'; -- Variable para tabla de salida para el borrado	
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error	
	V_SQL VARCHAR2(4000 CHAR);--Sentencia a ejecutar	
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-14685';
	
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));
	DBMS_OUTPUT.PUT_LINE('[INFO] FUSIONANDO LOS DATOS DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_TMP||' EN LA TABLA '||V_TABLA||'');

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.DD_GRF_GESTORIA_RECEP_FICH T1
				USING (
					SELECT GRF.DD_GRF_ID, PVE.PVE_COD_UVEM
					FROM '||V_ESQUEMA||'.DD_GRF_GESTORIA_RECEP_FICH GRF
					JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_REM = GRF.PVE_COD_REM
				) T2
				ON (T1.DD_GRF_ID = T2.DD_GRF_ID)
				WHEN MATCHED THEN 
					UPDATE SET
						T1.NUCLII = T2.PVE_COD_UVEM
						, T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
						, T1.FECHAMODIFICAR = SYSDATE';
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
