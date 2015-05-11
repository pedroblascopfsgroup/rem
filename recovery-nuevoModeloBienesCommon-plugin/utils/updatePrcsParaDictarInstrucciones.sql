
update tfi_tareas_form_items
set 
where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P11_DictarInstrucciones')
	and tfi_nombre = 'principal';
	