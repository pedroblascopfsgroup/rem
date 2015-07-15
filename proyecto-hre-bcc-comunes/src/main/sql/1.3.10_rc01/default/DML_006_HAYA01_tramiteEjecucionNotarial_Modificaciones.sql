--######################################################################
--## Author: Nacho
--## BPM: T. Ejecución Notarial (H036)
--## Finalidad: modificación de datos en tablas de configuración del BPM
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
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
    
BEGIN
	--HR-577   
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET DD_STA_ID = (SELECT DD_STA_ID FROM '|| V_ESQUEMA_MASTER ||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''800'' ), '
				|| ' DD_TSUP_ID = (SELECT DD_TGE_ID FROM '|| V_ESQUEMA_MASTER ||'.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO=''DUCL'' ) '
				|| ' WHERE TAP_CODIGO = ''H036_PrepararInformeSubasta'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;  
    
     V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET DD_STA_ID = (SELECT DD_STA_ID FROM  '|| V_ESQUEMA_MASTER ||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''815'' ), '
				|| ' DD_TSUP_ID = (SELECT DD_TGE_ID FROM '|| V_ESQUEMA_MASTER ||'.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO=''DUCL'' ) '
				|| ' WHERE TAP_CODIGO = ''H036_ValidarPropuesta'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
    
    --HR-671 HR-664
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_VALIDACION = ''!comprobarBienesAsociadoPrc() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom:10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea, deber&aacute; registrar al menos un bien, para ello debe acceder a la pesta&ntilde;a Bienes.</p></div>'''': (comprobarExisteDocumentoADS() ? (comprobarExisteDocumentoBOP() ? null : ''''Es necesario adjuntar el documento Bolet&iacute;n Oficial Propiedad'''' ) : ''''Es necesario adjuntar el documento Auto declarando subasta'''' ) '' '
				|| ' WHERE TAP_CODIGO = ''H036_registrarAnuncioSubasta'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
    
    --HR-489
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_VALIDACION = ''valor != null && valor != '''''''' ? true : false'', '
				|| ' TFI_ERROR_VALIDACION = ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'' '
				|| ' WHERE TFI_NOMBRE = ''nuevoDomicilioDeudor'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H036_registrarRecepcionCertCargas'') ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
     V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_VALIDACION = ''valor != null && valor != '''''''' ? true : false'', '
				|| ' TFI_ERROR_VALIDACION = ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'' '
				|| ' WHERE TFI_NOMBRE = ''nuevoPropietario'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H036_registrarRecepcionCertCargas'') ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_VALIDACION = ''valor != null && valor != '''''''' ? true : false'', '
				|| ' TFI_ERROR_VALIDACION = ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'' '
				|| ' WHERE TFI_NOMBRE = ''nuevoDomicilioPropietario'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H036_registrarRecepcionCertCargas'') ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_VIEW = ''plugin/procedimientos-bpmHaya/tramiteEjecucionNotarial/registrarRecepcionCertCargas'' '
				|| ' WHERE TAP_CODIGO = ''H036_registrarRecepcionCertCargas'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
    
    --HR-492
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_DECISION = ''(valores[''''H036_registrarNotificacion''''][''''comboNotificado''''] != null && valores[''''H036_registrarNotificacion''''][''''comboNotificado''''] == DDSiNo.NO) ? ''''NoSePuedeNotificar'''' : (valores[''''H036_registrarNotificacion''''][''''comboPorNotificar''''] == DDSiNo.NO ? ''''TodosNotificados'''' : ''''FaltanPorNotificar'''')'' '
				|| ' WHERE TAP_CODIGO = ''H036_registrarNotificacion'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_VALIDACION = ''valor != null && valor != '''''''' ? true : false'', '
				|| ' TFI_ERROR_VALIDACION = ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'' '
				|| ' WHERE TFI_NOMBRE = ''comboPorNotificar'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H036_registrarNotificacion'') ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_VIEW = ''plugin/procedimientos-bpmHaya/tramiteEjecucionNotarial/registrarNotificacion'' '
				|| ' WHERE TAP_CODIGO = ''H036_registrarNotificacion'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
    
    V_MSQL := 'UPDATE TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_LABEL = ''Otros titulares informados'' '
				|| ' WHERE TFI_NOMBRE = ''titularesConsignados'' AND TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H036_registrarNotificacion'') ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS '
				|| ' SET DD_PTP_PLAZO_SCRIPT = ''valores[''''H036_registrarNotificacion''''][''''fecha''''] != null ? (damePlazo(valores[''''H036_registrarNotificacion''''][''''fecha'''']) + 20*24*60*60*1000L) : (damePlazo(valores[''''H036_registrarRequerimientoAdeudor''''][''''fecha'''']) + 20*24*60*60*1000L)'' '
				|| ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H036_registrarAnuncioSubasta'') ';
 
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
    