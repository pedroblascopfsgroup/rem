--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20191011
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5414
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
   
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error;
    V_USUARIO VARCHAR2(25 CHAR) := 'REMVIP-5414';
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Borrado comités incorrectos Liberbank');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET DD_COS_ID = NULL WHERE DD_COS_ID IN (282, 283, 284, 285)';
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET DD_COS_ID_PROPUESTO = NULL WHERE DD_COS_ID_PROPUESTO IN (282, 283, 284, 285)';
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET DD_COS_ID_SUPERIOR = NULL WHERE DD_COS_ID_SUPERIOR IN (282, 283, 284, 285)';
	EXECUTE IMMEDIATE V_MSQL;

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN] Proceso finalizado correctamente');
	
EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;
/
EXIT