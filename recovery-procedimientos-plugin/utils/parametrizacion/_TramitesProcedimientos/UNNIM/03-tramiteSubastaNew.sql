--ANUNCIO SUBASTA NEW 2
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS,DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P11'), 'P11_AnuncioSubasta_new2', 0, 'Anuncio de Subasta', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea','EXTTareaProcedimiento');


update TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = '( ((valores[''P11_AnuncioSubasta_new2''][''comboResultado''] == DDSiNo.SI) && (valores[''P11_AnuncioSubasta_new2''][''fechaAnuncio''] == '''')) || ((valores[''P11_AnuncioSubasta_new2''][''comboResultado''] == DDSiNo.SI) && (valores[''P11_AnuncioSubasta_new2''][''fechaSubasta''] == '''')) )?''tareaExterna.error.faltaAlgunaFecha'':(valores[''P11_AnuncioSubasta_new2''][''comboResultado''] == DDSiNo.SI ? (isBienMarcado() ? (isAdjuntoCertificacionCarga() ? (isAdjuntoEdictoYDiligencia() ? ''null'' : ''tareaExterna.error.anuncioSubasta.faltaEdictoYDilegencia'' ):''tareaExterna.error.anuncioSubasta.faltaComprobacionCarga'') : ''tareaExterna.error.anuncioSubasta.faltaMarcarUnBien'' ) : ''null'')'
where tap_codigo = 'P11_AnuncioSubasta_new2';
update TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = '( valores[''P11_AnuncioSubasta_new2''][''comboResultado''] == DDSiNo.SI ? ''si'':''no'')'
where tap_codigo = 'P11_AnuncioSubasta_new2';

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new2'), 'damePlazo(valores[''P11_SolicitudSubasta''][''fecha'']) + 20*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new2'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez solicitada la subasta, en esta pantalla, debe consignar las fechas de anuncio y celebraci&'||'oacute;n de la misma.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Celebraci&'||'oacute;n subasta y adjudicaci&'||'oacute;n&'||'quot;</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new2'), 1, 'combo', 'comboResultado', 'Solicitud aceptada', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null &&'||' valor != '''' ? true : false', 'DDSiNo', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new2'), 2, 'date', 'fechaAnuncio', 'Fecha anuncio subasta', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new2'), 3, 'date', 'fechaSubasta', 'Fecha celebración subasta', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new2'), 4, 'currency', 'costasLetrado', 'Costas letrado', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null &&'||' valor != ''''? true : false', 'valores[''P11_SolicitudSubasta''][''costasLetrado'']', 0, 'DD',SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new2'), 5,  'currency', 'costasProcurador', 'Costas procurador', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null &&'||' valor != '''' ? true : false', 'valores[''P11_SolicitudSubasta''][''costasProcurador'']', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new2'), 6, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

--FIN ANUNCIO SUBASTA NEW 2


--VALIDAR ANUNCIO SUBASTA
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS,TAP_VIEW,DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P11'), 'P11_ValidarAnuncioSubasta', 1, 'Validar anuncio subasta', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea','plugin/procedimientos/tramiteSubasta/validarAnuncioSubasta','EXTTareaProcedimiento');


Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_ValidarAnuncioSubasta'),'1*24*60*60*1000L', 0, 'DD', SYSDATE, 0);



--update TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = '( ((valores[''P11_ValidarAnuncioSubasta''][''comboValidacion''] == DDSiNo.SI) && (valores[''P11_ValidarAnuncioSubasta''][''fechaSubasta''] == '''')) ) )?''tareaExterna.error.faltaAlgunaFecha'':((valores[''P11_ValidarAnuncioSubasta''][''comboResultado''] == DDSiNo.SI) && (valores[''P11_ValidarAnuncioSubasta''][''fechaValidacion''] == '''') ? ''tareaExterna.error.validacionSubasta.faltaFechaValidacion'' : ''null'')'
--where tap_codigo = 'P11_ValidarAnuncioSubasta';
update TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = '( valores[''P11_ValidarAnuncioSubasta''][''comboValidacion''] == DDSiNo.SI ? ''si'':''no'')'
where tap_codigo = 'P11_ValidarAnuncioSubasta';

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_ValidarAnuncioSubasta'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">VALIDAR ANUNCIO SUBASTA</p></div>'
, 0, 'DD', SYSDATE, 0);


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_ValidarAnuncioSubasta'), 1, 'date', 'fechaAnuncio', 'Fecha anuncio subasta','valores[''P11_AnuncioSubasta_new2''][''fechaAnuncio'']', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALIDACION, TFI_ERROR_VALIDACION,TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_ValidarAnuncioSubasta'), 2, 'date', 'fechaSubasta', 'Fecha celebración subasta', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valores[''P11_AnuncioSubasta_new2''][''fechaSubasta'']', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_ValidarAnuncioSubasta'), 3, 'currency', 'costasLetrado', 'Costas letrado',  'valores[''P11_AnuncioSubasta_new2''][''costasLetrado'']', 0, 'DD',SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_ValidarAnuncioSubasta'), 4,  'currency', 'costasProcurador', 'Costas procurador', 'valores[''P11_AnuncioSubasta_new2''][''costasProcurador'']', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_ValidarAnuncioSubasta'), 5, 'date', 'fechaValidacion', 'Fecha validación anuncio subasta', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_ValidarAnuncioSubasta'), 6, 'combo', 'comboValidacion', 'Solicitud aceptada', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null &&'||' valor != ''''? true : false', 'DDSiNo', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_ValidarAnuncioSubasta'), 7, 'textarea', 'observaciones', 'Observaciones','valores[''P11_AnuncioSubasta_new2''][''observaciones'']', 0, 'DD', SYSDATE, 0);

