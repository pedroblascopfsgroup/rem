-- *************************************************************************** --
-- **                   BPM Procedimiento Monitorio para Lindorff                ** --
-- *************************************************************************** --
/*
delete from tar_tareas_notificaciones where tar_id IN  (select tar_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P71')));
delete from tev_tarea_externa_valor where tex_id IN (select tex_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P71')));
delete from ter_tarea_externa_recuperacion where tex_id IN (select tex_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P71')));
delete from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P71'));
delete from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P71'));
delete from TFI_TAREAS_FORM_ITEMS where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P71'));
delete from DD_PTP_PLAZOS_TAREAS_PLAZAS where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P71'));
delete from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P71');
delete from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P71';
UPDATE DD_TPO_TIPO_PROCEDIMIENTO SET DD_TPO_DESCRIPCION='Preparacion y Envio demanda Monitorio', DD_TPO_DESCRIPCION_LARGA='Preparacion y Envio demanda Monitorio' WHERE DD_TPO_CODIGO='P71';
***/

Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P71' ,'Preparacion y Envio demanda Monitorio', 'Preparacion y Envio demanda Monitorio', '', 'preparacionEnvioDemandaMonitorioMasivo', 0, 'DD', SYSDATE, 0, (select dd_tac_id from dd_tac_tipo_actuacion where dd_tac_codigo='LIN') );

-- Pantalla 1
/*
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P71'), 'P71_Inicio', 0, 'Inicio',
'ConContrato',
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento');


Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_Inicio'), '1*24*60*60*1000L', 0, 'DD', SYSDATE, 0);
*/
-- Pantalla 2
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P71'), 'P71_ConfirmarRecepcionContrato', 0, 'Confirmar recepción del contrato',
'valores[''P71_ConfirmarRecepcionContrato''][''contratoDisponibleSiNo'']==DDSiNo.NO?''SinContrato'':''ConContrato''',
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ConfirmarRecepcionContrato'), '30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ConfirmarRecepcionContrato'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Confirmar recepcion del contrato.</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ConfirmarRecepcionContrato'), 1, 'number'
, 'numeroCaso', 'Número caso NOVA','valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ConfirmarRecepcionContrato'), 2, 'date'
, 'fecha', 'Fecha de recepcion', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
 
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ConfirmarRecepcionContrato'), 3, 'combo'
, 'contratoDisponibleSiNo', 'Contrato disponible', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ConfirmarRecepcionContrato'), 4, 'textarea'
, 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 3
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P71'), 'P71_SolicitarTestimonio', 0, 'Solitar testimonio',
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento');


Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_SolicitarTestimonio'), '3*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_SolicitarTestimonio'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Solicitar testimonio.</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALOR_INICIAL)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_SolicitarTestimonio'), 1, 'number'
, 'numeroCaso', 'Número caso NOVA','valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'
, 0, 'DD', SYSDATE, 0,'valores[''P71_ConfirmarRecepcionContrato''] == null ? '''' : (valores[''P71_ConfirmarRecepcionContrato''][''numeroCaso''])');


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_SolicitarTestimonio'), 2, 'date'
, 'fecha', 'Fecha de solicitud', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
 
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_SolicitarTestimonio'), 3, 'textarea'
, 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);


-- Pantalla 4
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P71'), 'P71_ConfirmarRecepcionTestimonio', 0, 'Confirmar recepción testimonio',
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ConfirmarRecepcionTestimonio'), '2*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ConfirmarRecepcionTestimonio'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Confirmar recepcion del testimonio.</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALOR_INICIAL)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ConfirmarRecepcionTestimonio'), 1, 'number'
, 'numeroCaso', 'Número caso NOVA','valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'
, 0, 'DD', SYSDATE, 0,'valores[''P71_SolicitarTestimonio''] == null ? '''' : (valores[''P71_SolicitarTestimonio''][''numeroCaso''])');


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ConfirmarRecepcionTestimonio'), 2, 'date'
, 'fecha', 'Fecha de recepción', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
 
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ConfirmarRecepcionTestimonio'), 3, 'textarea'
, 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 5
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P71'), 'P71_AutoGeneracionDemanda', 0, 'Autogeneración de documentación (demanda, certificado deuda, carta hello)',
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_AutoGeneracionDemanda'), '1*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_AutoGeneracionDemanda'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Autogeneracion de la demanda.</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO,TFI_VALOR_INICIAL)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_AutoGeneracionDemanda'), 1, 'number'
, 'numeroCaso', 'Número caso NOVA','valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'
, 0, 'DD', SYSDATE, 0,'valores[''P71_ConfirmarRecepcionTestimonio''] == null ? '''' : (valores[''P71_ConfirmarRecepcionTestimonio''][''numeroCaso''])');



-- Pantalla 6
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P71'), 'P71_GenerarFicheroTasas', 0, 'Generar el fichero de tasas',
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_GenerarFicheroTasas'), '3*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_GenerarFicheroTasas'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Generar fichero de tasas.</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO,TFI_VALOR_INICIAL)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_GenerarFicheroTasas'), 1, 'number'
, 'numeroCaso', 'Número caso NOVA','valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
0, 'DD', SYSDATE, 0,'valores[''P71_ConfirmarRecepcionTestimonio''] == null ? '''' : (valores[''P71_ConfirmarRecepcionTestimonio''][''numeroCaso''])');


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_GenerarFicheroTasas'), 2, 'date'
, 'fecha', 'Fecha de solicitud', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
 
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_GenerarFicheroTasas'), 3, 'textarea'
, 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);


