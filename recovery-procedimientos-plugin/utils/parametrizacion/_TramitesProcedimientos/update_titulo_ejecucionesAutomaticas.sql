-- *************************************************************************** --
-- **    Actualizar las vistas de los procedimientos seg�n especificaciones ** --
-- **	para los plugins	                								** --
-- *************************************************************************** --

UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = REPLACE(TFI_LABEL, 'Ejecuci�n del ', 'Se inicia ') WHERE TFI_LABEL LIKE 'Ejecuci�n del %';

UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_DESCRIPCION = REPLACE(TAP_DESCRIPCION, 'Ejecuci�n del ', 'Se inicia ') WHERE TAP_DESCRIPCION LIKE 'Ejecuci�n del %';

UPDATE TAR_TAREAS_NOTIFICACIONES SET TAR_TAREA = REPLACE(TAR_TAREA, 'Ejecuci�n del ', 'Se inicia ') WHERE TAR_TAREA LIKE 'Ejecuci�n del %';

SELECT * FROM TFI_TAREAS_FORM_ITEMS WHERE TFI_LABEL LIKE 'Ejecuci�n del %';
SELECT TAP_DESCRIPCION FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_DESCRIPCION LIKE 'Ejecuci�n del %';
SELECT TAR_TAREA FROM TAR_TAREAS_NOTIFICACIONES WHERE TAR_TAREA LIKE 'Ejecuci�n del %';