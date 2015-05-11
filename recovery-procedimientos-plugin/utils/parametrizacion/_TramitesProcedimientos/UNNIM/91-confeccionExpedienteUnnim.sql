-- *************************************************************************** --
-- **                   BPM Trámite de aceptación y decisión                ** --
-- *************************************************************************** --
/*
delete from tar_tareas_notificaciones where tar_id IN  (select tar_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P91')));
delete from tev_tarea_externa_valor where tex_id IN (select tex_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P91')));
delete from ter_tarea_externa_recuperacion where tex_id IN (select tex_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P91')));
delete from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P91'));
delete from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P91'));
delete from TFI_TAREAS_FORM_ITEMS where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P91'));
delete from DD_PTP_PLAZOS_TAREAS_PLAZAS where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P91'));
delete from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P91');
*/

UPDATE DD_TAC_TIPO_ACTUACION SET BORRADO = 0 WHERE DD_TAC_ID = 21;
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P91', 'T. de confección de expedientes UNNIM', 'T. de confección de expedientes UNNIM', '', 'confeccionExpedienteUnnim', 0, 'DD', SYSDATE, 0, (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO ='03') );

-- Pantalla 1
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR,DD_TGE_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_FAP_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P91'), 'P91_recopilarDocumentacion',0
,(select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP')
, 'Recopilar documentación',
 0, 'DD', SYSDATE, 0, 
'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_recopilarDocumentacion'), '3*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_recopilarDocumentacion'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"></p>A trav&'||'eacute;s de esta pantalla debe insertar la fecha de recopilaci&'||'oacute;n de documentaci&'||'oacute;n</div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_recopilarDocumentacion'), 1, 'date', 'fecha', 'Fecha recopilación', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_recopilarDocumentacion'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 2
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR,DD_TGE_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_FAP_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P91'), 'P91_recepcionDocumentos',0
,(select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP')
, 'Registrar documentación',
 0, 'DD', SYSDATE, 0, 
'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_recepcionDocumentos'), '5*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_recepcionDocumentos'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"></p>A trav&'||'eacute;s de esta pantalla debe insertar la fecha de recopilaci&'||'oacute;n de documentaci&'||'oacute;n</div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_recepcionDocumentos'), 1, 'date', 'fecha', 'Fecha recopilación', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_recepcionDocumentos'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- pantalla 3 ELIMINADA
--Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR,DD_TGE_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_FAP_ID)
--Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P91'), 'P91_MarcarAgenda9514',0
--,(select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP')
--, 'Marcar agenda de mora + 9514',
-- 0, 'DD', SYSDATE, 0, 
--'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));
--
--Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
--Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_MarcarAgenda9514'), '3*24*60*60*1000L', 0, 'DD', SYSDATE, 0);
--
--Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
--Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_MarcarAgenda9514'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"></p>A trav&'||'eacute;s de esta pantalla debe insertar la fecha de recopilaci&'||'oacute;n de documentaci&'||'oacute;n</div>', 0, 'DD', SYSDATE, 0);
--Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
--Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_MarcarAgenda9514'), 1, 'date', 'fecha', 'Fecha recopilación', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
--Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
--Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_MarcarAgenda9514'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 4
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR,DD_TGE_ID ,TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_FAP_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P91'), 'P91_bloquearCuentas',0
,(select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP'), 'Bloquear cuentas',
 0, 'DD', SYSDATE, 0, 
'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_bloquearCuentas'), '3*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_bloquearCuentas'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"></p>A trav&'||'eacute;s de esta pantalla debe insertar la fecha de marcaje del litigio</div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_bloquearCuentas'), 1, 'date', 'fecha', 'Fecha de marcaje de litigio', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_bloquearCuentas'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 5
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR,DD_TGE_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_FAP_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P91'), 'P91_generarCertificadoDeuda',0
,(select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP')
, 'Generar certificación de la deuda',
 0, 'DD', SYSDATE, 0, 
'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_generarCertificadoDeuda'), '3*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_generarCertificadoDeuda'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"></p>trav&'||'eacute;s de esta pantalla debe insertar la fecha de certificado de la deuda</div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_generarCertificadoDeuda'), 1, 'date', 'fecha', 'Fecha de certificado', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_generarCertificadoDeuda'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 6
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR,DD_TGE_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_FAP_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P91'), 'P91_certificacionNotarial',0
,(select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP')
, 'Registrar certificación notarial',
 0, 'DD', SYSDATE, 0, 
'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_certificacionNotarial'), '3*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_certificacionNotarial'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"></p>trav&'||'eacute;s de esta pantalla debe insertar la fecha de certificado de la deuda</div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_certificacionNotarial'), 1, 'date', 'fecha', 'Fecha de recepción', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_certificacionNotarial'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 7
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR,DD_TGE_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_FAP_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P91'), 'P91_mandarBurofax',0
,(select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP')
, 'Mandar burofax',
 0, 'DD', SYSDATE, 0, 
'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_mandarBurofax'), '3*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_mandarBurofax'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"></p>A trav&'||'eacute;s de esta pantalla debe insertar la fecha envio del burofax</div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_mandarBurofax'), 1, 'date', 'fecha', 'Fecha envío de burofax', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_mandarBurofax'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 8
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR,DD_TGE_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_FAP_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P91'), 'P91_registrarAcuseRecibo',0
,(select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP')
, 'Registrar acuse de recibo',
 0, 'DD', SYSDATE, 0, 
'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_registrarAcuseRecibo'), '3*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_registrarAcuseRecibo'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"></p>A trav&'||'eacute;s de esta pantalla debe insertar la fecha envio del burofax</div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_registrarAcuseRecibo'), 1, 'date', 'fecha', 'Fecha envío de burofax', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_registrarAcuseRecibo'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 9
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR,DD_TGE_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_FAP_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P91'), 'P91_mandarExpediente',0
,(select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP')
, 'Enviar expediente',
 0, 'DD', SYSDATE, 0, 
'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_mandarExpediente'), '1*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_mandarExpediente'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"></p>A trav&'||'eacute;s de esta pantalla debe insertar la fecha de env&'||'iacute;o del expediente</div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_mandarExpediente'), 1, 'date', 'fecha', 'Fecha envio de expediente', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_mandarExpediente'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 10 ELIMINADA
--Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR,DD_TGE_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_FAP_ID)
--Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P91'), 'P91_marcarAgenda9515',0
--,(select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP')
--, 'Marcar agenda de mora + 9515',
-- 0, 'DD', SYSDATE, 0, 
--'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));
--
--Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
--Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_marcarAgenda9515'), '1*24*60*60*1000L', 0, 'DD', SYSDATE, 0);
--
--Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
--Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_marcarAgenda9515'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"></p>A trav&'||'eacute;s de esta pantalla debe insertar la fecha de env&'||'iacute;o del expediente</div>', 0, 'DD', SYSDATE, 0);
--Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
--Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_marcarAgenda9515'), 1, 'date', 'fecha', 'Fecha envio de expediente', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
--Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
--Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_marcarAgenda9515'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);


