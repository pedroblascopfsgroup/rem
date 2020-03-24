--/*
--#########################################
--## AUTOR=José Antonio Gigante
--## FECHA_CREACION=20200302
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-6331
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizacion registros 
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_TABLA_TMP VARCHAR2(100 CHAR) := 'TMP_ELIMINA_ACT_CAT_CATASTRO'; -- Variable para tabla de salida para el borrado
	V_TABLA VARCHAr(100 char) := 'ACT_CAT_CATASTRO';
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-6331';
	

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));
	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' CAT
		USING 
		( SELECT 
			ACT_ID_HAYA,
			(SELECT ACT_ID FROM ACT_ACTIVO WHERE ACT_NUM_ACTIVO = ACT_ID_HAYA and BORRADO = 0) AS ACT_ID
			FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||'
		) AUX
    	ON (AUX.ACT_ID = CAT.ACT_ID)
    	WHEN MATCHED THEN
        	UPDATE SET
				CAT.BORRADO = 1,
            	CAT.USUARIOBORRAR = '''||V_USUARIO||''',
				CAT.FECHABORRAR = SYSDATE
				WHERE CAT.BORRADO = 0
				';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros en la tabla '||V_ESQUEMA||'.'||V_TABLA||'');

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
