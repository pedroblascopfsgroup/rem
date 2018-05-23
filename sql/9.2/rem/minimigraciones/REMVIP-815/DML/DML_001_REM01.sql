--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180521
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=?
--## INCIDENCIA_LINK=REMVIP-XYZ
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

	V_TABLA VARCHAR2(30 CHAR) := 'AUX_FECHA_INS'; -- Variable para tabla de salida para el borrado
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USUARIO VARCHAR2(25 CHAR) := 'REMVIP-815';
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_MSQL VARCHAR2(4000 CHAR);
	PL_OUTPUT VARCHAR2(32000 CHAR);

BEGIN
	
	PL_OUTPUT := '[INICIO]'||CHR(10);

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TIT_TITULO T1
		USING (SELECT ACT.ACT_ID, TO_DATE(AUX.FECHA_INS,''DD/MM/YYYY'') FECHA_INS
				, ROW_NUMBER() OVER(PARTITION BY ACT.ACT_ID ORDER BY TO_DATE(AUX.FECHA_INS,''DD/MM/YYYY'') DESC) RN
			FROM PFSREM.'||V_TABLA||' AUX
			JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ID_HAYA
			JOIN PFSREM.AUX_GIANTS_REL_ACTIVOS REL ON REL.NEW_ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
			WHERE ACT.BORRADO = 0
			) T2
		ON (T1.ACT_ID = T2.ACT_ID AND T2.RN = 1)
		WHEN MATCHED THEN UPDATE SET
			T1.TIT_FECHA_INSC_REG = T2.FECHA_INS
			, T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	PL_OUTPUT := PL_OUTPUT || '[INFO] Se han actualizado '||SQL%ROWCOUNT||' filas en la tabla ACT_TIT_TITULO (TIT_FECHA_INSC_REG).'||CHR(10);

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
