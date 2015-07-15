
--HR-449
-- Falta asociar el DD_TPO_ID_BPM para que se lance el T. subasta sareb, desde hipotecario
update tap_tarea_procedimiento set dd_tpo_id_bpm = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'H002') 
where tap_codigo = 'H001_BPMTramiteSubasta';

--HR-450
-- Si NO existe oposición, tampoco requerir F. Comparecencia
update tfi_tareas_form_items set tfi_error_validacion = null, tfi_validacion = null where tfi_nombre ='fechaComparecencia' and tap_id in (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H001_ConfirmarSiExisteOposicion');


commit;