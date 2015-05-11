-- VISUALIZAMOS LAS NOTIFICACIONES PARA LOS SUPERVISORES QUE SE HAN CREADO DEBIDO A LA LA FINALIZACIÓN DE ASUNTOS POR DECISIÓN
--select * from tar_tareas_notificaciones  where tar_tarea = 'Aceptacion/Rechazo Decision Procedimiento' and tar_tarea_finalizada is null;
-- BORRADO DE LAS NOTIFICACIONES A LOS SUPERVISORES POR LA FINALIZACIÓN DE ASUNTOS POR DECISIÓN
delete from tar_tareas_notificaciones  where tar_tarea = 'Aceptacion/Rechazo Decision Procedimiento' and tar_tarea_finalizada is null;