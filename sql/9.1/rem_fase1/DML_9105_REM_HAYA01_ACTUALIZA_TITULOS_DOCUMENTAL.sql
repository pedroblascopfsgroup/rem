--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20160412
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=0
--## PRODUCTO=SI
--##
--## Finalidad: Realiza las modificaciones necesarias para el trámite de actuación técnica.
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
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    
    
    /* ################################################################################
     ## MODIFICACIONES: Se cambia la descripcion de las tareas, eliminando LPO
     ##
     */
    
BEGIN    
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_DESCRIPCION = ''Solicitud documento por Gestor Interno'' '||
	          ' WHERE TAP_CODIGO = ''T002_SolicitudLPOGestorInterno''';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando descripción tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_DESCRIPCION = ''Obtención documento por Gestor Interno'' '||
	          ' WHERE TAP_CODIGO = ''T002_ObtencionLPOGestorInterno''';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando descripción tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_DESCRIPCION = ''Solicitud documento por gestoría'' '||
	          ' WHERE TAP_CODIGO = ''T002_SolicitudDocumentoGestoria''';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando gestor tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_DESCRIPCION = ''Obtención documento por gestoría'' '||
	          ' WHERE TAP_CODIGO = ''T002_ObtencionDocumentoGestoria''';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando gestor tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
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