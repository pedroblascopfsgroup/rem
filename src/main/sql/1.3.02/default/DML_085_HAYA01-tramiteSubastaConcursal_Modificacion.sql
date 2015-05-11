/*
--######################################################################
--## Author: Nacho
--## BPM: T. Subasta Concursal (H003) - modificación del BPM
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
	
	--HR-403 / HR-404
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_DECISION = ''( (valores[''''H003_ElevarPropuestaAComite''''][''''comboResultadoComite''''] == ''''ACEPTADA'''' || valores[''''H003_ElevarPropuestaAComite''''][''''comboResultadoComite''''] == ''''ACCONCAM'''' ) ? ''''Aceptada'''' : ( valores[''''H003_ElevarPropuestaAComite''''][''''comboResultadoComite''''] == ''''MODIFICAR'''' ? ''''Modificar'''' : ''''Rechazada'''' ) )'' '
				|| ' WHERE TAP_CODIGO = ''H003_ElevarPropuestaAComite'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-414
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET DD_TPO_ID_BPM = (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''H054'') '
				|| ' WHERE TAP_CODIGO = ''H003_BPMTramiteTributacion'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-419
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_VALIDACION_JBPM = ''(valores[''''H003_CelebracionSubasta''''][''''comboCelebrada''''] == DDSiNo.NO ? (valores[''''H003_CelebracionSubasta''''][''''comboDecisionSuspension''''] == null ? ''''El campo Decisi&oacute;n suspensi&oacute;n Entidad/terceros es obligatorio'''' : null) : (valores[''''H003_CelebracionSubasta''''][''''comboCesionRemate''''] == null ? ''''El campo Cesi&oacute;n de remate es obligatorio'''' : (valores[''''H003_CelebracionSubasta''''][''''comboAdjudicadoEntidad''''] == null ? ''''El campo Adjudicado a Entidad con posibilidad de Cesi&oacute;n de remate es obligatorio'''' : null ) ) )'' '
				|| ' WHERE TAP_CODIGO = ''H003_CelebracionSubasta'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-429 - Por similitud con con incidencia HR-429 de subasta terceros
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_VALIDACION = ''comprobarMinimoBienLote() ? (comprobarExisteDocumentoESRAS() ? null : ''''Es necesario adjuntar el documento Edicto de subasta y resoluci&oacute;n acordando se&ntilde;alamiento'''') : ''''Al menos un bien debe estar asignado a un lote'''' '' '
				|| ' WHERE TAP_CODIGO = ''H003_SenyalamientoSubasta'' ';
	
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
	--HR-401
	V_MSQL := 'UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS '
				|| ' SET DD_PTP_PLAZO_SCRIPT = ''damePlazo(valores[''''H003_SenyalamientoSubasta''''][''''fechaSenyalamiento''''])-30*24*60*60*1000L'' '
 				|| ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H003_ElevarPropuestaASareb'')';	
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-407
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_ERROR_VALIDACION = ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', '
				|| ' TFI_VALIDACION = ''valor != null && valor != '''' ? true : false'' '
 				|| ' WHERE TFI_NOMBRE = ''comboRequerida'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H003_ValidarInformeDeSubastaYPrepararCuadroDePujas'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-409
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_ERROR_VALIDACION = ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', '
				|| ' TFI_VALIDACION = ''valor != null && valor != '''' ? true : false'' '
 				|| ' WHERE TFI_NOMBRE = ''comboModificacion'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H003_ValidarPropuesta'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-412 - Esto se hace por similitud con la incidencia HR-412 de subasta de terceros
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_ERROR_VALIDACION = null, '
				|| ' TFI_VALIDACION = null '
 				|| ' WHERE TFI_NOMBRE = ''comboDelegada'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H003_ValidarPropuesta'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
     --HR-399 por similitud con la HR_399  de la subasta terceros
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_ERROR_VALIDACION = null, '
				|| ' TFI_VALIDACION = null '
 				|| ' WHERE TFI_NOMBRE = ''comboDecisionSuspension'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H003_CelebracionSubasta'')';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_ERROR_VALIDACION = null, '
				|| ' TFI_VALIDACION = null '
 				|| ' WHERE TFI_NOMBRE = ''comboMotivoSuspension'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H003_CelebracionSubasta'')';
 
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