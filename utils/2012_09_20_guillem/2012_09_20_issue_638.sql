-- VISUALIZAMOS LAS NOTIFICACIONES PARA LOS SUPERVISORES QUE SE HAN CREADO DEBIDO A LA LA FINALIZACI�N DE ASUNTOS POR DECISI�N
--select * from tar_tareas_notificaciones  where tar_tarea = 'Aceptacion/Rechazo Decision Procedimiento' and tar_tarea_finalizada is null;
-- BORRADO DE LAS NOTIFICACIONES A LOS SUPERVISORES POR LA FINALIZACI�N DE ASUNTOS POR DECISI�N
delete from tar_tareas_notificaciones  where tar_tarea = 'Aceptacion/Rechazo Decision Procedimiento' and tar_tarea_finalizada is null;