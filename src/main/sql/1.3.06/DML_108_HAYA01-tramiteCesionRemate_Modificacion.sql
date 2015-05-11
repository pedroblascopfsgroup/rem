--HR-503 
-- Falla la derivacion a Cesion Remate cuando antes no se ha hecho el t. subasta sareb. El plazo de la 1a tarea de Cesion Remate (H006_AperturaPlazo) es FechaSeñalamiento(Subasta sareb) + 5 dias
-- Para solucionar el problema se acuerda dar un plazo fijo alternativo cuando no hay f. señalamiento.

update dd_ptp_plazos_tareas_plazas 
set dd_ptp_plazo_script = 'valoresBPMPadre[''H002_SenyalamientoSubasta''] == null ? 5*24*60*60*1000L : damePlazo(valoresBPMPadre[''H002_SenyalamientoSubasta''][''fechaSenyalamiento''])+5*24*60*60*1000L'
where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H006_AperturaPlazo');

commit;