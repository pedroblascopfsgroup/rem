col junk new_value v_date
select to_char(sysdate,'YYYY-MM-DD') junk
from dual;

col junk new_value v_time
select to_char(sysdate,'HH24MISS') junk
from dual;

col junk new_value v_entorno
select global_name junk from global_name ;

spool selectTareasExpCanceladoInc126&v_entorno&v_date&v_time..log
select tar_id, dd_ein_id, exp_id, dd_sta_id 
from pfs01.tar_tareas_notificaciones tar2   where tar2.tar_id in 
(select  tar.TAR_ID
from pfs01.tar_tareas_notificaciones tar, pfsmaster.dd_sta_subtipo_tarea_base sta, 
     pfs01.exp_expedientes ex , pfsmaster.DD_EEX_ESTADO_EXPEDIENTE eex
where sta.dd_sta_id = tar.dd_sta_id and
      tar.dd_ein_id = 2 and
      tar.EXP_ID = ex.EXP_ID and
      ex.DD_EEX_ID = eex.DD_EEX_ID and
      eex.dd_eex_codigo = 5 and tar.borrado= 0 and sta.dd_sta_id <> 10);
spool off;      