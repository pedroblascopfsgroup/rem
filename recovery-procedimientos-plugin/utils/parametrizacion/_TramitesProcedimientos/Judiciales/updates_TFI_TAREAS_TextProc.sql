-- ********************************************************************************** --
-- **                   UPDATE CAMPO TFI_TIPO a los campos NUMERO DE PROCEDIMIENTO ** --
-- ********************************************************************************** --

UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_TIPO= 'textproc' WHERE TFI_NOMBRE = 'nProc' AND TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P16_AutoDespachando');
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_TIPO= 'textproc' WHERE TFI_NOMBRE = 'numProcedimiento' AND TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P21_RegistrarJuicioVerbal');
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_TIPO= 'textproc' WHERE TFI_NOMBRE = 'numProcedimiento' AND TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P04_ConfirmarAdmisionDemanda' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P04'));
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_TIPO= 'textproc' WHERE TFI_NOMBRE = 'numProcedimiento' AND TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_AutoDespaEjecMasDecretoEmbargo');
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_TIPO= 'textproc' WHERE TFI_NOMBRE = 'numProcedimiento' AND TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P17_CnfAdmiDemaDecretoEmbargo');
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_TIPO= 'textproc' WHERE TFI_NOMBRE = 'numProcedimiento' AND TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P03_ConfirmarAdmision');
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_TIPO= 'textproc' WHERE TFI_NOMBRE = 'numProcedimiento' AND TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P02_ConfirmarAdmisionDemanda');
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_TIPO= 'textproc' WHERE TFI_NOMBRE = 'numProcedimiento' AND TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P21_RegistrarJuicioVerbal');




















