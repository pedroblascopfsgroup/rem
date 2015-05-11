-- TRÁMITE HIPOTECARIO

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,  TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P01_DemandaCertificacionCargas'), 3, 'number', 'valorTasacionSubasta', 'Valor de tasación para la subasta según escritura', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,  TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P01_DemandaCertificacionCargas'), 4, 'number', 'valorTasacionActualizado', 'Valor de tasación actualizado recibido en el expediente', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

update tfi_tareas_form_items
set tfi_orden = 5
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P01_DemandaCertificacionCargas') and tfi_nombre = 'observaciones';


--TRÁMITE ACEPTACIÓN Y DECISION

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_FAP_ID, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P61'), 'P61_BPMSolicitudConcurso', (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P55'), 0, 'Se inicia el procedimiento Solicitud concurso necesario', 0, 'DD', SYSDATE, 0, (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='01'), 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P61_BPMSolicitudConcurso'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P61_BPMSolicitudConcurso'), 0, 'label', 'titulo', 'Se inicia el procedimiento Solicitud concurso necesario', 0, 'DD', SYSDATE, 0);


--TRÁMITE ANOTACIÓN Y VIGILANCIA DE EMBARGOS

delete from tfi_tareas_form_items
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RegistrarAnotacion') and tfi_nombre='repetir';

update tfi_tareas_form_items
set tfi_orden = 2
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RegistrarAnotacion') and tfi_nombre = 'observaciones';

update tap_tarea_procedimiento
set tap_script_decision = null
where tap_codigo = 'P60_RegistrarAnotacion';

commit;

