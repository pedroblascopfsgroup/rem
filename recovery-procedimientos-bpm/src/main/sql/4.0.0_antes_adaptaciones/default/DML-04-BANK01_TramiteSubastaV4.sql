SET DEFINE OFF;

--ROLLBACK

delete from tfi_TareaS_form_items where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'));

delete from dd_ptp_plazos_tareas_plazas where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'));

delete from ter_Tarea_externa_recuperacion ter where ter.TEX_ID in (select tex_id from TEX_TAREA_EXTERNA where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'))); 

DELETE FROM TEV_TAREA_EXTERNA_VALOR WHERE TEX_ID IN (SELECT TEX_ID FROM TEX_TAREA_EXTERNA where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401')));

DELETE FROM TEX_TAREA_EXTERNA where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'));

DELETE from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401');

delete from tar_tareas_notificaciones where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'));

delete from prc_cex where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'));

delete from hac_historico_accesos where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'));

delete from prc_per where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'));

delete from prd_procedimientos_derivados where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'));

DELETE FROM LOB_LOTE_BIEN WHERE LOS_ID IN (SELECT LOS_ID FROM LOS_LOTE_SUBASTA WHERE SUB_ID IN (SELECT SUB_ID FROM SUB_SUBASTA WHERE PRC_ID IN (SELECT PRC_ID  from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'))));

DELETE FROM LOS_LOTE_SUBASTA WHERE SUB_ID IN (SELECT SUB_ID FROM SUB_SUBASTA WHERE PRC_ID IN (SELECT PRC_ID  from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401')));

DELETE FROM SUB_SUBASTA WHERE PRC_ID IN (SELECT PRC_ID  from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'));

delete from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401');

delete from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401';



Insert into DD_TPO_TIPO_PROCEDIMIENTO
   (DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID, FLAG_PRORROGA, DTYPE, FLAG_DERIVABLE)
 Values
   (s_dd_tpo_tipo_procedimiento.nextval, 'P401', 'T. de subasta', 'trámite de subasta', 'tramiteSubastaV4', 0, 'DD', sysdate, 0, 2, (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AP'), 'MEJTipoProcedimiento', 1);


--TAREA 1

Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SCRIPT_VALIDACION, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_TGE_ID, DD_STA_ID)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'), 'P401_SolicitudSubasta', 'comprobarMinimoBienLote() ? (comprobarBienInformado() ? null :  ''Los bienes con lote deben tener informado las cargas anteriores y posteriores, si es vivienda habitual o no y la situación posesoria'') : ''Al menos un bien debe estar asignado a un lote''', 0, 'Solicitud de subasta', 0, 'dd', sysdate, 0, 1, 'EXTTareaProcedimiento', 3, 2, 39);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS
   (DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SolicitudSubasta'), '5*24*60*60*1000L', 0, 'DD', sysdate, 0);

Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SolicitudSubasta'), 0, 'label', 'titulo', '    <div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea, deberá acceder a la pestaña Subastas del asunto correspondiente y asociar uno o más bienes a la subasta que corresponda. Una vez agregados los bienes a la subasta deberá indicar a través de la ficha de cada bien las cargas anteriores y posteriores, si es vivienda habitual o no y la situación posesoria.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha solicitud deberá consignar la fecha en la que haya realizado la solicitud de subasta.
En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.
Una vez rellene esta pantalla se lanzará la tarea “Señalamiento de subasta” a realizar por el letrado.</p></div>', 0, 'DD', sysdate, 0);

Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento WHERE tap_codigo = 'P401_SolicitudSubasta'), 1, 'combo', 'comboSolicitud', 'Solicitud de subasta por terceros', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'DDSiNo', 0, 'DD', sysdate, 0);


Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SolicitudSubasta'), 2, 'date', 'fechaSolicitud', 'Fecha solicitud', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SolicitudSubasta'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);
   
   
--TAREA 2
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SCRIPT_VALIDACION_JBPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, TAP_SCRIPT_VALIDACION)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'), 'P401_SenyalamientoSubasta', 'plugin/procedimientos/tramiteSubasta/senyalamientoSubastaV4', '((valores[''P401_SenyalamientoSubasta''][''principal'']).toDouble() > ((valores[''P401_SenyalamientoSubasta''][''costasLetrado'']).toDouble())) ? ''null'' :  ''<p>&iexcl;Atenci&oacute;n! Las costas del letrado no pueden superar el 5% del principal.</p>''', 0, 'Señalamiento de subasta', 0, 'dd', sysdate, 0, 'tareaExterna.cancelarTarea', 1, 'EXTTareaProcedimiento', 3,
   'comprobarExisteDocumentoESRAS() ? null ''Es necesario adjuntar el documento Edicto de subasta y resolución acordando señalamiento''');
   
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS
   (DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SenyalamientoSubasta'), 'damePlazo(valores[''P401_SolicitudSubasta''][''fechaSolicitud''])+60*24*60*60*1000L', 0, 'DD', sysdate, 0);
   
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SenyalamientoSubasta'), 0, 'label', 'titulo', '    <div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez solicitada la subasta, en esta pantalla, debe consignar las fechas de anuncio y celebración de la misma así como las costas del letrado y procurador.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzarán las siguientes tareas:<br>"Celebración subasta y adjudicación" a realizar por el letrado.<br>"Adjuntar informe de subasta" a realizar por el letrado.<br>"Preparar propuesta de subasta" a realizar por el supervisor.</p></div>', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SenyalamientoSubasta'), 1, 'date', 'fechaAnuncio', 'Fecha anuncio', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SenyalamientoSubasta'), 2, 'date', 'fechaSenyalamiento', 'Fecha señalamiento', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SenyalamientoSubasta'), 3, 'currency', 'costasLetrado', 'Costas letrado', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SenyalamientoSubasta'), 4, 'currency', 'costasProcurador', 'Costas procurador', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SenyalamientoSubasta'), 5, 'currency', 'intereses', 'Intereses generados', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SenyalamientoSubasta'), 6, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SenyalamientoSubasta'), 7, 'currency', 'principal', 'Principal', 'procedimientoManager.getProcedimiento(idProcedimiento).getSaldoRecuperacion()*5/100', 0, 'DD', sysdate, 0);

   
--TAREA 3   
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SCRIPT_VALIDACION, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'), 'P401_AdjuntarInformeSubasta', 'comprobarExisteDocumentoINS() ? null : ''Es necesario adjuntar el documento informe de subasta al procedimiento.''', 0, 'Adjuntar informe de subasta', 0, 'dd', sysdate, 0, 1, 'EXTTareaProcedimiento', 3);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS
   (DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_AdjuntarInformeSubasta'), 'damePlazo(valores[''P401_SenyalamientoSubasta''][''fechaSenyalamiento''])+5*24*60*60*1000L', 0, 'DD', sysdate, 0);

Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_AdjuntarInformeSubasta'), 0, 'label', 'titulo', '    <div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea, antes deberá adjuntar al asunto correspondiente el informe sobre la subasta. Desde la pestaña Subastas del asunto correspondiente dispone de una función para descargar el informe de subasta ya generado y en formato Word, a partir de este documento puede modificarlo si así lo cree conveniente, y una vez modificado adjuntarlo al procedimiento a través de la pestaña Adjuntos.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha deberá consignar la fecha que adjunta el informe de subasta al procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla seguirá el flujo de tareas según especificación de la entidad.</p></div>', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_AdjuntarInformeSubasta'), 1, 'date', 'fechaInforme', 'Fecha informe', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_AdjuntarInformeSubasta'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);

--TAREA 4
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SCRIPT_VALIDACION, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'), 'P401_PrepararPropuestaSubasta', 'comprobarInformacionCompletaInstrucciones() ? (comprobarExisteDocumentoPRI()? null : ''Es necesario adjuntar el documento propuesta de instrucciones'') : ''La información de las instrucciones de los lotes no está completa.''', 0, 'Preparar propuesta de subasta', 0, 'dd', sysdate, 0, 1, 'EXTTareaProcedimiento', 3);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS
   (DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_PrepararPropuestaSubasta'), 'damePlazo(valores[''P401_SenyalamientoSubasta''][''fechaAnuncio''])-60*24*60*60*1000L', 0, 'DD', sysdate, 0);

Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_PrepararPropuestaSubasta'), 0, 'label', 'titulo', '    <div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de completar esta tarea deberá esperar a que estén disponibles en Recovery todas las tasaciones correspondientes a los bienes afectos a la subasta, esto lo podrá consultar a través de la pestaña Subastas del asunto correspondiente.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por completada esta tarea deberá acceder desde la pestaña Subastas del asunto correspondiente a cada uno de los bienes afectos a la subasta e indicar los importes para la puja sin postores, puja con postores desde y puja con postores hasta. Una vez hecho esto podrá generar desde la pestaña Subastas el informe con la propuesta de instrucciones para la subasta en formato Word, de forma que en caso de ser necesario pueda modificarlo.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea, deberá adjuntar el informe con la propuesta de instrucciones para la subasta al procedimiento correspondiente.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha deberá consignar la fecha en la que haya adjuntado el informe con las instrucciones para la subasta.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea “Validar propuesta de instrucciones” a realizar por el letrado.</p></div>', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_PrepararPropuestaSubasta'), 1, 'date', 'fechaPropuesta', 'Fecha propuesta instrucciones', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_PrepararPropuestaSubasta'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


--TAREA 5
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SCRIPT_DECISION, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_STA_ID)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'), 'P401_ValidarPropuesta', 'valores[''P409_ValidarPropuesta''][''comboResultado''] == ''ACE'' ? (comprobarIsDemandadoPerJuridica() ? ''lecturaYTributacion'' : ''lectura'') : (valores[''P409_ValidarPropuesta''][''comboResultado''] == ''SUS'' ? ''SuspenderSubasta'' : ''ModificarInstrucciones'')', 1, 'Validar propuesta', 0, 'dd', sysdate, 0, 'tareaExterna.cancelarTarea', 1, 'EXTTareaProcedimiento', 3, 40);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS
   (DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_ValidarPropuesta'), 'damePlazo(valores[''P401_SenyalamientoSubasta''][''fechaAnuncio''])-50*24*60*60*1000L', 0, 'DD', sysdate, 0);

Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_ValidarPropuesta'), 0, 'label', 'titulo', '    <div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por finalizada esta tarea deberá de revisar y dictaminar sobre la propuesta de instrucciones dada por el supervisor. Para ello dispone de la funcionalidad “Gestión de subastas” por la cual es posible validar de forma masiva o puntual las subastas en estado "PENDIENTE COMITE".</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dependiente del resultado del comité la siguiente tarea podrá ser:<br>"Suspender subasta" en caso de haber dictaminado la suspensión de la subasta.<br>"Lectura y aceptación por parte del letrado" En caso de haber aprobado las instrucciones de la subasta.<br>"Preparar propuesta de subasta" En caso de haber requerido al supervisor la modificación de las instrucciones para la subasta.</p></div>', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_ValidarPropuesta'), 1, 'date', 'fechaDecision', 'Fecha decisión','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_ERROR_VALIDACION, TFI_VALIDACION,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_ValidarPropuesta'), 2, 'combo', 'comboResultado', 'Resultado comité', 'DDResultadoComite','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_ValidarPropuesta'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


--TAREA 6
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'), 'P401_LecturaAceptacionInstrucciones', 0, 'Lectura y aceptación de instrucciones', 0, 'dd', sysdate, 0, 1, 'EXTTareaProcedimiento', 3);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS
   (DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_LecturaAceptacionInstrucciones'), 'damePlazo(valores[''P401_SenyalamientoSubasta''][''fechaAnuncio''])-5*24*60*60*1000L', 0, 'DD', sysdate, 0);

Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_LecturaAceptacionInstrucciones'), 0, 'label', 'titulo', '    <div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez que ha sido anunciada la subasta, y han sido dictadas las instrucciones por la entidad, antes de dar por completada esta tarea deberá acceder a la pestaña “Subastas” de la ficha del asunto correspondiente y revisar las instrucciones dadas para cada uno de los bienes a subastar.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Consignando la fecha se confirma haber recibido correctamente las instrucciones del responsable de la entidad, así como la aceptación de las mismas. Para el supuesto de que haya alguna duda al respecto, deberá ponerse en contacto con el responsable de la entidad para que se revisen o modifiquen dichas instrucciones.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento</p></div>', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_LecturaAceptacionInstrucciones'), 1, 'date', 'fecha', 'Fecha', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_LecturaAceptacionInstrucciones'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);

--TAREA 7
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, DD_TPO_ID_BPM, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'), 'P401_BPMTramiteTributacionEnBienesV4', 0, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P411'), 'Se inicia trámite tributación en bienes', 0, 'dd', sysdate, 0, 1, 'EXTTareaProcedimiento', 3);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS
   (DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_BPMTramiteTributacionEnBienesV4'), '300*24*60*60*1000L', 0, 'DD', sysdate, 0);


Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_BPMTramiteTributacionEnBienesV4'), 0, 'label', 'titulo', 'Se inicia trámite tributación en bienes', 0, 'DD', TO_TIMESTAMP('16/09/2014 0:00:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);


