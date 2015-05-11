-- *************************************************************************** --
-- **                   BPM Trámite de aceptación y decisión                ** --
-- *************************************************************************** --
/*
delete from tar_tareas_notificaciones where tar_id IN  (select tar_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P92')));
delete from tev_tarea_externa_valor where tex_id IN (select tex_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P92')));
delete from ter_tarea_externa_recuperacion where tex_id IN (select tex_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P92')));
delete from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P92'));
delete from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P92'));
delete from TFI_TAREAS_FORM_ITEMS where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P92'));
delete from DD_PTP_PLAZOS_TAREAS_PLAZAS where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P92'));
delete from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P92');
*/

UPDATE DD_TAC_TIPO_ACTUACION SET BORRADO = 0 WHERE DD_TAC_ID = 21;
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P92', 'T. de confección de expedientes Sabadell', 'T. de confección de expedientes Sabadell', '', 'confeccionExpedienteSabadell', 0, 'DD', SYSDATE, 0, (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO ='03') );

-- Pantalla 1
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR,DD_TGE_ID ,TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_FAP_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P92'), 'P92_marcajeLitigio',0
,(select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP'), 'Marcar litigio',
 0, 'DD', SYSDATE, 0, 
'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_marcajeLitigio'), '5*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_marcajeLitigio'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"></p>A trav&'||'eacute;s de esta pantalla debe insertar la fecha de marcaje del litigio</div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_marcajeLitigio'), 1, 'date', 'fecha', 'Fecha de marcaje de litigio', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_marcajeLitigio'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);


-- Pantalla 2
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR,DD_TGE_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_FAP_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P92'), 'P92_validarCierreCuenta',0
,(select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP')
, 'Validar cierre de cuentas',
 0, 'DD', SYSDATE, 0, 
'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_validarCierreCuenta'), '5*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_validarCierreCuenta'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"></p>A trav&'||'eacute;s de esta pantalla debe insertar la fecha de validaci&'||'oacute;n de cierre de cuentas</div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_validarCierreCuenta'), 1, 'date', 'fecha', 'Fecha validación', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_validarCierreCuenta'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 3
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR,DD_TGE_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_FAP_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P92'), 'P92_recopilarDocumentacion',0
,(select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP')
, 'Recopilar documentación',
 0, 'DD', SYSDATE, 0, 
'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_recopilarDocumentacion'), '5*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_recopilarDocumentacion'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"></p>A trav&'||'eacute;s de esta pantalla debe insertar la fecha de recopilaci&'||'oacute;n de documentaci&'||'oacute;n</div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_recopilarDocumentacion'), 1, 'date', 'fecha', 'Fecha recopilación', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_recopilarDocumentacion'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);


-- Pantalla 3
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR,DD_TGE_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_FAP_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P92'), 'P92_generarCertificadoDeuda',0
,(select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP')
, 'Generar certificación de la deuda',
 0, 'DD', SYSDATE, 0, 
'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_generarCertificadoDeuda'), '5*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_generarCertificadoDeuda'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"></p>trav&'||'eacute;s de esta pantalla debe insertar la fecha de certificado de la deuda</div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_generarCertificadoDeuda'), 1, 'date', 'fecha', 'Fecha de certificado', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_generarCertificadoDeuda'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 4
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR,DD_TGE_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_FAP_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P92'), 'P92_mandarBurofax',0
,(select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP')
, 'Mandar burofax',
 0, 'DD', SYSDATE, 0, 
'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_mandarBurofax'), '5*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_mandarBurofax'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"></p>A trav&'||'eacute;s de esta pantalla debe insertar la fecha envio del burofax</div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_mandarBurofax'), 1, 'date', 'fecha', 'Fecha envío de burofax', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_mandarBurofax'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 5
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR,DD_TGE_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_FAP_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P92'), 'P92_certificacionNotarial',0
,(select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP')
, 'Certificación notarial',
 0, 'DD', SYSDATE, 0, 
'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_certificacionNotarial'), '5*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_certificacionNotarial'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"></p>A trav&'||'eacute;s de esta pantalla debe insertar la fecha de certificaci&'||'oacute;n notarial</div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_certificacionNotarial'), 1, 'date', 'fecha', 'Fecha certificación notarial', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_certificacionNotarial'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);


