--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20160408
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=0
--## PRODUCTO=SI
--##
--## Finalidad: Realiza las modificaciones necesarias para el trámite de obtención de documento.
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
    
    
    
    /* ##############################################################################
     ## MODIFICACIONES: Se cambian las instrucciones de la tarea T002_ValidacionActuacion
     ##
     */
BEGIN    
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL =  ''<p style="margin-bottom: 10px">Antes de dar por terminada esta tarea, deberá acceder a la pestaña "documentos" del trabajo y comprobar que el documento que se ha subido a la aplicación es el que se había solicitado, haciendo constar en el campo "corrección del documento" si se corresponde con la petición realizada. En caso negativo, deberá hacer consta el motivo de la incorrección.</p><p style="margin-bottom: 10px">Tras hacer constar la fecha en que ha finalizado la tarea y la valoración que concede al proveedor, puede utilizar el campo "observaciones" para consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p><p style="margin-bottom: 10px">En el caso de que el documento sea correcto, la siguiente tarea será la de "cierre económico". En el supuesto de que el documento subido sea incorrecto, se lanzará de nuevo al proveedor la tarea de solicitud del documento.</p>'' '||
	          ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T002_ValidacionActuacion'')'||
	          ' AND TFI_NOMBRE = ''titulo'' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando instrucciones de la tarea.......');
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