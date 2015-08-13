--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20150812
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-478
--## PRODUCTO=NO
--##
--## Finalidad: Modificación trámite hipotecario
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN	
	
	
	/* ------------------- -------------------------- */
	/* --------------  ACTUALIZACIONES --------------- */
	/* ------------------- -------------------------- */
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = ''plugin/procedimientos-bpmHaya-plugin/tramiteDePosesion/confirmarNotificacionDeudor'' WHERE TAP_CODIGO = ''H015_ConfirmarNotificacionDeudor''';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = ''plugin/procedimientos-bpmHaya-plugin/tramiteDePosesion/solicitarAlquilerSocial'' WHERE TAP_CODIGO = ''H015_SolicitarAlquilerSocial''';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = ''plugin/procedimientos-bpmHaya-plugin/tramiteDePosesion/formalizacionAlquilerSocial'' WHERE TAP_CODIGO = ''H015_FormalizacionAlquilerSocial''';
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ERROR_VALIDACION = ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', TFI_VALIDACION = ''valor != null && valor != '''''''' ? true : false'' WHERE TFI_NOMBRE = ''comboNotificado'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H015_ConfirmarNotificacionDeudor'')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ERROR_VALIDACION = ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', TFI_VALIDACION = ''valor != null && valor != '''''''' ? true : false'' WHERE TFI_NOMBRE = ''fechaSenyalamiento'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H015_PresentarSolicitudSenyalamientoPosesion'')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ERROR_VALIDACION = ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', TFI_VALIDACION = ''valor != null && valor != '''''''' ? true : false'' WHERE TFI_NOMBRE = ''gestionSolicitada'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H015_SolicitarAlquilerSocial'')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ERROR_VALIDACION = ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', TFI_VALIDACION = ''valor != null && valor != '''''''' ? true : false'' WHERE TFI_NOMBRE = ''alquilerFormalizado'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H015_FormalizacionAlquilerSocial'')';
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = ''valores[''''H015_RegistrarSenyalamientoLanzamiento''''] && valores[''''H015_RegistrarSenyalamientoLanzamiento''''][''''fecha''''] != null ? damePlazo(valores[''''H015_RegistrarSenyalamientoLanzamiento''''][''''fecha'''']) - 2*24*60*60*1000L : 15*24*60*60*1000L'' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H015_FormalizacionAlquilerSocial'')';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = ''valores[''''H015_RegistrarSenyalamientoLanzamiento''''] && valores[''''H015_RegistrarSenyalamientoLanzamiento''''][''''fecha''''] != null ? damePlazo(valores[''''H015_RegistrarSenyalamientoLanzamiento''''][''''fecha'''']) - 1*24*60*60*1000L : 1*24*60*60*1000L'' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H015_SuspensionLanzamiento'')';
	
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
