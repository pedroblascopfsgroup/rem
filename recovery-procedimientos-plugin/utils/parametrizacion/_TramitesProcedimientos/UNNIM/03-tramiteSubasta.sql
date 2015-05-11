-- *************************************************************************** --
-- **                        BPM Tramite de subasta                         ** --
-- *************************************************************************** --


update TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = '( ((valores[''P11_AnuncioSubasta_new1''][''comboResultado''] == DDSiNo.SI) && (valores[''P11_AnuncioSubasta_new1''][''fechaAnuncio''] == '''')) || ((valores[''P11_AnuncioSubasta_new1''][''comboResultado''] == DDSiNo.SI) && (valores[''P11_AnuncioSubasta_new1''][''fechaSubasta''] == '''')) )?''tareaExterna.error.faltaAlgunaFecha'':(valores[''P11_AnuncioSubasta_new1''][''comboResultado''] == DDSiNo.SI ? (isBienMarcado() ? (isAdjuntoCertificacionCarga() ? (isAdjuntoTasacionCostas() ? ''null'' : ''tareaExterna.error.anuncioSubasta.faltaTasacionCostas'' ):''tareaExterna.error.anuncioSubasta.faltaComprobacionCarga'') : ''tareaExterna.error.anuncioSubasta.faltaMarcarUnBien'' ) : ''null'')'
where tap_codigo = 'P11_AnuncioSubasta_new1';

-- Pantalla P11_solicitarTasacionInterna

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P11'), 'P11_solicitarTasacionInterna',1
, 'Solicitar tasación interna',
 0, 'DD', SYSDATE, 0, 
'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_solicitarTasacionInterna'), 'damePlazo(valores[''P11_AnuncioSubasta_new2''][''fechaSubasta'']) - 35*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_solicitarTasacionInterna'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"></p>A trav&'||'eacute;s de esta pantalla debe insertar la fecha de recopilaci&'||'oacute;n de documentaci&'||'oacute;n</div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_solicitarTasacionInterna'), 1, 'date', 'fecha', 'Fecha última solicitud', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_solicitarTasacionInterna'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

update TAP_TAREA_PROCEDIMIENTO SET TAP_SUPERVISOR = 0
WHERE TAP_CODIGO = 'P11_solicitarTasacionInterna';
update TAP_TAREA_PROCEDIMIENTO SET DD_TGE_ID = (select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP')
WHERE TAP_CODIGO = 'P11_solicitarTasacionInterna';

-- Pantalla P11_registrarTasacionInterna

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P11'), 'P11_registrarTasacionInterna',1
, 'Registrar tasación interna',
 0, 'DD', SYSDATE, 0, 
'EXTTareaProcedimiento', (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='09'));

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarTasacionInterna'), 'damePlazo(valores[''P11_AnuncioSubasta_new2''][''fechaSubasta'']) - 10*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarTasacionInterna'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px"></p>A trav&'||'eacute;s de esta pantalla debe insertar la fecha de tasaci&'||'oacute;n interna</div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarTasacionInterna'), 1, 'date', 'fecha', 'Fecha última tasación', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarTasacionInterna'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);


update TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = '(isTasacionInternaSolicitada() ? ''null'': ''tareaExterna.error.solicitudTasacionInterna'')'
where tap_codigo = 'P11_registrarTasacionInterna';

update TAP_TAREA_PROCEDIMIENTO SET TAP_SUPERVISOR = 0
WHERE TAP_CODIGO = 'P11_registrarTasacionInterna';
update TAP_TAREA_PROCEDIMIENTO SET DD_TGE_ID = (select dd_tge_id from unmaster.dd_tge_tipo_gestor where dd_tge_codigo='GECEXP')
WHERE TAP_CODIGO = 'P11_registrarTasacionInterna';

