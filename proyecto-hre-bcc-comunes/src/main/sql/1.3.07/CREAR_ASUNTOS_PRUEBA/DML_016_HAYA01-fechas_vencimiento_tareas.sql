--Asignar fechas de vencimiento a tareas
UPDATE TAR_TAREAS_NOTIFICACIONES SET TAR_FECHA_VENC = TRUNC(FECHACREAR +5), TAR_FECHA_VENC_REAL = TRUNC(FECHACREAR +5) WHERE (TAR_TAREA_FINALIZADA IS NULL OR TAR_TAREA_FINALIZADA = 0) AND BORRADO = 0 AND TAR_FECHA_VENC IS NULL;

--Le pongo 150000 de Importe Principal de los procedimientos.
update prc_procedimientos set prc_saldo_recuperacion=150000;

commit;