--BPM Aceptación y Decisión
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_FAP_ID, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P91'), 'P91_BPMAceptacionYdecision', (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P61'), 0, 'Se inicia el trámite de Aceptación y Decisión', 0, 'DD', SYSDATE, 0, (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='01'), 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_BPMAceptacionYdecision'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_BPMAceptacionYdecision'), 0, 'label', 'titulo', 'Se inicia el trámite de Aceptación y Decisión', 0, 'DD', SYSDATE, 0);




--update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&'||'aacute; acceder al HOST de UNNIM, y proceder al marcado en la agenda de mora, as&'||'iacute; como establecer la oficina gestora 9514 para los contratos vinculados al asunto correspondiente.</p><p style="margin-bottom: 10px">En el campo Fecha deber&'||'aacute; consignar la fecha en la que haya procedido a dicho marcado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y todas las dem&'||'aacute;s correspondientes a esta actuaci&'||'oacute;n, se inciar&'||'aacute;n las tareas &'||'quot;Enviar expediente&'||'quot; y &'||'quot;Marcar agenda de mora + 9515&'||'quot;.</p></div>'
--where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_MarcarAgenda9514');
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&'||'aacute; proceder a la solicitud de todos los documentos necesarios para la creaci&'||'oacute;n del expediente f&'||'iacute;sico.</p><p style="margin-bottom: 10px">Los documentos necesarios, seg&'||'uacute;n corresponda, podr&'||'aacute;n ser solicitados, tanto a las oficinas como al archivo central o al notario original de los contratos.</p><p style="margin-bottom: 10px">En el campo Fecha, deber&'||'aacute; introducir la fecha en la que haya procedido a realizar la solicitud de documentaci&'||'oacute;n</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar documentaci&'||'oacute;&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_recopilarDocumentacion');
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&'||'aacute; escanear toda la documetnaci&'||'oacute;n recivida a trav&'||'eacute;s de la pestaña Adjuntos de la actuaci&'||'oacute;n correspondiente.</p><p style="margin-bottom: 10px">Una vez recibida la documentaci&'||'oacute;n, deber&'||'aacute; registrar la fecha de recepción de los mismos a trav&'||'eacute;s del campo fecha</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y todas las dem&'||'aacute;s correspondientes a esta actuaci&'||'oacute;n, se inciar&'||'aacute;n la tarea &'||'quot;Enviar expediente&'||'quot; .</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_recepcionDocumentos');
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&'||'aacute; acceder al HOST de UNNIM, y proceder al bloqueo de los contratos asociados al asunto correspondiente.</p><p style="margin-bottom: 10px">Una vez bloqueadas las cuentas deber&'||'aacute; registrar la fecha en la que haya realizado dicho bloqueo.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se inciar&'||'aacute;n las tareas &'||'quot;Generar certificado de deuda&'||'quot; y &'||'quot;Enviar Burofax&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_bloquearCuentas');
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&'||'aacute; proceder a generar el certificado de la deuda contra&'||'iacute;da con la entidad.</p><p style="margin-bottom: 10px">En el campo fecha, deber&'||'aacute; consignar la fecha en la que se haya generado el certificado de la deuda.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar certificaci&'||'oacute;n notarial&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_generarCertificadoDeuda');
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&'||'aacute; esperar a recibir la certificaci&'||'oacute;n notarial correspondiente.</p><p style="margin-bottom: 10px">En el campo fecha, deber&'||'aacute; consignar la fecha en la que se reciba la propia certificaci&'||'oacute;n notarial.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y todas las dem&'||'aacute;s correspondientes a esta actuaci&'||'oacute;n, se inciar&'||'aacute;n la tarea &'||'quot;Enviar expediente&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_certificacionNotarial');
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&'||'aacute; proceder al env&'||'iacute;o de Burofax a los intervinientes de los contratos asociados a la actuaci&'||'oacute;n.</p><p style="margin-bottom: 10px">En el campo fecha, deber&'||'aacute; consignar la fecha en la que se haya procedido a enviar los burofax.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar acuse de recibo&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_mandarBurofax');
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&'||'aacute; esperar a recibir todos los acuses de recibos correspondientes a los burofaxes enviados en la tarea anterior.</p><p style="margin-bottom: 10px">En el campo fecha, deber&'||'aacute; consignar la fecha en la que haya recivido el último de los acuses de recibo</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y todas las dem&'||'aacute;s correspondientes a esta actuaci&'||'oacute;n, la siguiente tarea ser&'||'aacute; &'||'quot;Enviar expediente&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_registrarAcuseRecibo');
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&'||'aacute; proceder al env&'||'iacute;o del expediente f&'||'iacute;sico al letrado designado. El letrado asignado, se puede consultar a trav&'||'eacute;s de la pestaña Cabecera de la propia actuaci&'||'oacute;n.</p><p style="margin-bottom: 10px">En el campo fecha, deber&'||'aacute; consignar la fecha en la que envi&'||'oacute; el expediente a la oficina correspondiente al letrado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez cumplida esta tarea  se dar&'||'aacute; por terminada esta actuaci&'||'oacute;n, cre&'||'aacute;ndose autom&'||'aacute;ticamente una actuaci&'||'oacute;n de tipo Aceptaci&'||'oacute;n y Decisi&'||'oacute;n al letrado asignado.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_mandarExpediente');
--update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&'||'aacute; acceder al HOST de UNNIM, y proceder al marcado en la agenda de mora, as&'||'iacute; como establecer la oficina gestora 9515 para los contratos vinculados al asunto correspondiente.</p><p style="margin-bottom: 10px">En el campo Fecha deber&'||'aacute; consignar la fecha en la que haya procedido a dicho marcado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez cumplida esta tarea y la tarea &'||'quot;Enviar expediente&'||'quot;, se dar&'||'aacute; por terminada esta actuaci&'||'oacute;n, cre&'||'aacute;ndose autom&'||'aacute;ticamente una actuaci&'||'oacute;n de tipo Aceptaci&'||'oacute;n y Decisi&'||'oacute;n al letrado asignado.</p></div>'
--where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P91_marcarAgenda9515');