--TAREA 8
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'), 'P401_SuspenderSubasta', 0, 'Suspender subasta', 0, 'dd', sysdate, 0, 1, 'EXTTareaProcedimiento', 3);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS
   (DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SuspenderSubasta'), 'damePlazo(valores[''P401_ValidarPropuesta''][''fechaDecision''])+5*24*60*60*1000L', 0, 'DD', sysdate, 0);

Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SuspenderSubasta'), 0, 'label', 'titulo', '    <div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que el comité ha decidido suspender la subasta, para dar por completada esta tarea deberá de proceder a dicha suspensión, indicando en el campo Fecha suspensión, la fecha en que se haya suspendido la subasta.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SuspenderSubasta'), 1, 'date', 'fechaSuspension', 'Fecha suspension', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SuspenderSubasta'), 2, 'combo', 'comboMotivo', 'Motivo suspensión', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'DDMotivoSuspension', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SuspenderSubasta'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);

--TAREA 9
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SCRIPT_VALIDACION_JBPM, TAP_SCRIPT_DECISION, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'), 'P401_CelebracionSubasta', 'plugin/procedimientos/tramiteSubasta/celebracionSubastaV4', 'valores[''P401_CelebracionSubasta''][''comboCelebrada''] == ''02'' ? (valores[''P401_CelebracionSubasta''][''comboSuspension''] == null ? ''El campo suspensión es obligatorio'' : (valores[''P401_CelebracionSubasta''][''comboMotivo''] == null ? ''Campo motivo es obligatorio'' : null )) : (valores[''P401_CelebracionSubasta''][''comboCesion''] == null ? ''Campo cesión es obligatorio'' : (valores[''P401_CelebracionSubasta''][''comboCesion''] == ''01'' ? (valores[''P401_CelebracionSubasta''][''comboComite''] == null ? ''Campo comité es obligatorio'' : null) : null ))', 'valores[''P401_CelebracionSubasta''][''comboCelebrada''] == DDSiNo.NO ? (valores[''P401_CelebracionSubasta''][''comboSuspension''] == ''ENT'' ? ''SuspendidaEntidad'' : ''SuspendidaTerceros'' ) : (valores[''P401_CelebracionSubasta''][''comboCesion''] == DDSiNo.NO ? ''CelebracionActaSubasta'' : (valores[''P401_CelebracionSubasta''][''comboComite''] == DDSiNo.SI ? ''CesionDeRemateConPreparacion'': ''CesionDeRemateSinPreparacion''))', 0, 'Celebración de subasta', 0, 'dd', sysdate, 0, 1, 'EXTTareaProcedimiento', 3);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS
   (DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_CelebracionSubasta'), 'damePlazo(valores[''P401_SenyalamientoSubasta''][''fechaAnuncio''])-5*24*60*60*1000L', 0, 'DD', sysdate, 0);

Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_CelebracionSubasta'), 0, 'label', 'titulo', '    <div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez se celebre la subasta, en esta pantalla debe introducir la siguiente información:</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Celebrada deberá indicar si la subasta ha sido celebrada o no. En caso de haberse celebrado deberá indicar a través de la pestaña Subastas de la ficha del asunto correspondiente, el resultado de la subasta para cada uno de los bienes subastados y en el caso de adjudicación por parte de la entidad deberá informar también del importe por el cual se le lo ha adjudicado la entidad.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de suspensión de la subasta deberá indicar dicha circunstancia en el campo “Celebrada”, en el campo “Decisión suspensión” deberá consignar quien ha provocado dicha suspensión y en el campo “Motivo suspensión” deberá indicar el motivo por el cual se ha suspendido.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de haberse adjudicado alguno de los bienes la Entidad, deberá indicar si ha habido Postores o no en la subasta y en el campo cesión deberá indicar si se debe cursar la cesión de remate o no, según el procedimiento establecido por la entidad.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de haber cesión del remate deberá indicar si es requerida la preparación o no según el procedimiento establecido por la Entidad.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla la siguiente tarea será:<br>En caso de haberse producido la subasta se lanzará la tarea "Registrar acta de subasta".<br>En caso de haber cesión de remate y haber requerido la preparación de la misma "Preparar cesión de remate" a realizar por el supervisor.<br>En caso de haber cesión de remate y no haber requerido preparación de la misma, se lanzará directamente el trámite de cesión de remate.<br>En caso de haberse suspendido la subasta, se lanzará la tarea "Señalamiento de subasta".</p></div>', 4, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_CelebracionSubasta'), 1, 'combo', 'comboCelebrada', 'Subasta celebrada', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'DDSiNo', 0, 'DD', sysdate, 1);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_CelebracionSubasta'), 2, 'combo', 'comboCesion', 'cesión de remate', 'DDSiNo', 0, 'DD', sysdate, 1);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_CelebracionSubasta'), 3, 'combo', 'comboComite', 'Requiere elevar comité', 'DDSiNo', 0, 'DD', sysdate, 1);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_CelebracionSubasta'), 4, 'combo', 'comboSuspension', 'Decisión suspensión', 'DDDecisionSuspension', 0, 'DD', sysdate, 1);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_CelebracionSubasta'), 5, 'combo', 'comboMotivo', 'Motivo suspensión', 'DDMotivoSuspSubasta', 0, 'DD', sysdate, 1);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_CelebracionSubasta'), 6, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


