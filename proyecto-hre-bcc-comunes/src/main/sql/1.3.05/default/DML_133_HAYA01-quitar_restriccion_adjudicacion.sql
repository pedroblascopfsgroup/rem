--HR-460 - Se reabre esta incidencia para corregir una equivocación: El documento no es obligatorio.
update tap_tarea_procedimiento set tap_script_validacion = null where tap_codigo = 'H008_PropuestaCancelacionCargas';

commit;

