-- *************************************************************************** --
-- **    Actualizar las vistas de los procedimientos según especificaciones ** --
-- **	para los plugins	                								** --
-- *************************************************************************** --

UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = REPLACE(TFI_LABEL, 'Ejecución del ', 'Se inicia ') WHERE TFI_LABEL LIKE 'Ejecución del %';

UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_DESCRIPCION = REPLACE(TAP_DESCRIPCION, 'Ejecución del ', 'Se inicia ') WHERE TAP_DESCRIPCION LIKE 'Ejecución del %';

UPDATE TAR_TAREAS_NOTIFICACIONES SET TAR_TAREA = REPLACE(TAR_TAREA, 'Ejecución del ', 'Se inicia ') WHERE TAR_TAREA LIKE 'Ejecución del %';

SELECT * FROM TFI_TAREAS_FORM_ITEMS WHERE TFI_LABEL LIKE 'Ejecución del %';
SELECT TAP_DESCRIPCION FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_DESCRIPCION LIKE 'Ejecución del %';
SELECT TAR_TAREA FROM TAR_TAREAS_NOTIFICACIONES WHERE TAR_TAREA LIKE 'Ejecución del %';