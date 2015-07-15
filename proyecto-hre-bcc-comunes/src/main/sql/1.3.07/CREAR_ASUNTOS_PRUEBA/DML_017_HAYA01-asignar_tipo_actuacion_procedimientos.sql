update TAR_TAREAS_NOTIFICACIONES set TAR_TAREA=TAR_DESCRIPCION;

commit;

--Asignar tipo de actuación a procedimientos
/*
merge into prc_procedimientos prc
using (
select prc.prc_id , tpo.dd_tac_id
from PRC_PROCEDIMIENTOS prc
  join DD_TPO_TIPO_PROCEDIMIENTO tpo on prc.dd_tpo_id = tpo.dd_tpo_id
where PRC.DD_TAC_ID is null
) tmp
on (prc.prc_id = tmp.prc_id)
when matched then update set prc.dd_tac_id = tmp.dd_tac_id;

commit;
*/