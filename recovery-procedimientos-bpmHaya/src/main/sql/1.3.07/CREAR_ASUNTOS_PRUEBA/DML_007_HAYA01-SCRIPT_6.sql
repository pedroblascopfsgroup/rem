 BEGIN
  ALTA_BPM_INSTANCES();
--rollback; 
END;
/

commit;

/*
--ROBERTO: aunque el procedimiento "ALTA_BPM_INSTANCES" se corrige en otro script DDL anterior, si hace falta se puede ejecutar esta consulta y si saca contenido también el merge
 MERGE INTO TEX_TAREA_EXTERNA TEX
    USING (
      select tex.tex_id, pi.roottoken_
      from tex_tarea_externa tex
        join tar_tareas_notificaciones tar on tex.tar_id = tar.tar_id
        join prc_procedimientos prc on tar.prc_id = prc.prc_id
        join HAYAMASTER.jbpm_processinstance pi on prc.prc_process_bpm = pi.id_
      where tex.tex_token_id_bpm is null
    ) TMP
    ON (TEX.TEX_ID = TMP.TEX_ID)
    WHEN MATCHED THEN UPDATE SET TEX.TEX_TOKEN_ID_BPM = TMP.roottoken_
      ,USUARIOMODIFICAR = 'AUTO', fechamodificar = sysdate;
      
commit;
*/