--TAREA 10
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_STA_ID)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'), 'P401_BPMTramiteSubastaV4', (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'), 0, 'Se inicia trámite subasta', 0, 'DD', sysdate, 0, 1, 'EXTTareaProcedimiento', 3, 39);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS
   (DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (SELECT TAP_ID FROM tap_tarea_procedimiento tap where tap_codigo = 'P401_BPMTramiteSubastaV4'), '300*24*60*60*1000L', 0, 'DD', sysdate, 0);

Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_BPMTramiteSubastaV4'), 0, 'label', 'titulo', 'Se inicia trámite subasta', 0, 'DD', TO_TIMESTAMP('16/09/2014 0:00:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);

--TAREA 11
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SCRIPT_DECISION, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, TAP_SCRIPT_VALIDACION)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'), 'P401_RegistrarActaSubasta', 'valores[''P401_CelebracionSubasta''][''comboSuspension''] == ''TER'' ? ''ParaBienesAdjudicadosAUnTercero'' : ''ParaBienesAdjudicadosALaEntidad''', 0, 'Registrar acta de subasta', 0, 'dd', sysdate, 0, 1, 'EXTTareaProcedimiento', 3,
   'comprobarExisteDocumentoACS() ? null : ''Es necesario adjuntar el documento Acta de subasta''');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS
   (DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_RegistrarActaSubasta'), 'damePlazo(valores[''P401_SenyalamientoSubasta''][''fechaAnuncio''])+1*24*60*60*1000L', 0, 'DD', sysdate, 0);

Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_RegistrarActaSubasta'), 0, 'label', 'titulo', '    <div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá de adjuntar el acta de subasta al procedimiento correspondiente a través de la pestaña Adjuntos.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo fecha consignar la fecha en que da por terminada el acta de subasta y proceda a subirla a la plataforma.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla la siguiente tarea será, en caso de haber uno o más bienes adjudicados a un tercero “Solicitar mandamiento de pago” y en caso de habérselo adjudicado la entidad uno o más bienes “Contabilizar archivo y cierre de deudas”.</p></div>', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_RegistrarActaSubasta'), 1, 'date', 'fecha', 'Fecha', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_RegistrarActaSubasta'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


