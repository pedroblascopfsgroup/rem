-- *************************************************************************** --
-- **                  INSERTS EN DD_TPO_TIPO_PROCEDIMIENTO	                ** --
-- *************************************************************************** --

-- Procedimiento abreviado
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P32', 'P. abreviado', 'P. abreviado', '', 'procedimientoAbreviado', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='PE'), 0, 'DD', SYSDATE, 0);

-- T. de recurso de reforma o apelación 
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P33', 'T. de recurso de reforma o apelación', 'T. de recurso de reforma o apelación', '', 'tramiteArchivo', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='PE'), 0, 'DD', SYSDATE, 0);

-- actualización nueva versión de penales

update DD_TPO_TIPO_PROCEDIMIENTO set DD_TPO_DESCRIPCION = 'T. de recurso de reforma o apelación' where DD_TPO_CODIGO = 'P33';
update DD_TPO_TIPO_PROCEDIMIENTO set DD_TAC_ID = (SELECT DD_TAC_ID FROM DD_TAC_TIPO_ACTUACION WHERE DD_TAC_DESCRIPCION = 'Otros trámites') where DD_TPO_CODIGO = 'P33';

delete from tfi_tareas_form_items 
where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO WHERE dd_tpo_id = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P32'));
delete from DD_PTP_PLAZOS_TAREAS_PLAZAS 
where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO WHERE dd_tpo_id = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P32'));
delete from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P32');

delete from tfi_tareas_form_items 
where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO WHERE dd_tpo_id = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P33'));
delete from DD_PTP_PLAZOS_TAREAS_PLAZAS 
where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO WHERE dd_tpo_id = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P33'));
delete from TAP_TAREA_PROCEDIMIENTO where dd_tpo_id = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P33');

