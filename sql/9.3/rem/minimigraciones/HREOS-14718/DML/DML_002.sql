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
	V_TABLA VARCHAR2(30 CHAR) := 'ACT_PAC_PROPIETARIO_ACTIVO'; -- Variable para tabla de salida para el borrado	
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
	
	V_SQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA||' PAC
			WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
					LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID AND CRA.BORRADO = 0
					WHERE ACT.ACT_ID = PAC.ACT_ID 
					AND ACT.BORRADO = 0
					AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
					AND CRA.DD_CRA_CODIGO != ''18'') AND PAC.BORRADO = 0';
					
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han borrado un total de '||SQL%ROWCOUNT||' filas de la tabla '||V_TABLA);

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' PAC
				USING(
					SELECT
					ACT.ACT_ID
					, PRO.PRO_ID
					FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' AUX
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = REPLACE(AUX.ID_CAIXA,CHR(13),'''') AND ACT.BORRADO = 0
					JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_SOCIEDAD_PAGADORA = AUX.SOCIEDAD AND AUX.SOCIEDAD NOT IN (''3143'',''3149'')
				) AUX
				ON (PAC.ACT_ID = AUX.ACT_ID)
				WHEN MATCHED THEN
				UPDATE SET
					PAC.PRO_ID = AUX.PRO_ID
					, PAC.DD_TGP_ID = (SELECT DD_TGP_ID FROM '||V_ESQUEMA||'.DD_TGP_TIPO_GRADO_PROPIEDAD WHERE DD_TGP_CODIGO = ''01'')
					, PAC.PAC_PORC_PROPIEDAD = 100
					, PAC.USUARIOMODIFICAR = '''||V_USUARIO||'''
					, PAC.FECHAMODIFICAR = SYSDATE
				WHEN NOT MATCHED THEN
				INSERT 
					(PAC_ID
					, ACT_ID
					, PRO_ID
					, DD_TGP_ID
					, PAC_PORC_PROPIEDAD
					, USUARIOCREAR
					, FECHACREAR)
					VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL	
					, AUX.ACT_ID
					, AUX.PRO_ID
					, (SELECT DD_TGP_ID FROM '||V_ESQUEMA||'.DD_TGP_TIPO_GRADO_PROPIEDAD WHERE DD_TGP_CODIGO = ''01'')
					, 100
					, '''||V_USUARIO||'''
					, SYSDATE)';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han fusionado un total de '||SQL%ROWCOUNT||' filas de la tabla '||V_TABLA);
	
	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO
				USING(
					SELECT
					DISTINCT PRO.PRO_ID
					FROM '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO
					WHERE PRO.BORRADO = 0
					AND PRO.PRO_DOCIDENTIF IN (''V84966126'',''V85164648'',''V85587434'',''V84322205'',''V84593961'',''V84669332'',''V85082675'',''V85623668''
					,''V84856319'',''V85500866'',''V85143659'',''V85594927'',''V85981231'',''V84889229'',''V84916956'',''V85160935'',''V85295087'',''V84175744''
					,''V84925569'',''V84054840'')
				) AUX
				ON (PRO.PRO_ID = AUX.PRO_ID)
				WHEN MATCHED THEN
				UPDATE SET
					PRO.DD_CRA_ID = (SELECT DD_CRA_ID FROM '|| V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''18'') 
					, PRO.USUARIOMODIFICAR = '''||V_USUARIO||'''
					, PRO.FECHAMODIFICAR = SYSDATE';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han fusionado un total de '||SQL%ROWCOUNT||' filas de la tabla ACT_PRO_PROPIETARIO para asignarles la cartera Titulizada');

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
