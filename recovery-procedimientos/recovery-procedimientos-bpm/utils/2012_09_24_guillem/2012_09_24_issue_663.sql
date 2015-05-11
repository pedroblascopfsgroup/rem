-- BORRADO LÓGICO DE LAS TAREAS PADRES DE LAS TAREAS PARALIZADAS
update tar_tareas_notificaciones set borrado = 1 where tar_id in (
    select vtar.tar_id
    from dpr_decisiones_procedimientos dpr
    left join vtar_tarea_vs_usuario vtar on dpr.prc_id = vtar.prc_id
    left join tex_tarea_externa tex on vtar.tar_id = tex.tar_id
    where dpr.dpr_paraliza = 1 and dd_ede_id = 2
);