-- Pantalla 6
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR,DD_TGE_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_FAP_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P92'), 'P92_mandarExpediente',0
,(select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP')
, 'Mandar expediente',
 0, 'DD', SYSDATE, 0, 
'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_mandarExpediente'), '5*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_mandarExpediente'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"></p>A trav&'||'eacute;s de esta pantalla debe insertar la fecha de env&'||'iacute;o del expediente</div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_mandarExpediente'), 1, 'date', 'fecha', 'Fecha envio de expediente', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_mandarExpediente'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&'||'aacute; acceder al HOST de Sabadell, y proceder al marcaje a litigio de las operaciones incluidas en el asunto.</p><p style="margin-bottom: 10px">Una vez realizado el marcado, en el campo Fecha deber&'||'aacute; consignar la fecha en la que haya procedido a dicho marcado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Validar cierre de cuenta&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_marcajeLitigio');
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&'||'aacute; proceder a validar el cierre de cuenta realizado por el trasaccional de Sabadell.</p><p style="margin-bottom: 10px">En el campo fecha consignar la fecha en la que ha procedido a la validaci&'||'oacute;n del cierre de cuenta.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Recopilar documentaci&'||'oacute;n&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_validarCierreCuenta');
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&'||'aacute; proceder a la solicitud y recepci&'||'oacute;n de todos los documentos necesarios para la creaci&'||'oacute;n del expediente f&'||'iacute;sico.</p><p style="margin-bottom: 10px">Los documentos necesarios, seg&'||'uacute;n corresponda, podr&'||'aacute;n ser solicitados, tanto a las oficinas como al archivo central o al notario original de los contratos.</p><p style="margin-bottom: 10px">Una vez recibida la documentaci&'||'oacute;n, deber&'||'aacute; registrar la fecha de recepción de los mismos a trav&'||'eacute;s del campo fecha</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Cerrar cuentas&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_recopilarDocumentacion');
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&'||'aacute; proceder a generar el certificado de la deuda contra&'||'iacute;da con la entidad.</p><p style="margin-bottom: 10px">En el campo fecha, deber&'||'aacute; consignar la fecha en la que se haya generado el certificado de la deuda.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Enviar burofax&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_generarCertificadoDeuda');
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&'||'aacute; proceder al env&'||'iacute;o de Burofax a los intervinientes de los contratos asociados a la actuaci&'||'oacute;n.</p><p style="margin-bottom: 10px">En el campo fecha, deber&'||'aacute; consignar la fecha en la que se haya procedido a enviar los burofax.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar certificado notarial&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_mandarBurofax');
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&'||'aacute; proceder al env&'||'iacute;o al notario, de toda la documentación que necesite de certificado notarial.</p><p style="margin-bottom: 10px">En el campo fecha, deber&'||'aacute; consignar la fecha en la que se reciba la documentación certificada.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Enviar expediente&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_certificacionNotarial');
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&'||'aacute; proceder al env&'||'iacute;o del expediente f&'||'iacute;sico al letrado designado. El letrado asignado, se puede consultar a trav&'||'eacute;s de la pestaña Cabecera de la propia actuaci&'||'oacute;n.</p><p style="margin-bottom: 10px">En el campo fecha, deber&'||'aacute; consignar la fecha en la que envi&'||'oacute; el expediente a la oficina correspondiente al letrado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, se dar&'||'aacute; por terminada esta actuaci&'||'oacute;n, cre&'||'aacute;ndose autom&'||'aacute;ticamente una actuaci&'||'oacute;n de tipo Aceptaci&'||'oacute;n y Decisi&'||'oacute;n al letrado asignado.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_mandarExpediente');


--BPM Aceptación y Decisión
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_FAP_ID, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P92'), 'P92_BPMAceptacionYdecision', (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P61'), 0, 'Se inicia el trámite de Aceptación y Decisión', 0, 'DD', SYSDATE, 0, (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='01'), 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_BPMAceptacionYdecision'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P92_BPMAceptacionYdecision'), 0, 'label', 'titulo', 'Se inicia el trámite de Aceptación y Decisión', 0, 'DD', SYSDATE, 0);

