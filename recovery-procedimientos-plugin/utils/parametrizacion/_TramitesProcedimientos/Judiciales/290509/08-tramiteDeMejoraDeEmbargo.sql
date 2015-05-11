-- *************************************************************************** --
-- **                        BPM Trámite de mejora de embargo               ** --
-- *************************************************************************** --

--Insercion de las tareas/pantallas
-- Pantalla 1
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P14'), 'P14_SolicitudMejoraEmbargo', 0, 'Solicitud de mejora de embargo', 0, 'DD', SYSDATE, 0);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_SolicitudMejoraEmbargo'), '2*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_SolicitudMejoraEmbargo'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que hemos tenido conocimiento de otros bienes que pertenecen al deudor/es se ha de solicitar del Juzgado proceda a la mejora de embargo sobre los indicados bienes.Pues bien se ha de indicar en este momento la fecha de presentaci&'||'oacute;n de dicho escrito en el Juzgado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_SolicitudMejoraEmbargo'), 1, 'date', 'fechaSolicitud', 'Fecha solicitud', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_SolicitudMejoraEmbargo'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 2
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P14'), 'P14_RegistroDecretoEmbargo', 0, 'Confirmar registro decreto embargo', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_RegistroDecretoEmbargo'), '30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_RegistroDecretoEmbargo'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se ha de indicar la fecha en la que se nos notifica la  Resoluci&'||'oacute;n que ha dictado el Juzgado por la que se admite nuestra solicitud de mejora de embargo.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_RegistroDecretoEmbargo'), 1, 'date', 'fechaRegistro', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_RegistroDecretoEmbargo'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 3
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_DECISION, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P14'), 'P14_RegistrarAnotacionEnRegistro', 'isBienesConFechaDecreto() && !isBienesConFechaRegistro() ? ''Antes de realizar la tarea es necesario marcar los bienes con fecha de registro de embargo'' : null', 
'valores[''P14_RegistrarAnotacionEnRegistro''][''repetir''] == DDSiNo.SI ? ''repite'' : ''avanzaBPM''', 0, 'Registrar anotación en registro', 0, 'DD', SYSDATE, 0);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_RegistrarAnotacionEnRegistro'), '30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_RegistrarAnotacionEnRegistro'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se ha de consignar la fecha de anotaci&'||'oacute;n de los embargos trabados en el Registro de la Propiedad correspondiente.</p><p style="margin-bottom: 10px">Para el supuesto de la existencia de embargo de varios bienes y que estos se encuentren inscritos en diferentes Registros de la Propiedad, se deber&'||'aacute; consignar en esta pantalla &'||'uacute;nicamente el de la anotaci&'||'oacute;n del primero de ellos. Se deber&'||'aacute; abrir la pestaña de &'||'quot;Bienes&'||'quot; para introducir la fecha de anotaci&'||'oacute;n en el Registro de la Propiedad de cada uno de los bienes embargados.</p><p style="margin-bottom: 10px">Para el supuesto de que se trate de embargo de bien mueble, &'||'uacute;nicamente se deber&'||'aacute; consignar el primer campo para el supuesto de que el mismo sea inscribible en el Registro de Bienes Muebles.</p><p style="margin-bottom: 10px">El siguiente campo deber&'||'aacute; de mantenerse como afirmativo siempre que existan bienes no apremiados por la entidad, lo que permitir&'||'aacute; que la herramienta nos genere una alerta para solicitar la pr&'||'oacute;rroga de la anotaci&'||'oacute;n de los embargos en el Registro.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_RegistrarAnotacionEnRegistro'), 1, 'date', 'fechaRegistro', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_RegistrarAnotacionEnRegistro'), 2, 'combo', 'repetir', 'Hay bienes, con embargo registrado, no adjudicados', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_RegistrarAnotacionEnRegistro'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);
