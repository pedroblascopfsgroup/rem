--/*
--##########################################
--## AUTOR=NACHO ARCOS
--## FECHA_CREACION=20150901
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.5-hy
--## INCIDENCIA_LINK=HR-1042
--## PRODUCTO=NO
--##
--## Finalidad: Modificación trámite Tributacion bienes Sareb
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_COD_PROCEDIMIENTO VARCHAR (20 CHAR) := 'H054';
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    
    V_TAREA VARCHAR(30 CHAR);
    
BEGIN	
	
	
	/* ------------------- --------------------------------- */
	/* --------------  ACTUALIZACIONES TAREAS--------------- */
	/* ------------------- --------------------------------- */
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_VIEW = ''plugin/procedimientos-bpmHaya-plugin/tramiteTributacionSareb/presentarEscritoJuzgado'' ' ||
			  ' WHERE TAP_CODIGO = ''H054_PresentarEscritoJuzgado''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H054_PresentarEscritoJuzgado actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea, deber&aacute; informar de la fecha en la que ha presentado el modelo de escrito seg&uacute;n lo indicado por el Area fiscal en la tarea anterior y que viene indicado y protegido en el campo "Modelo de escrito a presentar".</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interese quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez realizada la tarea, se finalizar&aacute; el tr&aacute;mite.</p></div>'' ' ||
			  ' WHERE TFI_NOMBRE = ''titulo'' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H054_PresentarEscritoJuzgado'')';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tarea H054_PresentarEscritoJuzgado actualizada.');
 
	

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