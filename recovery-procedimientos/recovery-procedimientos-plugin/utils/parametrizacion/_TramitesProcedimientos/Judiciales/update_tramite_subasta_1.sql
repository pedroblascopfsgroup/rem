-- *************************************************************************** --
-- **                   Actualizar una tarea del trámite de subasta          * --
-- ** para que incorpore la posibilidad de indicar si se ha aceptado o no 	 * --
-- ** la solicitud de subasta												 * --			  
-- *************************************************************************** --


-- ******************* OPCION 2 MANTENER TAREA VIEJA Y CREAR UNA NUEVA PARA EL NUEVO BPM

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, TAP_SCRIPT_DECISION, TAP_SCRIPT_VALIDACION_JBPM)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P11'), 'P11_AnuncioSubasta_new1', 0, 'Anuncio de Subasta', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea',
'valores[''P11_AnuncioSubasta_new1''][''comboResultado''] == DDSiNo.SI ? ''si'' : ''no''', '( ((valores[''P11_AnuncioSubasta_new1''][''comboResultado''] == DDSiNo.SI) &&'||' (valores[''P11_AnuncioSubasta_new1''][''fechaAnuncio''] == '''')) || ((valores[''P11_AnuncioSubasta_new1''][''comboResultado''] == DDSiNo.SI) &&'||' (valores[''P11_AnuncioSubasta_new1''][''fechaSubasta''] == '''')) )?''tareaExterna.error.faltaAlgunaFecha'':null');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new1'), 'damePlazo(valores[''P11_SolicitudSubasta''][''fecha'']) + 20*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new1'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez solicitada la subasta, en esta pantalla, debe indicar el resultado de dicha solicitud, en caso de haber sido aceptada deber&'||'aacute; consignar las fechas de anuncio y celebraci&'||'oacute;n de la misma.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute;, si ha sido aceptada la solicitud de subasta &'||'quot;Celebraci&'||'oacute;n subasta y adjudicaci&'||'oacute;n&'||'quot; y &'||'quot;Dictar instrucciones&'||'quot; por parte del supervisor. Si no ha sido admitida la solicitud se le abrir&'||'aacute; tarea en la que propondr&'||'aacute;, seg&'||'uacute;n su criterio, la siguiente actuaci&'||'oacute;n al responsable de la entidad.</p></div>'
, 0, 'DD', SYSDATE, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new1'), 1, 'combo', 'comboResultado', 'Solicitud aceptada', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new1'), 2, 'date', 'fechaAnuncio', 'Fecha anuncio subasta', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new1'), 3, 'date', 'fechaSubasta', 'Fecha celebración subasta', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new1'), 4, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS
SET DD_PTP_PLAZO_SCRIPT = 'valores[''P11_AnuncioSubasta''] == null ? damePlazo(valores[''P11_AnuncioSubasta_new1''][''fechaSubasta'']) - 5*24*60*60*1000L : damePlazo(valores[''P11_AnuncioSubasta''][''fechaSubasta'']) - 5*24*60*60*1000L'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_DictarInstrucciones');

UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS
SET DD_PTP_PLAZO_SCRIPT = 'valores[''P11_AnuncioSubasta''] == null ? damePlazo(valores[''P11_AnuncioSubasta_new1''][''fechaSubasta'']) : damePlazo(valores[''P11_AnuncioSubasta''][''fechaSubasta''])'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_CelebracionSubasta');

