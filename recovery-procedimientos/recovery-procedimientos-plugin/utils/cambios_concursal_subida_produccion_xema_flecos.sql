delete from tfi_tareas_form_items where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P62_registrarOposicion') and tfi_nombre = 'restultadoResolucionConcursal';

commit;

--PROCEDIMIENTO HIPOTECARIO

UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS
SET DD_PTP_PLAZO_SCRIPT = '7*24*60*60*1000L'
WHERE TAP_ID =  (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P01_DemandaCertificacionCargas');

UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS
SET DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P01_DemandaCertificacionCargas''][''fechaSolicitud'']) + 60*24*60*60*1000L'
WHERE TAP_ID =  (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P01_AutoDespachandoEjecucion');


UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS
SET DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P01_AutoDespachandoEjecucion''][''fecha'']) + 60*24*60*60*1000L'
WHERE TAP_ID =  (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P01_ConfirmarNotificacionReqPago');

COMMIT;