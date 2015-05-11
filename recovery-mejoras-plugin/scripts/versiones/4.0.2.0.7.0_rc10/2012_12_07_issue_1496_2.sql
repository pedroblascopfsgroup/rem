-- 1. CREAMOS REGISTROS EN LA TABLA DE REACTIVAR PARA LAS TAREAS DE 'Toma decisión después de cesión de remate'
insert into bpm_reactivar_bpm (rpr_referencia, prc_id, tap_id, tex_id)   
    SELECT ugasmaster.hibernate_sequence.NEXTVAL,
    prc.prc_id,
    10000000000705,
    tex.tex_id
    FROM tar_tareas_notificaciones tar 
        JOIN prc_procedimientos prc on tar.prc_id = prc.prc_id
        JOIN tex_tarea_externa tex on tar.tar_id = tex.tar_id
    WHERE tar.tar_tarea = 'Toma decisión después de cesión de remate';
    
-- 2. CREAMOS VARIABLES DE INSTANCIA PARA ESTAS TAREAS
INSERT INTO ugasmaster.jbpm_variableinstance
            (id_, class_, version_, name_, token_, tokenvariablemap_,
             processinstance_, stringvalue_)                
   SELECT ugasmaster.hibernate_sequence.NEXTVAL, 'S' class_, 0 version_,
          'NOMBRE_NODO_SALIENTE' name_, pi.roottoken_ tokem_, vm.id_ tokenvariablemap_,
          pi.id_ processinstance_, nd.name_ longvlaue_
     FROM bpm_reactivar_bpm tmp JOIN prc_procedimientos prc
          ON tmp.prc_id = prc.prc_id
          JOIN ugasmaster.jbpm_processinstance pi ON prc.prc_process_bpm =
                                                                        pi.id_
          JOIN ugasmaster.jbpm_tokenvariablemap vm ON pi.roottoken_ =
                                                                     vm.token_
          JOIN ugasmaster.jbpm_token tk ON pi.roottoken_ = tk.id_
          JOIN ugasmaster.jbpm_node nd ON tk.node_ = nd.id_
          JOIN tex_tarea_externa tex
          ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
    WHERE NOT EXISTS (SELECT *
                        FROM ugasmaster.jbpm_variableinstance
                       WHERE processinstance_ = pi.id_ AND name_ = 'NOMBRE_NODO_SALIENTE');
                    
-- 3. LIMPIAMOS LA TABLA DE REACTIVAR
delete from bpm_reactivar_bpm;