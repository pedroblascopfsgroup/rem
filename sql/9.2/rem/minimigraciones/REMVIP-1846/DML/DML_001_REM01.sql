--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20180917
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1846
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

	V_TABLA VARCHAR2(30 CHAR) := 'AUX_MMC_ACTIVOS_PRINEX'; -- Variable para tabla de salida para el borrado
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1846';

BEGIN
	
	PL_OUTPUT := '[INICIO]'||CHR(10);


	V_SQL := '  UPDATE '||V_ESQUEMA||'.ACT_CRG_CARGAS CRG
                SET
                    CRG.BORRADO = 1,
                    CRG.USUARIOBORRAR = '''||V_USUARIO||''',
                    CRG.FECHABORRAR = SYSDATE      
				WHERE EXISTS (
					SELECT 1
					FROM '||V_ESQUEMA||'.ACT_ACTIVO             ACT
					JOIN '||V_ESQUEMA||'.AUX_MMC_ACTIVOS_PRINEX AUX  ON AUX.ACT_NUM_ACTIVO_PRINEX = ACT.ACT_NUM_ACTIVO_PRINEX
					JOIN '||V_ESQUEMA||'.ACT_CRG_CARGAS         CRG2 ON CRG2.ACT_ID = ACT.ACT_ID
					WHERE ACT.DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''08'')
					  AND CRG.CRG_ID = CRG2.CRG_ID
				)				
	';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.put_line('[INFO] Se han borrado '||SQL%ROWCOUNT||' registros en la tabla ACT_CRG_CARGAS.');   
	
	V_SQL := '  UPDATE '||V_ESQUEMA||'.BIE_CAR_CARGAS BIE
                SET
                    BIE.BORRADO = 1,
                    BIE.USUARIOBORRAR = '''||V_USUARIO||''',
                    BIE.FECHABORRAR = SYSDATE 
				WHERE EXISTS (
					SELECT 1
					FROM '||V_ESQUEMA||'.ACT_ACTIVO             ACT
					JOIN '||V_ESQUEMA||'.AUX_MMC_ACTIVOS_PRINEX AUX  ON AUX.ACT_NUM_ACTIVO_PRINEX = ACT.ACT_NUM_ACTIVO_PRINEX
					JOIN '||V_ESQUEMA||'.BIE_CAR_CARGAS         BIE2 ON BIE2.BIE_ID = ACT.BIE_ID
					WHERE ACT.DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''08'')
					  AND BIE2.BIE_CAR_ID = BIE.BIE_CAR_ID
				)				
	';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.put_line('[INFO] Se han borrado '||SQL%ROWCOUNT||' registros en la tabla BIE_CAR_CARGAS.');  
	
	V_SQL := '  UPDATE '||V_ESQUEMA||'.ACT_ACTIVO ACT
				SET 
					 ACT.ACT_CON_CARGAS = 0,
					 ACT.USUARIOMODIFICAR = '''||V_USUARIO||''',
					 ACT.FECHAMODIFICAR = SYSDATE
				WHERE 
				EXISTS (
					 SELECT 1 
					 FROM '||V_ESQUEMA||'.ACT_ACTIVO             ACT2 
					 JOIN '||V_ESQUEMA||'.AUX_MMC_ACTIVOS_PRINEX AUX ON AUX.ACT_NUM_ACTIVO_PRINEX = ACT2.ACT_NUM_ACTIVO_PRINEX
					 WHERE ACT2.DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''08'')
					   AND ACT2.ACT_ID = ACT.ACT_ID
				)		
	';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.put_line('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros en la tabla ACT_ACTIVO.');
	
	
	
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
