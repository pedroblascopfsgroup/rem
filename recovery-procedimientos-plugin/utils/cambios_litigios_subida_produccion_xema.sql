--TRÁMITE NOTIFICACIÓN

update tfi_tareas_form_items
set tfi_label = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que no hemos podido notificar en el domicilio designado en la demanda interpuesta, en esta pantalla, debemos consignar la fecha en la que presentamos escrito en el juzgado en el que se aporta otros domicilios, si los conocemos, o bien solicitamos del juzgado proceda a la averiguaci&'||'oacute;n de otros domicilios del o de los demandados.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar resultado&'||'quot;.</p>
<p style="margin-bottom: 10px">En el caso de que el procedimiento en el que nos encontramos sea &'||'quot;Ejecuci&'||'oacute;n Hipotecaria&'||'quot; deber&'||'aacute;, para el supuesto que el Juzgado que tramite el Procedimiento permitiera la solicitud de notificaci&'||'oacute;n por edictos, indicar en esta pantalla la fecha, y en la tarea &'||'quot;Registrar Resultado&'||'quot; deber&'||'aacute; indicar &'||'quot;Notificaci&'||'oacute;n Negativa&'||'quot;. Acto seguido, podrá consignar la solicitud de notificaci&'||'oacute;n por edictos.</p></div>'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P06_NotificacionAveriguacionDomicilio') and tfi_orden = 0;

commit;

--TRÁMITE SUBASTA
update tfi_tareas_form_items
set tfi_label = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez solicitada la subasta, en esta pantalla, debe consignar las fechas de anuncio y celebraci&'||'oacute;n de la misma.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &'||'eacute;sta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Celebraci&'||'oacute;n subasta y adjudicaci&'||'oacute;n&'||'quot;</p><p style="margin-bottom: 10px">De acuerdo al Protocolo de Actuaci&'||'oacute;n Judicial de NGB, una vez conocido el resultado positivo de la solicitud de subasta, y en los 5 d&'||'iacute;as 
siguientes, se deber&'||'aacute;:<ul><li style="margin-left: 2em">- Remitir correo electr&'||'oacute;nico a Gesti&'||'oacute;n de Activos (<a href="mailto:gestiondeactivos@org.es">gestiondeactivos@org.es</a>). A dicho correo deber&'||'aacute; adjuntarse el edicto de subasta, la tasaci&'||'oacute;n de la finca, y la certificaci&'||'oacute;n de cargas.</li>
</br>
<li style="margin-left: 2em">- Analizar la necesidad de solicitar Informe Fiscal, y en caso afirmativo remitir correo electr&'||'oacute;nico a la siguiente direcci&'||'oacute;n: <a href="mailto:dfvazquez@novagalicia.es">dfvazquez@novagalicia.es</a>.</li></ul></p>
</br>
<p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Celebraci&'||'oacute;n subasta y adjudicaci&'||'oacute;n&'||'quot;</p></div>'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new2') and tfi_orden = 0;

update tfi_tareas_form_items
set tfi_label = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez se celebre la subasta, en esta pantalla debe introducir quien se ha adjudicado el bien y el importe de adjudicaci&'||'oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p>
<p style="margin-bottom: 10px">Posterior asimismo a la celebraci&'||'oacute;n de la subasta, y de acuerdo al Protocolo de Actuaci&'||'oacute;n Judicial de NGB se deber&'||'aacute; enviar correo electr&'||'oacute;nico a Gesti&'||'oacute;n de Activos informando del resultado de la subasta</p>
<p style="margin-bottom: 10px">La cesi&'||'oacute;n de remate deber&'||'aacute; realizarse en un plazo de 10 días como m&'||'aacute;ximo desde la fecha de subasta.</p>
<p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Si el bien se lo han adjudicado terceros: Solicitud mandamiento de pago.</li><li style="margin-bottom: 10px; margin-left: 35px;">Si el bien se lo ha adjudicado la entidad se le abrir&'||'aacute; una tarea en la que propondr&'||'aacute;, seg&'||'uacute;n su criterio, la siguiente actuaci&'||'oacute;n al responsable de la entidad.</li></ul></div>'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_CelebracionSubasta') and tfi_orden = 0;


commit;

--TRÁMITE DE ADJUDICACIÓN
update TAP_TAREA_PROCEDIMIENTO
set tap_descripcion = 'Solicitud Decreto Adjudicación'
where tap_codigo = 'P05_SolicitudTramiteAdjudicacion';

update TAP_TAREA_PROCEDIMIENTO
set tap_descripcion = 'Notificación Decreto Adjudicación a la Entidad'
where tap_codigo = 'P05_RegistrarAutoAdjudicacion';

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO,DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P05'), 'P05_NotifcacionDecreAdjudicacion', 0, 'Notificación Decreto Adjudicación a la Entidad', 0, 'DD', SYSDATE, 0,'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P05_NotifcacionDecreAdjudicacion'), 'damePlazo(valores[''P05_SolicitudTramiteAdjudicacion''][''fechaSolicitud'']) + 30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P05_NotifcacionDecreAdjudicacion'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar la fecha en al que se notifica por el Juzgado o el Decreto de Adjudicación.</p><p style="margin-bottom: 10px">Revisar que el Decreto es conforme a la subasta celebrada y contiene lo preceptuado para su correcta inscripción en el Registro de la Propiedad</p></div>', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P05_NotifcacionDecreAdjudicacion'), 1, 'date', 'fecha', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.P08_RegistrarCertificacion.fechaOblgatoria', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO,TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P05_NotifcacionDecreAdjudicacion'), 2, 'combo', 'conforme', 'Conforme', 0, 'DD', SYSDATE, 0,'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.P08_RegistrarCertificacion.fechaOblgatoria');

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P05_NotifcacionDecreAdjudicacion'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);


Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO,DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P05'), 'P05_NotificacionDecreContratio', 0, 'Notificación Decreto Adjudicación al Contrario', 0, 'DD', SYSDATE, 0,'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P05_NotificacionDecreContratio'), 'damePlazo(valores[''P05_NotifcacionDecreAdjudicacion''][''fecha'']) + 30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P05_NotificacionDecreContratio'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se informará de la fecha de notificación del Decreto de Adjudicación a la parte contraria.</p><p style="margin-bottom: 10px">En el caso de no informar en el plazo establecido por la tarea, deberá abrirse el trámite de notificación.</p></div>', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO,TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P05_NotificacionDecreContratio'), 1, 'combo', 'notificado', 'Notificado', 0, 'DD', SYSDATE, 0,'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.P08_RegistrarCertificacion.fechaOblgatoria');


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P05_NotificacionDecreContratio'), 2, 'date', 'fecha', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.P08_RegistrarCertificacion.fechaOblgatoria', 0, 'DD', SYSDATE, 0);


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P05_NotificacionDecreContratio'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

update DD_PTP_PLAZOS_TAREAS_PLAZAS
set dd_ptp_plazo_script = 'damePlazo(valores[''P05_NotificacionDecreContratio''][''fecha'']) + 20*24*60*60*1000L'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P05_RegistrarAutoAdjudicacion');
commit;