update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debemos consignar la fecha de presentaci&'||'oacute;n en el juzgado del escrito solicitando la subasta del bien.</p><p style="margin-bottom: 10px">Al mismo tiempo, tenemos la opción de introducir tanto el importe de las costas del letrado director del asunto as&'||'iacute; como los suplidos del procurador.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Anuncio de subasta&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_SolicitudSubasta');
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez solicitada la subasta, en esta pantalla debe indicar el resultado de dicha solicitud, en caso de haber sido aceptada deber&'||'aacute; consignar las fechas de anuncio y celebraci&'||'oacute;n de la misma.</p><p style="margin-bottom: 10px">Al mismo tiempo, tenemos la opción de introducir tanto el importe de las costas del letrado director del asunto as&'||'iacute; como los suplidos del procurador.</p>
<p style="margin-bottom: 10px">Tenga en cuenta, que en caso de que se haya aceptado la subasta, para poder terminar esta tarea debe cumplir los siguientes requisitos:
<ul style="list-style-type: square;">
<li style="margin-bottom: 10px; margin-left: 35px;">Haber registrado los bienes sobre los que se acude a la subasta y haber consignado la fecha de solicitud de embargo en cada uno de los bienes afectados.</li>
<li style="margin-bottom: 10px; margin-left: 35px;">Haber adjuntado el documento Tasaci&'||'oacute;n de costas, a trav&'||'eacute;s de la pestaña Adjuntos del procedimiento.</li>
<li style="margin-bottom: 10px; margin-left: 35px;">Haber adjuntado el documento Certificaci&'||'oacute;n de cargas, a trav&'||'eacute;s de la pestaña Adjuntos del procedimiento.</li></ul>
<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute;, si ha sido aceptada la solicitud de subasta "Celebraci&'||'oacute;n subasta y adjudicaci&'||'oacute;n" y "Solicitar tasaci&'||'oacute;n interna" por parte del supervisor. Si no ha sido admitida la solicitud se le abrir&'||'aacute; tarea en la que propondr&'||'aacute;, seg&'||'uacute;n su criterio, la siguiente actuaci&'||'oacute;n al responsable de la entidad.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new1');
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea, deber&'||'aacute; solicitar la tasaci&'||'oacute;n interna para todos los bienes marcados por el letrado. Para conocer lo bienes marcados por el letrado, debe acceder a la pestaña Bienes del procedimiento correspondiente y actuar sobre los bienes que tengan consignada la fecha de solicitud de embargo.</p><p style="margin-bottom: 10px">Una vez solicitada la tasaci&'||'oacute;n interna sobre todos los bienes, consignar la fecha en la que se haya procedido a realizar la &'||'uacute;ltima de las peticiones de tasaci&'||'oacute;n interna.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar tasaci&'||'oacute;n interna&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_solicitarTasacionInterna');
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea, deber&'||'aacute; registrar la fecha de tasación y el importe de la misma, en cada uno de los bienes donde haya marcado el letrado la fecha de solicitud de embargo. Para conocer lo bienes marcados por el letrado, debe acceder a la pestaña Bienes del procedimiento correspondiente y actuar sobre los bienes que tengan consignada la fecha de solicitud de embargo.</p><p style="margin-bottom: 10px">Una vez consignados los datos de la tasación en cada uno de los bienes, consignar la fecha en la que haya recivido la última de las tasaciones.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Dictar instrucciones por el experto en subastas&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarTasacionInterna');


--UPDATES A REALIZAR CON EL NUEVO TRÁMITE (PARA LOCAL E INTREGRACION)
UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS
SET DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P11_AnuncioSubasta_new1''][''fechaSubasta'']) - 35*24*60*60*1000L' WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_solicitarTasacionInterna')

UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS
SET DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P11_AnuncioSubasta_new1''][''fechaSubasta'']) - 15*24*60*60*1000L' WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarTasacionInterna')