--TAREA 12
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'), 'P401_ContabilizarCierreDeuda', 0, 'Contabilizar activos/cierre de deudas', 0, 'dd', sysdate, 0, 'tareaExterna.cancelarTarea', 1, 'EXTTareaProcedimiento', 3);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS
   (DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_ContabilizarCierreDeuda'), 'damePlazo(valores[''P401_RegistrarActaSubasta''][''fecha''])+1*24*60*60*1000L', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_ContabilizarCierreDeuda'), 0, 'label', 'titulo', '    <div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que uno o más bienes han sido adjudicados a la entidad, para dar por completada esta tarea deberemos de proceder al cierre de deudas y contabilización en archivo de los contratos que corresponda. Una vez hecho esto, en el campo Fecha se deberá consignar la fecha en que haya terminado la tarea.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_ContabilizarCierreDeuda'), 1, 'date', 'fecha', 'Fecha', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_ContabilizarCierreDeuda'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


--TAREA 13
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'), 'P401_SolicitarMtoPago', 0, 'Solicitar mandamiento de pago', 0, 'dd', sysdate, 0, 'tareaExterna.cancelarTarea', 1, 'EXTTareaProcedimiento', 3);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS
   (DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SolicitarMtoPago'), 'damePlazo(valores[''P401_SenyalamientoSubasta''][''fechaAnuncio''])+20*24*60*60*1000L', 0, 'DD', sysdate, 0);

Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SolicitarMtoPago'), 0, 'label', 'titulo', '    <div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que alguno de los bienes ha sido adjudicado a un tercero, en esta pantalla debemos de consignar la fecha de presentación en el juzgado del escrito solicitando la entrega de las cantidades consignadas.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla la siguiente tarea será "Confirmar recepción mandamiento de pago"</p></div>', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SolicitarMtoPago'), 1, 'date', 'fechaPresentacion', 'Fecha', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_SolicitarMtoPago'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);

