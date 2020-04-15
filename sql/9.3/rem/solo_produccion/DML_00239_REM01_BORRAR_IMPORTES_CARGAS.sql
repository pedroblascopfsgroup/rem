--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200410
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6929
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-6929'; -- Incidencia Link
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
    
    DBMS_OUTPUT.put_line('[INICIO]');

	V_SQL := 'UPDATE '||V_ESQUEMA||'.BIE_CAR_CARGAS BIE
				SET BIE_CAR_IMPORTE_ECONOMICO = 0
				    ,USUARIOMODIFICAR = '''||V_USUARIO||'''
				    ,FECHAMODIFICAR = SYSDATE
				WHERE EXISTS (
				    SELECT CRG.BIE_CAR_ID
				    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
				    JOIN '||V_ESQUEMA||'.ACT_CRG_CARGAS CRG ON CRG.ACT_ID = ACT.ACT_ID
				    JOIN '||V_ESQUEMA||'.DD_TCA_TIPO_CARGA TCA ON TCA.DD_TCA_ID = CRG.DD_TCA_ID AND TCA.DD_TCA_CODIGO IN (''REG'', ''REGECO'')
				    JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO = ''07''
				    JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID AND SCR.DD_SCR_CODIGO IN (''151'', ''152'')
				    WHERE BIE.BIE_CAR_ID = CRG.BIE_CAR_ID
				)';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.put_line('	[INFO] Se han borrado '||SQL%ROWCOUNT||' importes económicos de cargas de Divarian.');

    COMMIT;
    DBMS_OUTPUT.put_line('[FIN]');
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;