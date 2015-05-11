-- tipo de actuación para lindorff

Insert into DD_TAC_TIPO_ACTUACION
   (DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values
   (S_DD_TAC_TIPO_ACTUACION.nextVal, 'LIN', 'Lindorff', 'Tipo de Actuación Lindorff', 0, 'DD', sysdate, 0);
   

-- *************************************************************************** --
-- **                   BPM Procedimiento Monitorio para Lindorff                ** --
-- *************************************************************************** --
/*
delete from tar_tareas_notificaciones where tar_id IN  (select tar_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P70')));
delete from tev_tarea_externa_valor where tex_id IN (select tex_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P70')));
delete from ter_tarea_externa_recuperacion where tex_id IN (select tex_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P70')));
delete from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P70'));
delete from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P70'));
delete from TFI_TAREAS_FORM_ITEMS where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P70'));
delete from DD_PTP_PLAZOS_TAREAS_PLAZAS where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P70'));
delete from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P70');
delete from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P70';
**/

Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P70' ,'P. Monitorio Masivo', 'P. Monitorio Masivo', '', 'procedimientoMonitorioMasivo', 0, 'DD', SYSDATE, 0, (select dd_tac_id from dd_tac_tipo_actuacion where dd_tac_codigo='LIN') );

-- Pantalla 1
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P70'), 'P70_InterposicionDemanda', 0, 'Interposición de la demanda',
'valores[''P70_InterposicionDemanda''][''tipoReqPrevio'']!=null?''RequerimientoPrevio'':(valores[''P70_InterposicionDemanda''][''comboResultado'']==DDSiNo.SI?(procedimientoManager.getProcedimiento(idProcedimiento).getSaldoRecuperacion() > 6000 ? ''OposicionMayor'' : ''OposicionMenor''):(valores[''P70_InterposicionDemanda''][''fechaAutoFin'']!= null ?''Fin'':(valores[''P70_InterposicionDemanda''][''comboAdmision'']==DDSiNo.NO?''Inadmision'':(valores[''P70_InterposicionDemanda''][''comboAdmision'']==DDSiNo.SI?''AdmisionReqPagoNegativo'':''Interposicion''))))',
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento');

UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = '((valores[''P70_InterposicionDemanda''][''comboResultado''] == DDSiNo.SI) && (valores[''P70_InterposicionDemanda''][''fechaOposicion''] == null || valores[''P70_InterposicionDemanda''][''fechaOposicion''] == ''''))?''tareaExterna.error.P15_ConfirmarSiExisteOposicion.fechasOblgatorias'':((valores[''P70_InterposicionDemanda''][''tipoReqPrevio''] != null) && (valores[''P70_InterposicionDemanda''][''plazoReqPrevio''] == null || valores[''P70_InterposicionDemanda''][''plazoReqPrevio''] == ''''))?''tareaExterna.error.P70_InterposicionDemanda.plazoObligatorio'':null'
WHERE TAP_CODIGO = 'P70_InterposicionDemanda';

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_InterposicionDemanda'), '10*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_InterposicionDemanda'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha de presentaci&'||'oacute;n de la demanda. Ind&'||'iacute;quese la plaza del juzgado y procurador que representa a la entidad.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Confirmar admisi&'||'oacute;n de la demanda&'||'quot;.</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_InterposicionDemanda'), 1, 'date'
, 'fechaInterposicion', 'Fecha interposicion', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_InterposicionDemanda'), 2, 'combo'
, 'comboAdmision', 'Admisión', 'DDSiNo', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_InterposicionDemanda'), 3, 'date'
, 'fechaAdmision', 'Fecha admision', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_InterposicionDemanda'), 4, 'currency'
, 'importeAdmision', 'Importe admision (admis. Parcial)', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_InterposicionDemanda'), 5, 'date'
, 'fechaAutoFin', 'Fecha auto fin de monitorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_InterposicionDemanda'), 6, 'combo'
, 'comboResultado', 'Existe oposición', 'DDSiNo', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_InterposicionDemanda'), 7, 'date'
, 'fechaOposicion', 'Fecha oposicion', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_InterposicionDemanda'), 8, 'combo'
, 'tipoReqPrevio', 'Tipo Req. previo', 'MSVDDRequerimientoPrevio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_InterposicionDemanda'), 9, 'number'
, 'plazoReqPrevio', 'Plazo Req. previo', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_InterposicionDemanda'), 10, 'textarea'
, 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);


