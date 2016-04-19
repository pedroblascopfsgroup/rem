--/*
--##########################################
--## AUTOR=CARLOS GIL GIMENO
--## FECHA_CREACION=20160413
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.3
--## INCIDENCIA_LINK=PRODUCTO-1241
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	

	
	V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.DD_EPI_EST_POL_ITINERARIO SET DD_EPI_ORDEN = 1   WHERE DD_EPI_CODIGO = ''PRE'' ';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[FIN] DD_EPI_EST_POL_ITINERARIO PRE actualizado');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.DD_EPI_EST_POL_ITINERARIO SET DD_EPI_ORDEN = 2   WHERE DD_EPI_CODIGO = ''CE'' ';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[FIN] DD_EPI_EST_POL_ITINERARIO CE actualizado');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.DD_EPI_EST_POL_ITINERARIO SET DD_EPI_ORDEN = 3   WHERE DD_EPI_CODIGO = ''RE'' ';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[FIN] DD_EPI_EST_POL_ITINERARIO RE actualizado');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.DD_EPI_EST_POL_ITINERARIO SET DD_EPI_ORDEN = 4   WHERE DD_EPI_CODIGO = ''DC'' ';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[FIN] DD_EPI_EST_POL_ITINERARIO DC actualizado');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.DD_EPI_EST_POL_ITINERARIO SET DD_EPI_ORDEN = 5   WHERE DD_EPI_CODIGO = ''VIG'' ';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[FIN] DD_EPI_EST_POL_ITINERARIO VIG actualizado');
	
	COMMIT;
 
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
