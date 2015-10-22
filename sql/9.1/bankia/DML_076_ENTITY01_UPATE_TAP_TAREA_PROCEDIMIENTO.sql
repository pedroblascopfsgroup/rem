--/*
--##########################################
--## AUTOR=MANUEL_MEJIAS
--## FECHA_CREACION=20151021
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hy-master
--## INCIDENCIA_LINK=HR-1359
--## PRODUCTO=SI
--##
--## Finalidad: Actualiza los campos de validacion de la tarea  PCO_PreTurnado
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	
	
    -- Modificar bpm del TPO
    V_MSQL := 'UPDATE ' || V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO' ||  q'[ SET DD_TPO_XML_JBPM='precontenciosobankia' WHERE DD_TPO_CODIGO='PCO' ]';
    DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO : ' || V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO' || ' A DD_TPO_XML_JBPM=''precontenciosobankia''');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_PreTurnado'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TAP_TAREA_PROCEDIMIENTO PCO_PreTurnado');
    	
		V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''dameTipoTurnado()'' WHERE  TAP_CODIGO = ''PCO_PreTurnado'' ';
    	EXECUTE IMMEDIATE V_SQL;
    END IF;
    
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_PrepararExpediente'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TAP_TAREA_PROCEDIMIENTO PCO_PrepararExpediente');
    	
		V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''dameTipoTurnado()'' WHERE  TAP_CODIGO = ''PCO_PrepararExpediente'' ';
    	EXECUTE IMMEDIATE V_SQL;
    END IF;
    
    
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TAP_TAREA_PROCEDIMIENTO ' );
    
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