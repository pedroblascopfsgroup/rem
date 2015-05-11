-- *************************************************************************** --
-- **                   BPM Tramite averiguacion por demandado              ** --
-- *************************************************************************** --
/*
delete from tar_tareas_notificaciones where tar_id IN  (select tar_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P73')));
delete from tev_tarea_externa_valor where tex_id IN (select tex_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P73')));
delete from ter_tarea_externa_recuperacion where tex_id IN (select tex_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P73')));
delete from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P73'));
delete from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P73'));
delete from TFI_TAREAS_FORM_ITEMS where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P73'));
delete from DD_PTP_PLAZOS_TAREAS_PLAZAS where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P73'));
delete from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P73');
delete from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P73';
**/


Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P73' ,'Trámite averiguación por demandado', 'Trámite de averiguación por demandado', '', 'tramiteAveriguacionPorDemandado', 0, 'DD', SYSDATE, 0,(select dd_tac_id from dd_tac_tipo_actuacion where dd_tac_codigo='LIN'));

--Pantalla 1
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_STA_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P73'), 'P73_ConfirmarSolicitudInvestigacionJudicial', 0, 'Confirmar solicitud de investigación judicial',
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento', 39);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_ConfirmarSolicitudInvestigacionJudicial'), '30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_ConfirmarSolicitudInvestigacionJudicial'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Confirmar solicitud de investigacion.</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_ConfirmarSolicitudInvestigacionJudicial'), 1, 'date'
, 'fecha', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
 
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_ConfirmarSolicitudInvestigacionJudicial'), 2, 'textarea'
, 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

--Pantalla 2
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_STA_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P73'), 'P73_RegistrarResultadoInvestigacion', 0, 'Registrar resultado de investigación judicial',
'''Marcado''',
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento', 39);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_RegistrarResultadoInvestigacion'), '10*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_RegistrarResultadoInvestigacion'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Registrar resultado de la investigacion.</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_RegistrarResultadoInvestigacion'), 1, 'date'
, 'fechaInforme', 'Fecha informe resultado', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
 
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_RegistrarResultadoInvestigacion'), 2, 'combo'
, 'comboResultado', 'Resultado', 'DDPositivoNegativo', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_RegistrarResultadoInvestigacion'), 3, 'text'
, 'agencia', 'Agencia Tributaria', 0, 'DD', SYSDATE, 0);


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_RegistrarResultadoInvestigacion'), 4, 'text'
, 'seguridadSocial', 'Seguridad Social', 0, 'DD', SYSDATE, 0);


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_RegistrarResultadoInvestigacion'), 5, 'text'
, 'catastro', 'Catastro', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_RegistrarResultadoInvestigacion'), 6, 'text'
, 'ayuntamiento', 'Ayuntamiento', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_RegistrarResultadoInvestigacion'), 7, 'text'
, 'otros', 'Otros', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_RegistrarResultadoInvestigacion'), 8, 'currency'
, 'solvencia', 'Solvencia encontrada', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_RegistrarResultadoInvestigacion'), 9, 'currency'
, 'ingresos', 'Ingresos encontrados', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_RegistrarResultadoInvestigacion'), 10, 'textarea'
, 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

--Pantalla 3
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_STA_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P73'), 'P73_MarcadoBienes', 0, 'Marcado de bienes',
'valores[''P73_MarcadoBienes''][''bienesEmbargar'']==DDSiNo.SI?''Embargo'':(valores[''P73_MarcadoBienes''][''repetir'']==DDSiNo.SI?''Esperar'':''Fin'')',
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento', 39);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_MarcadoBienes'), '10*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_MarcadoBienes'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Marcado de bienes.</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_MarcadoBienes'), 1, 'combo', 'repetir'
, 'Activar alerta periódica', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_MarcadoBienes'), 2, 'combo', 'bienesEmbargar'
, 'Existen bienes a embargar', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_MarcadoBienes'), 3, 'date'
, 'fecha', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
 
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_MarcadoBienes'), 4, 'textarea'
, 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

--Pantalla ESPECIAL INVOCAR A TRAMITE DE EMBARGO POR BIEN
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, DD_STA_ID)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P73'), 'P73_JBPMTramiteEmbargoPorBien', (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P75')
, 0, 'Ejecución de trámite de embargo por bien', 0, 'DD', SYSDATE, 0,'EXTTareaProcedimiento', 39);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_JBPMTramiteEmbargoPorBien'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P73_JBPMTramiteEmbargoPorBien'), 0, 'label', 'titulo', 'Trámite de embargo por bien', 0, 'DD', SYSDATE, 0);
