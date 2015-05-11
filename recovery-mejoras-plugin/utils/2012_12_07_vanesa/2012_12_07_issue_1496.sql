-- Script que finaliza las tareas 'Toma decisi�n despu�s de cesi�n de remate' que se hab�an quedado pendientes tras tomar una decisi�n y que no se hab�an borrado por un error a la hora de solicitar una paralizaci�n 
update tar_tareas_notificaciones set tar_tarea_finalizada=1 where tar_id in (
select distinct (tar2.tar_id) from tar_tareas_notificaciones tar1
 left join tar_tareas_notificaciones tar2
 on tar1.prc_id = tar2.prc_id and tar2.dd_sta_id=39 and tar2.tar_tarea_finalizada is null and tar2.tar_tarea like '%Toma decisi%'
where tar1.dd_sta_id=46 and tar1.tar_tarea_finalizada =1
);