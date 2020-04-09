--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200408
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6906
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
	V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-6906'; -- Incidencia Link
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
    
    DBMS_OUTPUT.put_line('[INICIO]');

    V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO T1 SET DD_SCM_ID = NULL WHERE EXISTS (
                    SELECT ACT.ACT_ID 
                    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                    JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO = ''07''
                    JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID AND DD_SCR_CODIGO IN (''150'', ''151'', ''152'')
                    WHERE T1.ACT_ID = ACT.ACT_ID
                )';
    EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.put_line('[INFO] Se va a lanzar el SP de recálculo de situación comercial para '||SQL%ROWCOUNT||' activos de Divarian.');
    COMMIT;
    
    V_SQL := 'CALL '||V_ESQUEMA||'.SP_ASC_ACT_SIT_COM_VACIOS_V2 (0)';
    EXECUTE IMMEDIATE V_SQL;
    
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
