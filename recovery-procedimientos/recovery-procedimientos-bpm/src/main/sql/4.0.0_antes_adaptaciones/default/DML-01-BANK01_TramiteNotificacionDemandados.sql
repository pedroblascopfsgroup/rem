--TIPO PROCEDIMIENTO
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID,DTYPE) Values(S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, 'P400', 'Trámite notificación demandados', 'Trámite notificación demandados','tramiteNotificacionV4', 0, 'DD', sysdate, 0, (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AP'),'MEJTipoProcedimiento');
 
 
--TAREAS_PROCEDIMIENTO
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,TAP_SUPERVISOR,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,TAP_AUTOPRORROGA,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P400'), 'P400_GestionarNotificaciones','Notificar demandados',null, 0, 'dd', sysdate, 0,'EXTTareaProcedimiento','','!todosNotificados() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>!Atención! Para dar por terminada esta tarea debe notificar todos los demandados o excluirlos.</p></div>'' : null','','',0,'tareaExterna.cancelarTarea',(select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='01'),1,3,(select DD_TGE_ID from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='GEXT'),(select DD_STA_ID from BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE where DD_STA_CODIGO='39'));
 
 
--PLAZOS
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P400_GestionarNotificaciones'), '80*24*60*60*1000L', 0, 'DD', SYSDATE, 0);
 
 
--TFI
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P400_GestionarNotificaciones'), 0, 'label', 'titulo',  '<p>Dado que se ha iniciado un trámite de notificación con el objeto de notificar a todos los demandados en el procedimiento, esta tarea seguirá pendiente mientras no se haya conseguido notificar a todos los demandados o en su caso, haber marcado la casilla Descartado en aquellos demandados que no se pudiera o considere su notificación.</p>
<p>
Para gestionar las notificaciones de los demandados en el procedimiento, deberá abrir la ficha de procedimiento correspondiente y registrar las gestiones realizadas en la pestaña Notificación demandados.</p>
 
<p>En el momento que queden todos los demandados notificados o en su caso descartados, el sistema completará esta tarea de forma automática dando así por finalizada esta actuación.</p>' , 0, 'DD', SYSDATE, 0);
 
 
INSERT INTO "BANK01"."TFI_TAREAS_FORM_ITEMS" (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES (
S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P400_GestionarNotificaciones'), '3', 'textarea', 'observaciones', 'Observaciones', '0', 'DD', sysdate, '0');
 
 
 
COMMIT;