-- Pantalla 7
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,TAP_SCRIPT_DECISION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P71'), 'P71_ValidarFicheroTasas', 0, 'Validar el fichero de tasas',
'valores[''P71_ValidarFicheroTasas''][''presentacionManual'']==DDSiNo.SI?''presentacionManual'':(valores[''P71_ValidarFicheroTasas''][''validadoSiNo'']==DDSiNo.SI?''Valido'':''NoValido'')',
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ValidarFicheroTasas'), '3*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ValidarFicheroTasas'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Validar fichero de tasas.</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALOR_INICIAL)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ValidarFicheroTasas'), 1, 'number'
, 'numeroCaso', 'Número caso NOVA','valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
0, 'DD', SYSDATE, 0,'valores[''P71_GenerarFicheroTasas''] == null ? '''' : (valores[''P71_GenerarFicheroTasas''][''numeroCaso''])');


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ValidarFicheroTasas'), 2, 'date'
, 'fecha', 'Fecha de validación', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
 
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ValidarFicheroTasas'), 3, 'combo'
, 'validadoSiNo', 'Fichero válido', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ValidarFicheroTasas'), 4, 'combo'
, 'presentacionManual', 'PresentacionManual', 'DDSiNo', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ValidarFicheroTasas'), 5, 'textarea'
, 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- pantalla 7,5

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P71'), 'P71_AutoGeneracionDocumentacion', 0, 'Autogeneracion documentacion de tasas',
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_AutoGeneracionDocumentacion'), '1*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_AutoGeneracionDocumentacion'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Auto generacion documentacion de tasas.</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALOR_INICIAL)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_AutoGeneracionDocumentacion'), 1, 'number'
, 'numeroCaso', 'Número caso NOVA','valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'
, 0, 'DD', SYSDATE, 0,'valores[''P71_ValidarFicheroTasas''] == null ? '''' : (valores[''P71_ValidarFicheroTasas''][''numeroCaso''])');

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_AutoGeneracionDocumentacion'), 2, 'textarea'
, 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);


