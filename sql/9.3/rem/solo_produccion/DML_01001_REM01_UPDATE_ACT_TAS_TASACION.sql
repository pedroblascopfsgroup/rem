--/*
--#########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20211217
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16707
--## PRODUCTO=NO
--## 
--## Finalidad: Script que añade en BIE_VALORACIONES.
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	
	
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_MSQL VARCHAR2(4000 CHAR);--Variable para consultar la existencia de registros en la tabla
	V_SQL VARCHAR2(4000 CHAR);--Sentencia a ejecutar
	V_NUM NUMBER(16); --Variable para comprobar si existen registros
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-16707';
	V_NUM_ACTIVO VARCHAR2(32000 CHAR);
	

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]'||CHR(10));		

	

	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE VOLCADO SOBRE LA TABLA '||V_ESQUEMA||'.BIE_VALORACIONES');

	        V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_TAS_TASACION TAS
                        SET TAS.BORRADO = 1,
                        TAS.USUARIOBORRAR = ''HREOS-16707'',
                        TAS.FECHABORRAR = SYSDATE
                        WHERE TAS.BIE_VAL_ID IN (
                        SELECT TAS.BIE_VAL_ID
                        FROM ACT_ACTIVO ACT
                        JOIN '||V_ESQUEMA||'.BIE_VALORACIONES BIE ON BIE.BIE_ID = ACT.BIE_ID
                        JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID
                        JOIN '||V_ESQUEMA||'.ACT_TAS_TASACION TAS ON TAS.BIE_VAL_ID = BIE.BIE_VAL_ID
                        WHERE SCR.DD_SCR_CODIGO = ''70'' AND ACT.BORRADO = 0)';

			EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros');  
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
