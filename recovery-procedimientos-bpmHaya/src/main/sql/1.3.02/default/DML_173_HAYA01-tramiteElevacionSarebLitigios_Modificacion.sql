
--HR-393: Incidencia - T. Elevación Sareb Litigios - Nombres Tareas
------------------------------------------------------------------------------------------------
--Los nombres de las tareas deben coincidir con los que están puestos en las instrucciones
--Tarea 1 - Trámite de Elevación Propuesta Sareb de Litigios
--Tarea 2 - Registrar Propuesta Sareb
------------------------------------------------------------------------------------------------
update tap_tarea_procedimiento set tap_descripcion = 'Trámite de Elevación Propuesta Sareb de Litigios' where tap_codigo = 'H012_InformarSarebAlegaciones';
update tap_tarea_procedimiento set tap_descripcion = 'Registrar Propuesta Sareb' where tap_codigo = 'H012_RespuestaSareb';



--HR-394: Incidencia - T. Elevación Sareb Litigios - Nombre campos
------------------------------------------------------------------------------------------------
--El nombre de los campos deben coincidir con el de las instrucciones;
--Tarea 2 - Registrar Propuesta Sareb:
--1)Fecha respuesta
--2)Num.propuesta (preinformada)
--2)Resultado de la resolución: aceptada/denegada/aceptada con cambios
--4)Observaciones
------------------------------------------------------------------------------------------------
update tfi_tareas_form_items set tfi_label = 'Fecha respuesta' where tfi_nombre = 'fecha' and tap_id in (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H012_RespuestaSareb');
update tfi_tareas_form_items set tfi_label = 'Num. propuesta' where tfi_nombre = 'numprop' and tap_id in (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H012_RespuestaSareb');
update tfi_tareas_form_items set tfi_label = 'Resultado de la resolución' where tfi_nombre = 'comboResultado' and tap_id in (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H012_RespuestaSareb');


commit;