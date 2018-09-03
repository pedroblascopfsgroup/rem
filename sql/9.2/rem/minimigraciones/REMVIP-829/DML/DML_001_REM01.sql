--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180714
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=?
--## INCIDENCIA_LINK=REMVIP-1533
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_TABLA VARCHAR2(30 CHAR) := 'AUX_OK_TECNICO'; -- Variable para tabla de salida para el borrado
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-829';

BEGIN
	
	PL_OUTPUT := '[INICIO]'||CHR(10);
	
	V_SQL := 'MERGE INTO REM01.ACT_ACTIVO T1 
			USING REM01.AUX_OK_TECNICO T2 
			ON (T1.ACT_NUM_ACTIVO = T2.ACT_NUM_ACTIVO)
			WHEN MATCHED THEN UPDATE SET
				  T1.OK_TECNICO = NVL(T2.OK_TECNICO,0)
				, T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
				, T1.FECHAMODIFICAR = SYSDATE
		';
	
	EXECUTE IMMEDIATE V_SQL;
	
	PL_OUTPUT := PL_OUTPUT || '[INFO] Se han updateado '||SQL%ROWCOUNT||' Ok técnicos en la ACT_ACTIVO.' || CHR(10);

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