-- Pantalla 2
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P70'), 'P70_SolventarRequerimientoPrevio', 0, 'Solventar requerimiento previo',
 0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_SolventarRequerimientoPrevio'), '5*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_SolventarRequerimientoPrevio'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Solventar requerimiento previo</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_SolventarRequerimientoPrevio'), 1, 'date'
, 'fechaEnvioEscrito', 'Fecha envio escrito', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_SolventarRequerimientoPrevio'), 2, 'combo'
, 'comboResultado', 'Adjuntar escrito manual', 'DDSiNo', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_SolventarRequerimientoPrevio'), 3, 'textarea'
, 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

--Pantall 3
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P70'), 'P70_ConfirmarAdmisionDemanda', 0, 'Confirmar admisión de la demanda',
'valores[''P70_ConfirmarAdmisionDemanda''][''tipoReqPrevio'']!= null ?''RequerimientoPrevio'':(valores[''P70_ConfirmarAdmisionDemanda''][''comboResultado'']==DDSiNo.SI?(procedimientoManager.getProcedimiento(idProcedimiento).getSaldoRecuperacion() > 6000 ? ''OposicionMayor'' : ''OposicionMenor''):(valores[''P70_ConfirmarAdmisionDemanda''][''fechaAutoFin'']!= null?''Fin'':(valores[''P70_ConfirmarAdmisionDemanda''][''comboAdmision'']== DDSiNo.NO?''Inadmision'':''AdmisionReqPagoNegativo'')))',
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento');


Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarAdmisionDemanda'), '90*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarAdmisionDemanda'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Ind&'||'iacute;quese la fecha en la que se nos notifica la admisi&'||'oacute;n de la demanda, el juzgado en el que ha reca&'||'iacute;do y el n&'||'uacute;mero de procedimiento.</p><p style="margin-bottom: 10px">Se ha de indicar si la demanda interpuesta ha sido admitida o no, lo que supondr&'||'aacute;, seg&'||'uacute;n su contestaci&'||'oacute;n, que la tarea siguiente sea una u otra de las que se le indica con posterioridad.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute;, si ha sido admitida a tr&'||'aacute;mite la demanda &'||'quot;Confirmar notificaci&'||'oacute;n de la demanda&'||'quot;. Si no ha sido admitida la demanda se le abrir&'||'aacute; tarea en la que propondr&'||'aacute;, seg&'||'uacute;n su criterio, la siguiente actuaci&'||'oacute;n al responsable de la entidad.</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarAdmisionDemanda'), 1, 'combo'
, 'comboAdmision', 'Admisión', 'DDSiNo', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarAdmisionDemanda'), 2, 'date'
, 'fechaAdmision', 'Fecha admision', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarAdmisionDemanda'), 3, 'currency'
, 'importeAdmision', 'Importe admision (admis. Parcial)', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarAdmisionDemanda'), 4, 'date'
, 'fechaAutoFin', 'Fecha auto fin de monitorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarAdmisionDemanda'), 5, 'combo'
, 'comboResultado', 'Existe oposición', 'DDSiNo', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarAdmisionDemanda'), 6, 'date'
, 'fechaOposicion', 'Fecha oposicion', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarAdmisionDemanda'), 7, 'combo'
, 'tipoReqPrevio', 'Tipo Req. previo', 'MSVDDRequerimientoPrevio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarAdmisionDemanda'), 8, 'number'
, 'plazoReqPrevio', 'Plazo Req. previo', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarAdmisionDemanda'), 9, 'textarea'
, 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 4

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO,TAP_VIEW,TAP_SUPERVISOR, TAP_DESCRIPCION,TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P70'), 
'P70_ConfirmarReqPrevioTodosDemandados',
'plugin/masivo/procedimientoMonitorioMasivo/confirmarReqPrevioTodosDemandados',
0,'Confirmar requerimiento pago todos demandados',
'valores[''P70_ConfirmarReqPrevioTodosDemandados''][''oposicionSiNo'']==DDSiNo.SI?(procedimientoManager.getProcedimiento(idProcedimiento).getSaldoRecuperacion() > 6000 ? ''OposicionMayor'' : ''OposicionMenor''):''RequerimientoPagoTotal''',
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento');


Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarReqPrevioTodosDemandados'), '60*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarReqPrevioTodosDemandados'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Confirmar requerimiento de pago para todos los demandados.</p><p style="margin-bottom: 10px">El gestor debera insertar la fecha de requerimiento y la direccion para cada demandao.</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarReqPrevioTodosDemandados'), 2, 'combo'
, 'oposicionSiNo', 'Existe oposición', 'DDSiNo', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarReqPrevioTodosDemandados'), 3, 'date'
, 'fechaOposicion', 'Fecha oposición', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarReqPrevioTodosDemandados'), 4, 'textarea'
, 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 5

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P70'), 'P70_ConfirmarAutoFinMonitorio', 0, 'Confirmar auto fin de Monitorio',
'valores[''P70_ConfirmarAutoFinMonitorio''][''oposicionSiNo'']==DDSiNo.SI?(procedimientoManager.getProcedimiento(idProcedimiento).getSaldoRecuperacion() > 6000 ? ''OposicionMayor'' : ''OposicionMenor''):''Fin''', 
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento');
 
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarAutoFinMonitorio'), '20*24*60*60*1000L', 0, 'DD', SYSDATE, 0); 


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarAutoFinMonitorio'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Confirmar auto finalización de Procedimiento Monitorio.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute;, si ha sido admitida a tr&'||'aacute;mite la demanda &'||'quot;Confirmar notificaci&'||'oacute;n de la demanda&'||'quot;. Si no ha sido admitida la demanda se le abrir&'||'aacute; tarea en la que propondr&'||'aacute;, seg&'||'uacute;n su criterio, la siguiente actuaci&'||'oacute;n al responsable de la entidad.</p></div>'
, 0, 'DD', SYSDATE, 0);


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarAutoFinMonitorio'), 1, 'date'
, 'fechaAuto', 'Fecha auto', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
 
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarAutoFinMonitorio'), 2, 'combo'
, 'oposicionSiNo', 'Existe oposición', 'DDSiNo', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarAutoFinMonitorio'), 3, 'date'
, 'fechaOposicion', 'Fecha oposición', 0, 'DD', SYSDATE, 0);
 
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_ConfirmarAutoFinMonitorio'), 4, 'textarea'
, 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