-- Pantalla 8
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P71'), 'P71_SolicitarPagoTasas', 0, 'Solicitar pago tasas',
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_SolicitarPagoTasas'), '3*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_SolicitarPagoTasas'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Solicitar pago de tasas.</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALOR_INICIAL)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_SolicitarPagoTasas'), 1, 'number'
, 'numeroCaso', 'Número caso NOVA','valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
0, 'DD', SYSDATE, 0,'valores[''P71_AutoGeneracionDocumentacion''] == null ? '''' : (valores[''P71_AutoGeneracionDocumentacion''][''numeroCaso''])');


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_SolicitarPagoTasas'), 2, 'date'
, 'fecha', 'Fecha de solicitud', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
 
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_SolicitarPagoTasas'), 3, 'textarea'
, 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);


-- Pantalla 9
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P71'), 'P71_ConfirmarRecepcionDocumentacion', 0, 'Confirmar recepción documentación tasas',
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ConfirmarRecepcionDocumentacion'), '7*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ConfirmarRecepcionDocumentacion'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Confirmar recepcion de la documentacion de pago de tasas.</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALOR_INICIAL)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ConfirmarRecepcionDocumentacion'), 1, 'number'
, 'numeroCaso', 'Número caso NOVA','valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 
0, 'DD', SYSDATE, 0, 'valores[''P71_SolicitarPagoTasas''] == null ? '''' : (valores[''P71_SolicitarPagoTasas''][''numeroCaso''])');


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ConfirmarRecepcionDocumentacion'), 2, 'date'
, 'fecha', 'Fecha de recepcion', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
 
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ConfirmarRecepcionDocumentacion'), 3, 'textarea'
, 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);


-- Pantalla 10
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P71'), 'P71_EnviarImprimir', 0, 'Enviar a imprimir',
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_EnviarImprimir'), '3*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_EnviarImprimir'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Enviar a imprimir la documentacion.</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALOR_INICIAL)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_EnviarImprimir'), 1, 'number'
, 'numeroCaso', 'Número caso NOVA','valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
0, 'DD', SYSDATE, 0,'valores[''P71_ConfirmarRecepcionDocumentacion''] == null ? '''' : (valores[''P71_ConfirmarRecepcionDocumentacion''][''numeroCaso''])');


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_EnviarImprimir'), 2, 'date'
, 'fecha', 'Fecha de solicitud', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
 
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_EnviarImprimir'), 3, 'textarea'
, 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);



-- Pantalla 11
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P71'), 'P71_ConfirmarRecepcionDocumentacionImpresa', 0, 'Confirmar recepción documentación impresa',
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ConfirmarRecepcionDocumentacionImpresa'), '3*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ConfirmarRecepcionDocumentacionImpresa'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Confirmar recepcion de la documentacion impresa.</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALOR_INICIAL)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ConfirmarRecepcionDocumentacionImpresa'), 1, 'number'
, 'numeroCaso', 'Número caso NOVA','valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'
, 0, 'DD', SYSDATE, 0,'valores[''P71_EnviarImprimir''] == null ? '''' : (valores[''P71_EnviarImprimir''][''numeroCaso''])');


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ConfirmarRecepcionDocumentacionImpresa'), 2, 'date'
, 'fecha', 'Fecha de recepción', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
 
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_ConfirmarRecepcionDocumentacionImpresa'), 3, 'textarea'
, 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);


-- Pantalla 12
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P71'), 'P71_EnviarJuzgado', 0, 'Enviar al juzgado',
0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_EnviarJuzgado'), '3*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_EnviarJuzgado'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Enviar documentacion al juzgado.</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALOR_INICIAL)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_EnviarJuzgado'), 1, 'number'
, 'numeroCaso', 'Número caso NOVA','valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 
0, 'DD', SYSDATE, 0,'valores[''P71_ConfirmarRecepcionDocumentacionImpresa''] == null ? '''' : (valores[''P71_ConfirmarRecepcionDocumentacionImpresa''][''numeroCaso''])');


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_EnviarJuzgado'), 2, 'date'
, 'fecha', 'Fecha de envío', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
 
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_EnviarJuzgado'), 3, 'textarea'
, 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);


--Pantalla ESPECIAL INVOCAR A PROCEDIMIENTO MONITORIO MASIVO
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P71'), 'P71_JBPMProcedimientoMonitorioMasivo', (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P70')
, 0, 'Ejecución del Procedimiento monitorio masivo desde preparacion de la demanda', 0, 'DD', SYSDATE, 0,'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_JBPMProcedimientoMonitorioMasivo'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P71_JBPMProcedimientoMonitorioMasivo'), 0, 'label', 'titulo', 'Ejecución del Procedimiento Monitorio masivo', 0, 'DD', SYSDATE, 0);

