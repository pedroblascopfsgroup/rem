-- *************************************************************************** --
-- **                   Actualizar MEJORA DE EMBARGO						 * --
-- ** descripciones + titulos + nuevo combo en Confirmar registro decreto  	 * --
-- ** embargo																 * --			  
-- *************************************************************************** --

UPDATE TAP_TAREA_PROCEDIMIENTO
SET TAP_DESCRIPCION = 'Confirmar registro decreto embargo'
WHERE 	TAP_CODIGO = 'P14_RegistroDecretoEmbargo' AND
		DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P14');


Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P14'), 'P14_RegistroDecretoEmbargo_new1', 0, 'Confirmar registro decreto embargo', 
'valores[''P14_RegistroDecretoEmbargo_new1''][''comboResultado''] == DDSiNo.SI ? ''si'' : ''no''', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_RegistroDecretoEmbargo_new1'), '30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_RegistroDecretoEmbargo_new1'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se ha de indicar la fecha en la que se nos notifica la  Resoluci&'||'oacute;n que ha dictado el Juzgado por la que se admite nuestra solicitud de mejora de embargo. Por otro lado indicar si existen bienes registrables y por tanto se quiere proceder a su anotación en el registro.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, si se ha indicado que existen bienes registrables se iniciar&'||'aacute; la actuaci&'||'oacute;n &'||'quot;Vigilancia caducidad anotaciones de embargo&'||'quot;. Si no hay bienes registrables se le abrir&'||'aacute; una tarea en la que propondr&'||'aacute;, seg&'||'uacute;n su criterio, la siguiente actuaci&'||'oacute;n al responsable de la entidad.</p></div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_RegistroDecretoEmbargo_new1'), 1, 'date', 'fechaRegistro', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_RegistroDecretoEmbargo_new1'), 2, 'combo', 'comboResultado', 'Existen bienes registrables', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_RegistroDecretoEmbargo_new1'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- nueva tarea BPM
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P14'), 'P14_BPMVigilanciaCaducidadAnotacion',(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P60'), 0, 'Ejecución de Vigilancia caducidad anotación de embargo', 0, 'DD', SYSDATE, 0);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_BPMVigilanciaCaducidadAnotacion'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_BPMVigilanciaCaducidadAnotacion'), 0, 'label', 'titulo', 'Ejecución de Vigilancia caducidad anotación de embargo', 0, 'DD', SYSDATE, 0);