delete from tar_tareas_notificaciones where tar_id IN  (select tar_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P91_MarcarAgenda9514'));
delete from tev_tarea_externa_valor where tex_id IN (select tex_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P91_MarcarAgenda9514'));
delete from ter_tarea_externa_recuperacion where tex_id IN (select tex_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P91_MarcarAgenda9514'));
delete from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P91_MarcarAgenda9514');
delete from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P91_MarcarAgenda9514');
delete from TFI_TAREAS_FORM_ITEMS where tap_id IN  (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P91_MarcarAgenda9514');
delete from DD_PTP_PLAZOS_TAREAS_PLAZAS where tap_id IN  (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P91_MarcarAgenda9514');
delete from TAP_TAREA_PROCEDIMIENTO  where tap_codigo = 'P91_MarcarAgenda9514';
commit;

delete from tar_tareas_notificaciones where tar_id IN  (select tar_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P91_MarcarAgenda9515'));
delete from tev_tarea_externa_valor where tex_id IN (select tex_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P91_MarcarAgenda9515'));
delete from ter_tarea_externa_recuperacion where tex_id IN (select tex_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P91_MarcarAgenda9515'));
delete from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P91_MarcarAgenda9515');
delete from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P91_MarcarAgenda9515');
delete from TFI_TAREAS_FORM_ITEMS where tap_id IN  (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P91_MarcarAgenda9515');
delete from DD_PTP_PLAZOS_TAREAS_PLAZAS where tap_id IN  (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P91_MarcarAgenda9515');
delete from TAP_TAREA_PROCEDIMIENTO  where tap_codigo = 'P91_MarcarAgenda9515';
commit;