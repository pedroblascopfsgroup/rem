SET DEFINE OFF;

--HR-463
update tap_tarea_procedimiento set dd_sta_id = (select dd_sta_id from HAYAMASTER.dd_sta_subtipo_tarea_base where dd_sta_codigo = '815')
where tap_codigo = 'H037_registrarConvenioPropio';


commit;