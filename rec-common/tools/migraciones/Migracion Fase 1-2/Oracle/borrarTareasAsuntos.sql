col junk new_value v_date
select to_char(sysdate,'YYYY-MM-DD') junk
from dual;

col junk new_value v_time
select to_char(sysdate,'HH24MISS') junk
from dual;

col junk new_value v_entorno
select global_name junk from global_name ;

spool borrarTareasAsuntos&v_entorno&v_date&v_time..log
--spool borrarTareasAsuntos.log;
--05 Borrado lógico de las tareas de asuntos existentes
update tar_tareas_notificaciones tar2 set tar2.borrado = 1,usuarioborrar='MIGFASE1-2',fechaborrar=sysdate where tar2.tar_id in 
(select tar.tar_id
from pfs01.tar_tareas_notificaciones tar, pfsmaster.dd_sta_subtipo_tarea_base sta, 
     pfs01.asu_asuntos asu 
where sta.dd_sta_id = tar.dd_sta_id and
      tar.dd_ein_id = 3 and
      tar.ASU_ID = asu.ASU_ID);
commit;      
spool off;            
