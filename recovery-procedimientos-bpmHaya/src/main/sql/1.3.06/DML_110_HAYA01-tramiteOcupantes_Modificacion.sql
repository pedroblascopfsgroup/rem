/*
--######################################################################
--## Author: Nacho
--## BPM: T. Ocupantes (H048) - modificación del BPM
--## Finalidad: Modificación del BPM
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    
    
    
BEGIN
	
	--HR-530
	V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_VALIDACION_JBPM = ''(valores[''''H048_ConfirmarVista''''][''''comboVista''''] == DDSiNo.SI && valores[''''H048_ConfirmarVista''''][''''fechaVista''''] == null) ? ''''Debe rellenar el campo "Fecha vista"'''' : null'' '
				|| ' WHERE TAP_CODIGO = ''H048_ConfirmarVista'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-514
	V_MSQL := 'UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS '
				|| ' SET DD_PTP_PLAZO_SCRIPT = ''3*24*60*60*1000L'' '
				|| ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H048_TrasladoDocuDeteccionOcupantes'') ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_LABEL = ''Fecha de la vista'' '
 				|| ' WHERE TFI_NOMBRE = ''fechaResolucion'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H048_RegistrarCelebracionVista'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
     --HR-529  
      V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_ERROR_VALIDACION = ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', '
				|| ' TFI_VALIDACION = ''valor != null && valor != '''''''' ? true : false'' '
 				|| ' WHERE TFI_NOMBRE = ''fechaPresentacion'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H048_PresentarEscritoAlegaciones'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-527  
      V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_ERROR_VALIDACION = ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', '
				|| ' TFI_VALIDACION = ''valor != null && valor != '''''''' ? true : false'' '
 				|| ' WHERE TFI_NOMBRE = ''fechaSolicitud'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H048_SolicitudRequerimientoDocOcupantes'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-525  
      V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_ERROR_VALIDACION = ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', '
				|| ' TFI_VALIDACION = ''valor != null && valor != '''''''' ? true : false'' '
 				|| ' WHERE TFI_NOMBRE = ''fecha'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H048_RegistrarInformeSituacion'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-507  
      V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_ERROR_VALIDACION = ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', '
				|| ' TFI_VALIDACION = ''valor != null && valor != '''''''' ? true : false'' '
 				|| ' WHERE TFI_NOMBRE = ''fechaResolucion'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H048_RegistrarResolucion'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-509  
      V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_ERROR_VALIDACION = ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', '
				|| ' TFI_VALIDACION = ''valor != null && valor != '''''''' ? true : false'' '
 				|| ' WHERE TFI_NOMBRE = ''fechaResolucion'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H048_ResolucionFirme'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-528  
      V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_ERROR_VALIDACION = ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', '
				|| ' TFI_VALIDACION = ''valor != null && valor != '''''''' ? true : false'' '
 				|| ' WHERE TFI_NOMBRE = ''comboOcupado'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H048_RegistrarRecepcionDoc'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_ERROR_VALIDACION = ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', '
				|| ' TFI_VALIDACION = ''valor != null && valor != '''''''' ? true : false'' '
 				|| ' WHERE TFI_NOMBRE = ''comboDocumentacion'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H048_RegistrarRecepcionDoc'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_ERROR_VALIDACION = ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', '
				|| ' TFI_VALIDACION = ''valor != null && valor != '''''''' ? true : false'' '
 				|| ' WHERE TFI_NOMBRE = ''comboInquilino'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H048_RegistrarRecepcionDoc'')';
 
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