--FIN VALIDAR ANUNCIO SUBASTA

-- Pantalla P11_solicitarTasacionInterna


delete from tar_tareas_notificaciones where tar_id IN  (select tar_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_solicitarTasacionInterna'));
delete from tev_tarea_externa_valor where tex_id IN (select tex_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_solicitarTasacionInterna'));
delete from ter_tarea_externa_recuperacion where tex_id IN (select tex_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_solicitarTasacionInterna'));
delete from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_solicitarTasacionInterna');
delete from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_solicitarTasacionInterna');
delete from TFI_TAREAS_FORM_ITEMS where TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_solicitarTasacionInterna');
delete from DD_PTP_PLAZOS_TAREAS_PLAZAS where TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_solicitarTasacionInterna');
delete from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO = 'P11_solicitarTasacionInterna';

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE,DD_TGE_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P11'), 'P11_solicitarTasacionInterna',0
, 'Solicitar tasación interna',
 0, 'DD', SYSDATE, 0, 
'EXTTareaProcedimiento', (select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP'));

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_solicitarTasacionInterna'), 'damePlazo(valores[''P11_AnuncioSubasta_new2''][''fechaSubasta'']) - 35*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_solicitarTasacionInterna'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea, deber&'||'aacute; solicitar la tasaci&'||'oacute;n interna para todos los bienes marcados por el letrado. Para conocer lo bienes marcados por el letrado, debe acceder a la pestaña Bienes del procedimiento correspondiente y actuar sobre los bienes que tengan consignada la fecha de solicitud de embargo.</p><p style="margin-bottom: 10px">Una vez solicitada la tasaci&'||'oacute;n interna sobre todos los bienes, consignar la fecha en la que se haya procedido a realizar la &'||'uacute;ltima de las peticiones de tasaci&'||'oacute;n interna.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar tasaci&'||'oacute;n interna&'||'quot;.</p></div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_solicitarTasacionInterna'), 1, 'date', 'fecha', 'Fecha última solicitud', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_solicitarTasacionInterna'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

--update TAP_TAREA_PROCEDIMIENTO SET TAP_SUPERVISOR = 0
--WHERE TAP_CODIGO = 'P11_solicitarTasacionInterna';
--update TAP_TAREA_PROCEDIMIENTO SET DD_TGE_ID = (select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP')
--WHERE TAP_CODIGO = 'P11_solicitarTasacionInterna';

--update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea, deber&'||'aacute; solicitar la tasaci&'||'oacute;n interna para todos los bienes marcados por el letrado. Para conocer lo bienes marcados por el letrado, debe acceder a la pestaña Bienes del procedimiento correspondiente y actuar sobre los bienes que tengan consignada la fecha de solicitud de embargo.</p><p style="margin-bottom: 10px">Una vez solicitada la tasaci&'||'oacute;n interna sobre todos los bienes, consignar la fecha en la que se haya procedido a realizar la &'||'uacute;ltima de las peticiones de tasaci&'||'oacute;n interna.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar tasaci&'||'oacute;n interna&'||'quot;.</p></div>'
--where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_solicitarTasacionInterna');

--UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS
--SET DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P11_AnuncioSubasta_new2''][''fechaSubasta'']) - 35*24*60*60*1000L' WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_solicitarTasacionInterna')


--fin p11_solicitarTasacionInterna

--P11_REGISTRARTASACION INTERNA

-- Pantalla P11_registrarTasacionInterna


delete from tar_tareas_notificaciones where tar_id IN  (select tar_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarTasacionInterna'));
delete from tev_tarea_externa_valor where tex_id IN (select tex_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarTasacionInterna'));
delete from ter_tarea_externa_recuperacion where tex_id IN (select tex_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarTasacionInterna'));
delete from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarTasacionInterna');
delete from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarTasacionInterna');
delete from TFI_TAREAS_FORM_ITEMS where TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarTasacionInterna');
delete from DD_PTP_PLAZOS_TAREAS_PLAZAS where TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarTasacionInterna');
delete from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO = 'P11_registrarTasacionInterna';


Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE,DD_TGE_ID,TAP_SCRIPT_VALIDACION_JBPM)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P11'), 'P11_registrarTasacionInterna',0
, 'Registrar tasación interna',
 0, 'DD', SYSDATE, 0, 
'EXTTareaProcedimiento', (select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP'),'(isTasacionInternaSolicitada() ? (isAdjuntoTasacionInterna() ? ''null'' : ''tareaExterna.error.faltaTasacionInterna''): ''tareaExterna.error.solicitudTasacionInterna'')');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarTasacionInterna'), 'damePlazo(valores[''P11_AnuncioSubasta_new2''][''fechaSubasta'']) - 15*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarTasacionInterna'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"></p>A trav&'||'eacute;s de esta pantalla debe insertar la fecha de tasaci&'||'oacute;n interna</div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarTasacionInterna'), 1, 'date', 'fecha', 'Fecha última tasación', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarTasacionInterna'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);



--update TAP_TAREA_PROCEDIMIENTO SET TAP_SUPERVISOR = 0
--WHERE TAP_CODIGO = 'P11_registrarTasacionInterna';
--update TAP_TAREA_PROCEDIMIENTO SET DD_TGE_ID = (select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP')
---WHERE TAP_CODIGO = 'P11_registrarTasacionInterna';

--UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS
--SET DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P11_AnuncioSubasta_new2''][''fechaSubasta'']) - 15*24*60*60*1000L' WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarTasacionInterna')

--update TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = '(isTasacionInternaSolicitada() ? (isAdjuntoTasacionInterna() ? ''null'' : ''tareaExterna.error.faltaTasacionInterna''): ''tareaExterna.error.solicitudTasacionInterna'')'
--where tap_codigo = 'P11_registrarTasacionInterna'; 


--FIN P11_REGISTRARTASACIONINTERNA

--p11_registrar ficha subasta

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS,DTYPE,DD_TGE_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P11'), 'P11_registrarFichaSubasta', 0, 'Registrar ficha de subasta', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea','EXTTareaProcedimiento', (select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP'));


Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarFichaSubasta'),'damePlazo(valores[''P11_AnuncioSubasta_new2''][''fechaSubasta'']) - 12*24*60*60*1000L', 0, 'DD', SYSDATE, 0);



update TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = '(isAdjuntoFichaSubasta()?(isAdjuntoFichaSituacionContable() ? ''null'':''tareaExterna.error.faltaFichaSituacionContable''):''tareaExterna.error.faltaFichaSubasta'')'
where tap_codigo = 'P11_registrarFichaSubasta';

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarFichaSubasta'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">REGISTRAR FICHA SUBASTA</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarFichaSubasta'), 1, 'date', 'fecha', 'Fecha registro', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarFichaSubasta'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);



--fin p11_registrar_ficha_subasta


-- DICTAR INSTRUCCION new1

--PARA DEJAR EL ANTERIOR COMO ESTABA solo en intregracion
--UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_SUPERVISOR = 1, DD_TGE_ID = NULL,TAP_SCRIPT_VALIDACION_JBPM = NULL
--where tap_codigo = 'P11_DictarInstrucciones';

--update DD_PTP_PLAZOS_TAREAS_PLAZAS set DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P11_AnuncioSubasta''][''fechaSubasta'']) - 5*24*60*60*1000L'
-- WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_DictarInstrucciones');
-- hasta aqui PARA DEJAR EL ANTERIOR COMO ESTABA solo en intregracion
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS,DTYPE,TAP_SCRIPT_VALIDACION_JBPM,DD_TGE_ID,TAP_VIEW)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P11'), 'P11_DictarInstrucciones_new1', 0, 'Dictar instrucciones', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea','EXTTareaProcedimiento','(isInstruccionesSubastaIntroducidas()?''null'':''tareaExterna.error.instruccionesSubasta'')',(select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='SUPCEXP'),'plugin/procedimientos/tramiteSubasta/dictarInstrucciones');


Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_DictarInstrucciones_new1'), 'damePlazo(valores[''P11_AnuncioSubasta_new2''][''fechaSubasta'']) - 7*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_DictarInstrucciones_new1'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que se ha anunciado la subasta de un bien en &'||'eacute;ste procedimiento, en la pantalla vienen predeterminadas el principal de lo reclamado y la cuant&'||'iacute;a de las costas ya informadas por los externos, debiendo realizar el c&'||'aacute;lculo de los intereses e introducirlos en la pantalla.</p><p style="margin-bottom: 10px">Con todo ello se conforman las instrucciones para el  d&'||'iacute;a de la celebraci&'||'oacute;n de la subasta, tanto para el supuesto de que hubiere postores como para el contrario.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Lectura y aceptaci&'||'oacute;n de instrucciones&'||'quot; por parte del externo.</p></div>'
, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_DictarInstrucciones_new1'), 1, 'currency', 'principal', 'Principal', 'procedimientoManager.getProcedimiento(idProcedimiento).getSaldoRecuperacion()', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_DictarInstrucciones_new1'), 2, 'currency', 'costasLetrado', 'Costas letrado','valores[''P11_SolicitudSubasta''][''costasLetrado'']', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_DictarInstrucciones_new1'), 3, 'currency', 'costasProcurador', 'Costas procurador', 'valores[''P11_SolicitudSubasta''][''costasProcurador'']', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_DictarInstrucciones_new1'), 4, 'currency', 'intereses', 'Intereses', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_DictarInstrucciones_new1'), 5, 'currency', 'limiteConPostores', 'Límite si hay postores', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_DictarInstrucciones_new1'), 6, 'combo', 'intSinPostores', 'Ins. sin postores', 'DDPostores2', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_DictarInstrucciones_new1'), 7, 'currency', 'importe', 'Importe', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_DictarInstrucciones_new1'), 8, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);


--UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS
--SET DD_PTP_PLAZO_SCRIPT = 'valores[''P11_AnuncioSubasta_new1''] == null ? damePlazo(valores[''P11_AnuncioSubasta_new2''][''fechaSubasta''])  - 7*24*60*60*1000L : damePlazo(valores[''P11_AnuncioSubasta_new1''][''fechaSubasta'']) - 7*24*60*60*1000L' WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_DictarInstrucciones')
--UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P11_AnuncioSubasta_new1''][''fechaSubasta'']) - 7*24*60*60*1000L' WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_DictarInstrucciones')


--update TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = '(isInstruccionesSubastaIntroducidas()?''null'':''tareaExterna.error.instruccionesSubasta'')'
--where tap_codigo = 'P11_DictarInstrucciones';

--update TAP_TAREA_PROCEDIMIENTO SET TAP_SUPERVISOR = 0
--where tap_codigo = 'P11_DictarInstrucciones';
--update TAP_TAREA_PROCEDIMIENTO SET DD_TGE_ID = (select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='SUPCEXP')
--where tap_codigo = 'P11_DictarInstrucciones';

--FIN  DICTAR INSTRUCCIONES new1

--UPDATES PARA CELEBRACIÓN SUBASTA
update TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = '(isAdjuntoResultadoSubasta()?''null'':''tareaExterna.error.faltaResultadoSubasta'')'
where tap_codigo = 'P11_CelebracionSubasta';
update DD_PTP_PLAZOS_TAREAS_PLAZAS set dd_ptp_plazo_script =  'valores[''P11_AnuncioSubasta_new1''] == null ? damePlazo(valores[''P11_AnuncioSubasta_new2''][''fechaSubasta'']) : damePlazo(valores[''P11_AnuncioSubasta_new1''][''fechaSubasta''])'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_CelebracionSubasta');

