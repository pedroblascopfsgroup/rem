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

	V_TABLA VARCHAR2(30 CHAR) := 'AUX_ASI_HAYA_ACTUALIZACION'; -- Variable para tabla de salida para el borrado
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_MSQL VARCHAR2(4000 CHAR);
	PL_OUTPUT VARCHAR2(32000 CHAR);

BEGIN
	
	PL_OUTPUT := '[INICIO]'||CHR(10);

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ASI_HAYA T1
		USING (
			SELECT ID_UVEM, ID_HAYA
			FROM '||V_ESQUEMA||'.'||V_TABLA||'
			) T2
		ON (T1.ACT_NUM_ACTIVO_UVEM = T2.ID_UVEM)
		WHEN MATCHED THEN UPDATE SET
			T1.ACT_NUM_ACTIVO = T2.ID_HAYA, T1.FEC_ASIGNACION = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	PL_OUTPUT := PL_OUTPUT || '[INFO] Se han actualizado '||SQL%ROWCOUNT||' filas en la tabla ACT_ASI_HAYA.'||CHR(10);

	COMMIT;

	PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);

EXCEPTION
    WHEN OTHERS THEN
      PL_OUTPUT := PL_OUTPUT ||'[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE)||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||'-----------------------------------------------------------'||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||SQLERRM||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||V_MSQL||CHR(10);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
