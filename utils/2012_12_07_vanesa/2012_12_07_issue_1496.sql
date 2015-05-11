-- Script que finaliza las tareas 'Toma decisión después de cesión de remate' que se habían quedado pendientes tras tomar una decisión y que no se habían borrado por un error a la hora de solicitar una paralización 
update tar_tareas_notificaciones set tar_tarea_finalizada=1 where tar_id in (
select distinct (tar2.tar_id) from tar_tareas_notificaciones tar1
 left join tar_tareas_notificaciones tar2
 on tar1.prc_id = tar2.prc_id and tar2.dd_sta_id=39 and tar2.tar_tarea_finalizada is null and tar2.tar_tarea like '%Toma decisi%'
where tar1.dd_sta_id=46 and tar1.tar_tarea_finalizada =1
);