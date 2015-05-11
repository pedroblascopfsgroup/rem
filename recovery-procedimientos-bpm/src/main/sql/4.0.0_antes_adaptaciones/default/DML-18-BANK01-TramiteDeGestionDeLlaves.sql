
/*
* SCRIPT PARA GENERACIÓN DE DATOS BPM: Trámite de gestion de llaves
* BPM: P417 tramiteDeGestionDeLlaves
* FECHA: 20141013
* PARTES: 2/2
*/

SET DEFINE OFF;

--P417_Decision1 - Nodo decisión del supervisor
--******************************** Tarea Decision1  ****************************
	Insert into BANK01.TAP_TAREA_PROCEDIMIENTO
(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, TAP_SCRIPT_VALIDACION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from BANK01.DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P417'), 'P417_Decision1', 1, 'Decision del supervisor',null, null,'0', 'DD', sysdate, 0, 'tareaExterna.cancelarTarea', '1', 'EXTTareaProcedimiento', '3', 102);

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS
(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_Decision1'), 0, 'label', 'titulo',  '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Debe acceder a la pestaña "Decisiones" para derivar en la actuaci'||chr(38)||'oacute;n que corresponda'||chr(38)||'quot;</p></div>', '0', 'DD', SYSDATE, 0);