--Pantalla 6
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P70'), 'P70_EsperarContinuarProcedimiento', 0, 'Esperar/Continuar procedimiento',
'valores[''P70_EsperarContinuarProcedimiento''][''esperarContinuar'']==''01'' ?''Esperar'':''Continuar''', 
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento');
 
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_EsperarContinuarProcedimiento'), '10*24*60*60*1000L', 0, 'DD', SYSDATE, 0); 


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_EsperarContinuarProcedimiento'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Esperar o continuar procedimiento.</p></div>'
, 0, 'DD', SYSDATE, 0);


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_EsperarContinuarProcedimiento'), 1, 'date'
, 'fecha', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
 
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALIDACION, TFI_ERROR_VALIDACION,  TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_EsperarContinuarProcedimiento'), 2, 'combo'
, 'esperarContinuar', 'Esperar/Continar',  'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','MSVDDEsperarContinuar', 0, 'DD', SYSDATE, 0);
 
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_EsperarContinuarProcedimiento'), 3, 'textarea'
, 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

--Pantalla ESPECIAL INVOCAR A PROCEDIMIENTO VERBAL DESDE MONITORIO
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P70'), 'P70_JBPMProcedimientoVerbalDesdeMonitorio', (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P21'), 0, 'Ejecución del Procedimiento verbal desde monitorio', 0, 'DD', SYSDATE, 0,'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_JBPMProcedimientoVerbalDesdeMonitorio'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_JBPMProcedimientoVerbalDesdeMonitorio'), 0, 'label', 'titulo', 'Ejecución del Procedimiento verbal desde monitorio', 0, 'DD', SYSDATE, 0);

--Pantalla ESPECIAL INVOCAR A PROCEDIMIENTO ORDINARIO DESDE MONITORIO
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P70'), 'P70_JBPMProcedimientoOrdinario', (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P03'), 0, 'Ejecución del Procedimiento ordinario desde monitorio', 0, 'DD', SYSDATE, 0,'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_JBPMProcedimientoOrdinario'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_JBPMProcedimientoOrdinario'), 0, 'label', 'titulo', 'Ejecución del Procedimiento Ordinario', 0, 'DD', SYSDATE, 0);

