
-- Incidencia 5 - PLAZOS CONDICIONADOS
update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = 'damePlazo(valores[''H001_RegistrarComparecencia''][''fecha'']) + 15*24*60*60*1000L' where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H001_RegistrarResolucion');

update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = 'damePlazo(valores[''H001_RegistrarResolucion''][''fecha'']) + 20*24*60*60*1000L' where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H001_ResolucionFirme');

commit;
