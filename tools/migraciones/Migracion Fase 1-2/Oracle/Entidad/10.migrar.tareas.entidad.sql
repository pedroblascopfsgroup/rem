-- Setear Fecha de vencimiento a la tareas y ajustar la fecha fin
UPDATE tar_tareas_notificaciones
   SET tar_fecha_venc = tar_fecha_fin;

UPDATE tar_tareas_notificaciones
   SET tar_fecha_fin = NULL
 WHERE borrado = 0;