--FIN UPDATES PARA CELEBRACION SUBASTA

--nuevos tipos de adjuntos

Insert into UN001.DD_TFA_FICHERO_ADJUNTO
   (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (4, 'TI', 'TASACION INTERNA', 'TASACION INTERNA', 0, 'DD', SYSDATE, 0);
Insert into UN001.DD_TFA_FICHERO_ADJUNTO
   (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (5, 'RS', 'RESULTADO DE SUBASTA', 'RESULTADO DE SUBASTA', 0, 'DD', SYSDATE, 0);
insert into UN001.DD_TFA_FICHERO_ADJUNTO
   (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (6, 'ED', 'EDICTO Y DILIGENCIA DE SUBASTA', 'EDICTO Y DILIGENCIA DE SUBASTA', 0, 'DD', SYSDATE, 0);
insert into UN001.DD_TFA_FICHERO_ADJUNTO
   (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (7, 'FS', 'FICHA DE SUBASTA', 'FICHA DE SUBASTA', 0, 'DD', SYSDATE, 0);
insert into UN001.DD_TFA_FICHERO_ADJUNTO
   (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (8, 'SC', 'FICHA DE SITUACION CONTABLE', 'FICHA DE SITUACION CONTABLE', 0, 'DD', SYSDATE, 0);   

   
--INSTRUCCIONES TAREAS
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debemos consignar la fecha de presentaci&'||'oacute;n en el juzgado del escrito solicitando la subasta del bien.</p><p style="margin-bottom: 10px">Al mismo tiempo, tenemos la opción de introducir tanto el importe de las costas del letrado director del asunto as&'||'iacute; como los suplidos del procurador.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Anuncio de subasta&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_SolicitudSubasta');
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez solicitada la subasta, en esta pantalla debe indicar el resultado de dicha solicitud, en caso de haber sido aceptada deber&'||'aacute; consignar las fechas de anuncio y celebraci&'||'oacute;n de la misma.</p><p style="margin-bottom: 10px">Al mismo tiempo, tenemos la opción de introducir tanto el importe de las costas del letrado director del asunto as&'||'iacute; como los suplidos del procurador.</p>
<p style="margin-bottom: 10px">Tenga en cuenta, que en caso de que se haya aceptado la subasta, para poder terminar esta tarea debe cumplir los siguientes requisitos:
<ul style="list-style-type: square;">
<li style="margin-bottom: 10px; margin-left: 35px;">Haber registrado los bienes sobre los que se acude a la subasta y haber consignado la fecha de certificaci&'||'oacute;n de cargas en cada uno de los bienes afectados.</li>
<li style="margin-bottom: 10px; margin-left: 35px;">Haber adjuntado el documento Tasaci&'||'oacute;n de costas, a trav&'||'eacute;s de la pestaña Adjuntos del procedimiento.</li>
<li style="margin-bottom: 10px; margin-left: 35px;">Haber adjuntado el documento Certificaci&'||'oacute;n de cargas, a trav&'||'eacute;s de la pestaña Adjuntos del procedimiento.</li></ul>
<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute;, si ha sido aceptada la solicitud de subasta "Celebraci&'||'oacute;n subasta y adjudicaci&'||'oacute;n" y "Solicitar tasaci&'||'oacute;n interna" por parte del supervisor. Si no ha sido admitida la solicitud se le abrir&'||'aacute; tarea en la que propondr&'||'aacute;, seg&'||'uacute;n su criterio, la siguiente actuaci&'||'oacute;n al responsable de la entidad.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new2');
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea, deber&'||'aacute; solicitar la tasaci&'||'oacute;n interna para todos los bienes marcados por el letrado mediante la fecha de certificaci&'||'oacute;n de cargas. Para conocer lo bienes marcados por el letrado, debe acceder a la pestaña Bienes del procedimiento correspondiente y actuar sobre los bienes que tengan consignada la fecha de solicitud de embargo.</p><p style="margin-bottom: 10px">Una vez solicitada la tasaci&'||'oacute;n interna sobre todos los bienes, consignar la fecha en la que se haya procedido a realizar la &'||'uacute;ltima de las peticiones de tasaci&'||'oacute;n interna.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar tasaci&'||'oacute;n interna&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_solicitarTasacionInterna');
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea, deber&'||'aacute; registrar la fecha de tasación y el importe de la misma, en cada uno de los bienes donde haya marcado el letrado la fecha de certificaci&'||'oacute;n de cargas. Para conocer lo bienes marcados por el letrado, debe acceder a la pestaña Bienes del procedimiento correspondiente y actuar sobre los bienes que tengan consignada la fecha de solicitud de embargo.</p><p style="margin-bottom: 10px">Una vez consignados los datos de la tasación en cada uno de los bienes, consignar la fecha en la que haya recivido la última de las tasaciones.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar fecha de subasta&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarTasacionInterna');

update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&'||'eacute;s de esta pantalla deber&'||'aacute; validar los datos introducidos por el letrado, una vez comprobados deber&'||'aacute; indicar si aprueba o no la correcta introducci&'||'oacute;n de los mismos en la herramienta.</p>
<p style="margin-bottom: 10px">Para dar por terminada esta tarea deber&'||'aacute; realizar las siguientes comprobaciones:
<ul style="list-style-type: square;">
<li style="margin-bottom: 10px; margin-left: 35px;">Que en la pestaña de adjuntos del procedimiento figuran los documentos exigidos (Edicto y Diligencia de la Subasta y Certificaci&'||'oacute;n de cargas de cada una de las fincas a subastar).</li>
<li style="margin-bottom: 10px; margin-left: 35px;">Que cada uno de los bienes a subastar están dados de alta, a trav&'||'eacute;s de la pestaña de Bienes del procedimiento y que se corresponde con la informaci&'||'oacute;n de los documentos adjuntos citados.</li>
<li style="margin-bottom: 10px; margin-left: 35px;">Que el resto de la informaci&'||'oacute;n esta marcada y en particular, por su especial relevancia para el resto del proceso, que la fecha de celebraci&'||'oacute;n de subasta se corresponde con lo figurado en las Diligencias del Juzgado.</li></ul>
<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute;, si ha dado por v&'||'aacute;lida la introducci&'||'oacute;n de datos para la subasta "Celebraci&'||'oacute;n subasta" y &'||'quot;Solicitar tasaci&'||'oacute;n interna&'||'quot;, en caso contrario se lanzar&'||'aacute; la tarea &'||'quot;Anuncio de subasta&'||'quot; a rellenar por el letrado asignado al procedimiento.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_ValidarAnuncioSubasta');


update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea, deber&'||'aacute; adjuntar al procedimiento los documetnos "Ficha de subasta" y "Ficha de situación obtenida de los diferentes sistemas de Unnim".</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Dictar instrucciones por el experto en subastas&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarFichaSubasta');

