-- *************************************************************************** --
-- **                   BPM Ejecución de título judicial                    ** --
-- *************************************************************************** --

Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P60', 'Anotación y vigilancia de embargos en registro', 'Anotación y vigilancia de embargos en registro', '', 'vigilanciaCaducidadAnotacion', 0, 'DD', SYSDATE, 0);

--Pantalla 1
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_DECISION, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P60'), 'P60_RegistrarAnotacion', 'isBienesConFechaDecreto() && !isBienesConFechaRegistro() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>¡Atenci&'||'oacute;n! Debe marcar los bienes sobre los que solicita embargo.</p></div>o'' : null', 
'valores[''P60_RegistrarAnotacion''][''repetir''] == DDSiNo.SI ? ''repite'' : ''avanzaBPM''', 0, 'Confirmar anotación en el registro', 0, 'DD', SYSDATE, 0);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RegistrarAnotacion'), '30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RegistrarAnotacion'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se ha de consignar la fecha de anotaci&'||'oacute;n de los embargos trabados en el Registro de la Propiedad correspondiente.</p><p style="margin-bottom: 10px">Para el supuesto de la existencia de embargo de varios bienes y que estos se encuentren inscritos en diferentes Registros de la Propiedad, se deber&'||'aacute; consignar en esta pantalla &'||'uacute;nicamente el de la anotaci&'||'oacute;n del primero de ellos. Se deber&'||'aacute; abrir la pestaña de &'||'quot;Bienes&'||'quot; para introducir la fecha de anotaci&'||'oacute;n en el Registro de la Propiedad de cada uno de los bienes embargados.</p><p style="margin-bottom: 10px">El siguiente campo deber&'||'aacute; de mantenerse como afirmativo siempre que existan bienes no apremiados por la entidad, lo que permitir&'||'aacute; que la herramienta nos genere una alerta para solicitar la pr&'||'oacute;rroga de la anotaci&'||'oacute;n de los embargos en el Registro.</p><p style="margin-bottom: 10px">En el caso de que no se haya admitido el registro de alguno de los embargos solicitados, cons&'||'iacute;gnelo en observaciones y si el resultado es, no haber conseguido registrar ning&'||'uacute;n embargo complete el campo de &'||'quot;Activar alerta peri&'||'oacute;dica&'||'quot; como negativo.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RegistrarAnotacion'), 1, 'date', 'fecha', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RegistrarAnotacion'), 2, 'combo', 'repetir', 'Activar alerta periódica', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RegistrarAnotacion'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 2

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P60'), 'P60_RevisarRegistroDeEmbargo', 0, 'Revisar registro de embargo', 
'valores[''P60_RevisarRegistroDeEmbargo''][''repetir''] == DDSiNo.SI ? ''recordatorio'' : ''terminar''', 
0, 'DD', SYSDATE, 0);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RevisarRegistroDeEmbargo'), '23*7*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RevisarRegistroDeEmbargo'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para completar esta tarea deber&'||'aacute; acceder a la pesta&'||'ntilde;a &'||'quot;Bienes&'||'quot; de este procedimiento, donde puede encontrar los datos sobre los distintos embargos registrados y que deben ser revisados en este momento.</p><p style="margin-bottom: 10px">Introduzca la fecha en la que se efectua la solicitud de renovaci&'||'oacute;n en el campo &'||'quot;Fecha&'||'quot; y la fecha en la que queda renovado cada bien en el campo correspondiente de la pesta&'||'ntilde;a &'||'quot;Bienes&'||'quot;.</p><p style="margin-bottom: 10px">En caso de no quedar ning&'||'uacute;n embargo anotado tras esta tarea, indique &'||'quot;No&'||'quot; en el campo &'||'quot;Mantener alerta de caducidad&'||'quot; o &'||'quot;Si&'||'quot; en caso contrario.</p><p style="margin-bottom: 10px"><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p>', 0, 'DD', SYSDATE, 0); 
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RevisarRegistroDeEmbargo'), 1, 'date', 'fecha', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RevisarRegistroDeEmbargo'), 2, 'combo', 'repetir', 'Mantener alerta de caducidad', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RevisarRegistroDeEmbargo'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);


