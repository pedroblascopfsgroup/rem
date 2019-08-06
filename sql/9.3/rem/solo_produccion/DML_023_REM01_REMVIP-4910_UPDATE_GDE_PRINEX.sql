--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20190731
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-4910
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
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-4910'; -- Vble. para el usuario modificar.
    V_MSQL VARCHAR2(32000 CHAR); -- Vble. auxiliar para almacenar la sentencia a ejecutar.
    V_NUM_GASTO NUMBER(16,0):= 10713308;
    V_GPV_ID NUMBER(16,0);
   	
BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    EXECUTE IMMEDIATE 'SELECT GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '||V_NUM_GASTO||'' INTO V_GPV_ID;
    IF V_GPV_ID IS NOT NULL THEN
	    V_MSQL := 'UPDATE '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO 
					SET GDE_PRINCIPAL_SUJETO = (SELECT GPL_DIARIO1_BASE FROM '||V_ESQUEMA||'.GPL_GASTOS_PRINEX_LBK WHERE GPL_DIARIO1_BASE IS NOT NULL AND GPV_ID = '||V_GPV_ID||'),
					GDE_IMP_IND_TIPO_IMPOSITIVO = (SELECT GPL_DIARIO1_TIPO FROM '||V_ESQUEMA||'.GPL_GASTOS_PRINEX_LBK WHERE GPL_DIARIO1_TIPO IS NOT NULL AND GPV_ID = '||V_GPV_ID||'),
					GDE_IMP_IND_CUOTA = (SELECT GPL_DIARIO1_CUOTA FROM '||V_ESQUEMA||'.GPL_GASTOS_PRINEX_LBK WHERE GPL_DIARIO1_CUOTA IS NOT NULL AND GPV_ID = '||V_GPV_ID||'),
					USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||''', FECHAMODIFICAR = SYSDATE
					WHERE GPV_ID = '||V_GPV_ID||'';
		EXECUTE IMMEDIATE V_MSQL;	
	    DBMS_OUTPUT.PUT_LINE('[FIN]');
	    COMMIT;
 	END IF;
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
