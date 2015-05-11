update tap_tarea_procedimiento tap
set tap_script_decision='' 
where  tap.DD_TPO_ID in 
    (select dd_tpo_id from dd_tpo_tipo_procedimiento where borrado=0);

commit;