Insert into UN001.DD_TFA_FICHERO_ADJUNTO
   (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (4, 'TI', 'TASACION INTERNA', 'TASACION INTERNA', 0, 'DD', TO_TIMESTAMP('12/04/2012 0:00:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);


 update TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = '( ((valores[''P11_AnuncioSubasta_new1''][''comboResultado''] == DDSiNo.SI) && (valores[''P11_AnuncioSubasta_new1''][''fechaAnuncio''] == '''')) || ((valores[''P11_AnuncioSubasta_new1''][''comboResultado''] == DDSiNo.SI) && (valores[''P11_AnuncioSubasta_new1''][''fechaSubasta''] == '''')) )?''tareaExterna.error.faltaAlgunaFecha'':(valores[''P11_AnuncioSubasta_new1''][''comboResultado''] == DDSiNo.SI ? (isBienMarcado() ? (isAdjuntoCertificacionCarga() ? (isAdjuntoTasacionCostas() ? ''null'' : ''tareaExterna.error.anuncioSubasta.faltaTasacionCostas'' ):''tareaExterna.error.anuncioSubasta.faltaComprobacionCarga'') : ''tareaExterna.error.anuncioSubasta.faltaMarcarUnBien'' ) : ''null'')'
where tap_codigo = 'P11_AnuncioSubasta_new1';
   
update TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = '(isTasacionInternaSolicitada() ? (isAdjuntoTasacionInterna() ? ''null'' : ''tareaExterna.error.faltaTasacionInterna''): ''tareaExterna.error.solicitudTasacionInterna'')'
where tap_codigo = 'P11_registrarTasacionInterna';   

UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS
SET DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P11_AnuncioSubasta''][''fechaSubasta'']) - 7*24*60*60*1000L' WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_DictarInstrucciones')


update TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = '(isInstruccionesSubastaIntroducidas()?''null'':''tareaExterna.error.instruccionesSubasta'')'
where tap_codigo = 'P11_DictarInstrucciones';

Insert into UN001.DD_TFA_FICHERO_ADJUNTO
   (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (5, 'RS', 'RESULTADO DE SUBASTA', 'RESULTADO DE SUBASTA', 0, 'DD', TO_TIMESTAMP('12/04/2012 0:00:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);



update TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = '(isAdjuntoResultadoSubasta()?''null'':''tareaExterna.error.faltaResultadoSubasta'')'
where tap_codigo = 'P11_CelebracionSubasta';


--ANUNCIO SUBASTA NEW 2
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P11'), 'P11_AnuncioSubasta_new2', 0, 'Anuncio de Subasta', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');

insert into UN001.DD_TFA_FICHERO_ADJUNTO
   (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (6, 'ED', 'EDICTO Y DILIGENCIA DE SUBASTA', 'EDICTO Y DILIGENCIA DE SUBASTA', 0, 'DD', TO_TIMESTAMP('13/04/2012 0:00:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);

update TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = '( ((valores[''P11_AnuncioSubasta_new1''][''comboResultado''] == DDSiNo.SI) && (valores[''P11_AnuncioSubasta_new1''][''fechaAnuncio''] == '''')) || ((valores[''P11_AnuncioSubasta_new1''][''comboResultado''] == DDSiNo.SI) && (valores[''P11_AnuncioSubasta_new1''][''fechaSubasta''] == '''')) )?''tareaExterna.error.faltaAlgunaFecha'':(valores[''P11_AnuncioSubasta_new1''][''comboResultado''] == DDSiNo.SI ? (isBienMarcado() ? (isAdjuntoCertificacionCarga() ? (isAdjuntoEdictoYDiligencia() ? ''null'' : ''tareaExterna.error.anuncioSubasta.faltaEdictoYDilegencia'' ):''tareaExterna.error.anuncioSubasta.faltaComprobacionCarga'') : ''tareaExterna.error.anuncioSubasta.faltaMarcarUnBien'' ) : ''null'')'
where tap_codigo = 'P11_AnuncioSubasta_new2';


Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new2'), 'damePlazo(valores[''P11_SolicitudSubasta''][''fecha'']) + 20*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new2'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez solicitada la subasta, en esta pantalla, debe consignar las fechas de anuncio y celebraci&'||'oacute;n de la misma.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Celebraci&'||'oacute;n subasta y adjudicaci&'||'oacute;n&'||'quot;</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new2'), 1, 'combo', 'comboResultado', 'Solicitud aceptada', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '' ? true : false', 'DDSiNo', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new2'), 2, 'date', 'fechaAnuncio', 'Fecha anuncio subasta', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new2'), 3, 'date', 'fechaSubasta', 'Fecha celebración subasta', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALIDACION, TFI_ERROR_VALIDACION,TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new2'), 4, 'currency', 'costasLetrado', 'Costas letrado', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '' ? true : false', 'valores[''P11_SolicitudSubasta''][''costasLetrado'']', 0, 'DD',SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALIDACION, TFI_ERROR_VALIDACION,TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new2'), 5,  'currency', 'costasProcurador', 'Costas procurador', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '' ? true : false', 'valores[''P11_SolicitudSubasta''][''costasProcurador'']', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new2'), 6, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);