--TAREA 14
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'), 'P401_ConfirmarRecepcionMtoPago', 0, 'Confirmar recepcion mandamiento de pago', 0, 'dd', sysdate, 0, 'tareaExterna.cancelarTarea', 1, 'EXTTareaProcedimiento', 3);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS
   (DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_ConfirmarRecepcionMtoPago'), 'damePlazo(valores[''P401_SolicitarMtoPago''][''fechaPresentacion''])+20*24*60*60*1000L', 0, 'DD', sysdate, 0);

Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_ConfirmarRecepcionMtoPago'), 0, 'label', 'titulo', '    <div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se ha de consignar la fecha en la que nos han entregado los mandamientos de pago de la cantidad consignada por un tercero en concepto de pago del bien adjudicado.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_ConfirmarRecepcionMtoPago'), 1, 'date', 'fecha', 'Fecha', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_ConfirmarRecepcionMtoPago'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


--TAREA 15
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'), 'P401_PrepararCesionRemate', 0, 'Preparar cesión de remate', 0, 'dd', sysdate, 0, 1, 'EXTTareaProcedimiento', 3);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS
   (DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
      (s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_PrepararCesionRemate'), 'damePlazo(valores[''P401_PrepararCesionRemate''][''fecha''])+3*24*60*60*1000L', 0, 'DD', sysdate, 0);

Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_PrepararCesionRemate'), 0, 'label', 'titulo', '    <div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que el letrado ha indicado que se requiere de preparación para la cesión del remate, para dar por completada esta tarea deberá introducir en el campo Instrucciones las instrucciones de la entidad para la cesión y en el campo Fecha consignar la fecha en que de por terminada la preparación de la cesión de remate.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla la siguiente tarea será "Aceptación de instrucciones para cesión" a realizar por el supervisor de la entidad.</p></div>', 3, 'DD', sysdate, 'GESTOR', TO_TIMESTAMP('23/09/2014 16:08:04.196000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_PrepararCesionRemate'), 1, 'date', 'fecha', 'Fecha', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_PrepararCesionRemate'), 2, 'htmllabel', 'instrucciones', 'Instrucciones', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_PrepararCesionRemate'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


--TAREA 16
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SCRIPT_DECISION, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_STA_ID)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'), 'P401_AprobacionPropCesionRemate', 'valores[''P401_AprobacionPropCesionRemate''][''comboAprobado''] == DDSiNo.SI ? ''OK'' : ''KO''', 1, 'Aprobación propuesta de cesión de remate a terceros', 0, 'dd', sysdate, 0, 'tareaExterna.cancelarTarea', 1, 'EXTTareaProcedimiento', 3, 40);


Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS
   (DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
      (s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_AprobacionPropCesionRemate'), 'damePlazo(valores[''P401_SenyalamientoSubasta''][''fechaSenyalamiento''])+3*24*60*60*1000L', 0, 'DD', sysdate, 0);

Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_AprobacionPropCesionRemate'), 0, 'label', 'titulo', '    <div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla deberá de comprobar que las instrucciones dadas por el supervisor son correctas y estén en consonancia con la política de la entidad. En caso de haber discrepancia puede modificar las instrucciones directamente sobre el campo Instrucciones de forma que sean estas instrucciones las que lleguen al actor encargado de proceder con la cesión del remate.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez completada esta tarea el sistema iniciará automáticamente el trámite de cesión de remate.</p></div>', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_AprobacionPropCesionRemate'), 1, 'date', 'fecha', 'Fecha', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_AprobacionPropCesionRemate'), 2, 'combo', 'comboAprobado', 'Instrucciones correctas', 'DDSiNo', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_AprobacionPropCesionRemate'), 3, 'htmllabel', 'instrucciones', 'Instrucciones', 'valores[''P401_PrepararCesionRemate''][''instrucciones'']', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_AprobacionPropCesionRemate'), 4, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


--TAREA 17
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_STA_ID)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'),'P401_BPMTramiteCesionRemateV4', (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P401'),0,  'Se inicia trámite de cesión de remate', 0, 'DD', sysdate, 0, 1, 'EXTTareaProcedimiento', 3, 39);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS
   (DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
      (s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_BPMTramiteCesionRemateV4'), '300*24*60*60*1000L', 0, 'DD', sysdate, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P401_BPMTramiteCesionRemateV4'), 0, 'label', 'titulo', 'Se inicia trámite de cesión de remate', 0, 'DD', sysdate, 0);


--INSTRUCCIONES
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea, deberá acceder a la pestaña Subastas del asunto correspondiente y asociar uno o más bienes a la subasta que corresponda. Una vez agregados los bienes a la subasta deberá indicar a través de la ficha de cada bien las cargas anteriores y posteriores, si es vivienda habitual o no y la situación posesoria.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha solicitud deberá consignar la fecha en la que haya realizado la solicitud de subasta.
En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.
Una vez rellene esta pantalla se lanzará la tarea "Señalamiento de subasta" a realizar por el letrado.</p></div>	' where tfi_nombre = 'titulo' and tap_id = (SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P401_SolicitudSubasta')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez solicitada la subasta, en esta pantalla, debe consignar las fechas de anuncio y celebración de la misma así como las costas del letrado y procurador.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzarán las siguientes tareas:<br>"Celebración subasta y adjudicación" a realizar por el letrado.<br>"Adjuntar informe de subasta" a realizar por el letrado.<br>"Preparar propuesta de subasta" a realizar por el supervisor.</p></div>	' where tfi_nombre = 'titulo' and tap_id = (SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P401_SenyalamientoSubasta')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea, antes deberá adjuntar al asunto correspondiente el informe sobre la subasta. Desde la pestaña Subastas del asunto correspondiente dispone de una función para descargar el informe de subasta ya generado y en formato Word, a partir de este documento puede modificarlo si así lo cree conveniente, y una vez modificado adjuntarlo al procedimiento a través de la pestaña Adjuntos.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha deberá consignar la fecha que adjunta el informe de subasta al procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla seguirá el flujo de tareas según especificación de la entidad.</p></div>	' where tfi_nombre = 'titulo' and tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P401_AdjuntarInformeSubasta')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de completar esta tarea deberá esperar a que estén disponibles en Recovery todas las tasaciones correspondientes a los bienes afectos a la subasta, esto lo podrá consultar a través de la pestaña Subastas del asunto correspondiente.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por completada esta tarea deberá acceder desde la pestaña Subastas del asunto correspondiente a cada uno de los bienes afectos a la subasta e indicar los importes para la puja sin postores, puja con postores desde y puja con postores hasta. Una vez hecho esto podrá generar desde la pestaña Subastas el informe con la propuesta de instrucciones para la subasta en formato Word, de forma que en caso de ser necesario pueda modificarlo.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea, deberá adjuntar el informe con la propuesta de instrucciones para la subasta al procedimiento correspondiente.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha deberá consignar la fecha en la que haya adjuntado el informe con las instrucciones para la subasta.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea "Validar propuesta de instrucciones" a realizar por el letrado.</p></div>	' where tfi_nombre = 'titulo' and tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P401_PrepararPropuestaSubasta')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por finalizada esta tarea deberá de revisar y dictaminar sobre la propuesta de instrucciones dada por el supervisor. Para ello dispone de la funcionalidad "Gestión de subastasí por la cual es posible validar de forma masiva o puntual las subastas en estado "PENDIENTE COMITE".</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dependiente del resultado del comité la siguiente tarea podrá ser:<br>"Suspender subasta" en caso de haber dictaminado la suspensión de la subasta.<br>"Lectura y aceptación por parte del letrado" En caso de haber aprobado las instrucciones de la subasta.<br>"Preparar propuesta de subasta" En caso de haber requerido al supervisor la modificación de las instrucciones para la subasta.</p></div>	' where tfi_nombre = 'titulo' and tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P401_ValidarPropuesta')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez que ha sido anunciada la subasta, y han sido dictadas las instrucciones por la entidad, antes de dar por completada esta tarea deberá acceder a la pestaña "Subastasí de la ficha del asunto correspondiente y revisar las instrucciones dadas para cada uno de los bienes a subastar.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Consignando la fecha se confirma haber recibido correctamente las instrucciones del responsable de la entidad, así como la aceptación de las mismas. Para el supuesto de que haya alguna duda al respecto, deberá ponerse en contacto con el responsable de la entidad para que se revisen o modifiquen dichas instrucciones.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento</p></div>	' where tfi_nombre = 'titulo' and tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P401_LecturaAceptacionInstrucciones')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que el comité ha decidido suspender la subasta, para dar por completada esta tarea deberá de proceder a dicha suspensión, indicando en el campo Fecha suspensión, la fecha en que se haya suspendido la subasta.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>	' where tfi_nombre = 'titulo' and tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P401_SuspenderSubasta')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez se celebre la subasta, en esta pantalla debe introducir la siguiente información:</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Celebrada deberá indicar si la subasta ha sido celebrada o no. En caso de haberse celebrado deberá indicar a través de la pestaña Subastas de la ficha del asunto correspondiente, el resultado de la subasta para cada uno de los bienes subastados y en el caso de adjudicación por parte de la entidad deberá informar también del importe por el cual se le lo ha adjudicado la entidad.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de suspensión de la subasta deberá indicar dicha circunstancia en el campo "Celebrada", en el campo "Decisión suspensión" deberá consignar quien ha provocado dicha suspensión y en el campo "Motivo suspensión" deberá indicar el motivo por el cual se ha suspendido.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de haberse adjudicado alguno de los bienes la Entidad, deberá indicar si ha habido Postores o no en la subasta y en el campo Cesión deberá indicar si se debe cursar la cesión de remate o no, según el procedimiento establecido por la entidad.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En caso de haber cesión del remate deberá indicar si es requerida la preparación o no según el procedimiento establecido por la Entidad.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla la siguiente tarea será:<br>En caso de haberse producido la subasta se lanzará la tarea "Registrar acta de subasta".<br>En caso de haber cesión de remate y haber requerido la preparación de la misma "Preparar cesión de remate" a realizar por el supervisor.<br>En caso de haber cesión de remate y no haber requerido preparación de la misma, se lanzará directamente el trámite de cesión de remate.<br>En caso de haberse suspendido la subasta, se lanzará la tarea "Señalamiento de subasta".</p></div>	' where tfi_nombre = 'titulo' and tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P401_CelebracionSubasta')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá de adjuntar el acta de subasta al procedimiento correspondiente a través de la pestaña Adjuntos.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo fecha consignar la fecha en que da por terminada el acta de subasta y proceda a subirla a la plataforma.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla la siguiente tarea será, en caso de haber uno o más bienes adjudicados a un tercero "Solicitar mandamiento de pago" y en caso de habérselo adjudicado la entidad uno o más bienes "Contabilizar archivo y cierre de deudas".</p></div>	' where tfi_nombre = 'titulo' and tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P401_RegistrarActaSubasta')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que alguno de los bienes ha sido adjudicado a un tercero, en esta pantalla debemos de consignar la fecha de presentación en el juzgado del escrito solicitando la entrega de las cantidades consignadas.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla la siguiente tarea será "Confirmar recepción mandamiento de pago"</p></div>	' where tfi_nombre = 'titulo' and tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P401_SolicitarMtoPago')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Se ha de consignar la fecha en la que nos han entregado los mandamientos de pago de la cantidad consignada por un tercero en concepto de pago del bien adjudicado.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>	' where tfi_nombre = 'titulo' and tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P401_ConfirmarRecepcionMtoPago')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que uno o más bienes han sido adjudicados a la entidad, para dar por completada esta tarea deberemos de proceder al cierre de deudas y contabilización en archivo de los contratos que corresponda. Una vez hecho esto, en el campo Fecha se deberá consignar la fecha en que haya terminado la tarea.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</p></div>	' where tfi_nombre = 'titulo' and tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P401_ContabilizarCierreDeuda')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que el letrado ha indicado que se requiere de preparación para la cesión del remate, para dar por completada esta tarea deberá introducir en el campo Instrucciones las instrucciones de la entidad para la cesión y en el campo Fecha consignar la fecha en que de por terminada la preparación de la cesión de remate.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla la siguiente tarea será "Aceptación de instrucciones para cesión" a realizar por el supervisor de la entidad.</p></div>	' where tfi_nombre = 'titulo' and tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P401_PrepararCesionRemate')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla deberá de comprobar que las instrucciones dadas por el supervisor son correctas y estén en consonancia con la política de la entidad. En caso de haber discrepancia puede modificar las instrucciones directamente sobre el campo Instrucciones de forma que sean estas instrucciones las que lleguen al actor encargado de proceder con la cesión del remate.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez completada esta tarea el sistema iniciará automáticamente el trámite de cesión de remate.</p></div>	' where tfi_nombre = 'titulo' and tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P401_AprobacionPropCesionRemate')	;

COMMIT;