--VALIDAR ANUNCIO SUBASTA
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS,TAP_VIEW)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P11'), 'P11_ValidarAnuncioSubasta', 1, 'Validar anuncio subasta', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea','plugin/procedimientos/tramiteSubasta/validarAnuncioSubasta');


Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_ValidarAnuncioSubasta'),'1*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

update TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = '( ((valores[''P11_ValidarAnuncioSubasta''][''comboValidacion''] == DDSiNo.SI) && (valores[''P11_ValidarAnuncioSubasta''][''fechaSubasta''] == '''')) ) )?''tareaExterna.error.faltaAlgunaFecha'':((valores[''P11_ValidarAnuncioSubasta''][''comboResultado''] == DDSiNo.SI) && (valores[''P11_ValidarAnuncioSubasta''][''fechaValidacion''] == '''') ? ''tareaExterna.error.validacionSubasta.faltaFechaValidacion'' : ''null'')'
where tap_codigo = 'P11_ValidarAnuncioSubasta';

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new2'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">VALIDAR ANUNCIO SUBASTA</p></div>'
, 0, 'DD', SYSDATE, 0);


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALIDACION, TFI_ERROR_VALIDACION,TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_ValidarAnuncioSubasta'), 1, 'date', 'fechaAnuncio', 'Fecha anuncio subasta', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valores[''P11_AnuncioSubasta_new2''][''fechaAnuncio'']', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALIDACION, TFI_ERROR_VALIDACION,TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_ValidarAnuncioSubasta'), 2, 'date', 'fechaSubasta', 'Fecha celebración subasta', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valores[''P11_AnuncioSubasta_new2''][''fechaSubasta'']', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALIDACION, TFI_ERROR_VALIDACION,TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_ValidarAnuncioSubasta'), 3, 'currency', 'costasLetrado', 'Costas letrado', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '' ? true : false', 'valores[''P11_AnuncioSubasta_new2''][''costasLetrado'']', 0, 'DD',SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALIDACION, TFI_ERROR_VALIDACION,TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_ValidarAnuncioSubasta'), 4,  'currency', 'costasProcurador', 'Costas procurador', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '' ? true : false', 'valores[''P11_AnuncioSubasta_new2''][''costasProcurador'']', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALIDACION, TFI_ERROR_VALIDACION,TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_ValidarAnuncioSubasta'), 5, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_ValidarAnuncioSubasta'), 6, 'date', 'fechaValidacion', 'Fecha validación anuncio subasta', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_ValidarAnuncioSubasta'), 7, 'combo', 'comboValidacion', 'Solicitud aceptada', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '' ? true : false', 'DDSiNo', 0, 'DD', SYSDATE, 0);



-- REGISTRAR FICHA DE SUBASTA
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P11'), 'P11_registrarFichaSubasta', 1, 'Registrar ficha de subasta', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');


Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarFichaSubasta'),'damePlazo(valores[''P11_AnuncioSubasta_new2''][''fechaSubasta'']) - 12*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

insert into UN001.DD_TFA_FICHERO_ADJUNTO
   (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (7, 'FS', 'FICHA DE SUBASTA', 'FICHA DE SUBASTA', 0, 'DD', SYSDATE, 0);
insert into UN001.DD_TFA_FICHERO_ADJUNTO
   (DD_TFA_ID, DD_TFA_CODIGO, DD_TFA_DESCRIPCION, DD_TFA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (8, 'SC', 'FICHA DE SITUACION CONTABLE', 'FICHA DE SITUACION CONTABLE', 0, 'DD', SYSDATE, 0);   

   

update TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = '(isAdjuntoFichaSubasta()?(isAdjuntoFichaSituacionContable() ? ''null'':''tareaExterna.error.faltaFichaSituacionContable''):''tareaExterna.error.faltaFichaSubasta'')'
where tap_codigo = 'P11_registrarFichaSubasta';

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_registrarFichaSubasta'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">REGISTRAR FICHA SUBASTA</p></div>'
, 0, 'DD', SYSDATE, 0);




