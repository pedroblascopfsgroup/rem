/* Formatted on 2014/07/23 18:45 (Formatter Plus v4.8.8) */
-- Preparar las tablas (Se ejecutará SOLO una vez en los scripts de base de datos)

ALTER TABLE tmp_ugaspfs_bpm_input_con1 ADD  t_referencia NUMBER(16);

--alter table tar_tareas_notificaciones add  t_referencia number(16);
--alter table tex_tarea_externa add  t_referencia number(16);
--alter table HAYAMASTER.jbpm_token add  t_referencia number(16);
--alter table HAYAMASTER.jbpm_processinstance add  t_referencia number(16);

-- Limpiando restos de ejecuciones anteriores

UPDATE tar_tareas_notificaciones
   SET t_referencia = NULL
 WHERE t_referencia IS NOT NULL;
 
UPDATE tex_tarea_externa
   SET t_referencia = NULL
 WHERE t_referencia IS NOT NULL;
 
UPDATE hayamaster.jbpm_token
   SET t_referencia = NULL
 WHERE t_referencia IS NOT NULL;
 
UPDATE hayamaster.jbpm_processinstance
   SET t_referencia = NULL
 WHERE t_referencia IS NOT NULL;
 
UPDATE tmp_ugaspfs_bpm_input_con1
   SET t_referencia = ROWNUM;


COMMIT ;

-- Insert de la tarea

INSERT INTO tar_tareas_notificaciones
            (tar_id, asu_id, dd_est_id, dd_ein_id, dd_sta_id, tar_codigo,
             tar_tarea, tar_descripcion, tar_fecha_fin, tar_fecha_ini,
             tar_en_espera, tar_alerta, tar_tarea_finalizada, tar_emisor,
             VERSION, usuariocrear, fechacrear, borrado, prc_id, dtype,
             nfa_tar_revisada, t_referencia)
   SELECT s_tar_tareas_notificaciones.NEXTVAL tar_id, prc.asu_id, 6 dd_est_id,
          5 dd_ein_id, NVL(tap.dd_sta_id,39) dd_sta_id, 1 tar_codigo,
          tap.tap_descripcion tar_tarea, tap.tap_descripcion tar_descripcion,
          NULL tar_fecha_fin, SYSDATE tar_fecha_ini, 0 tar_en_espera,
          0 tar_alerta, NULL tar_tarea_finalizada, 'AUTOMATICA' tar_emisor, 0,
          'AUTOMATICA', SYSDATE, 0, prc.prc_id, 'EXTTareaNotificacion' dtype,
          0 nfa_tar_revisada, tmp.t_referencia
     FROM tmp_ugaspfs_bpm_input_con1 tmp JOIN tap_tarea_procedimiento tap
          ON tmp.tap_id = tap.tap_id
          --join cex_contratos_expediente cex on tmp.cnt_id = cex.cnt_id
          --join prc_cex on cex.cex_id = prc_cex. cex_id
          JOIN prc_procedimientos prc ON tmp.prc_id = prc.prc_id
          ;

COMMIT ;

INSERT INTO tex_tarea_externa
            (tex_id, tar_id, tap_id, tex_token_id_bpm, tex_detenida, VERSION,
             usuariocrear, fechacrear, borrado, dtype, t_referencia)
   SELECT s_tex_tarea_externa.NEXTVAL, tar.tar_id, tmp.tap_id, NULL, 0, 0,
          'AUTOMATICA', SYSDATE, 0, 'EXTTareaExterna', tmp.t_referencia
     FROM tmp_ugaspfs_bpm_input_con1 tmp JOIN tar_tareas_notificaciones tar
          ON tmp.t_referencia = tar.t_referencia
          ;

COMMIT ;

INSERT INTO hayamaster.jbpm_processinstance
            (id_, version_, start_, end_, issuspended_, processdefinition_,
             t_referencia)
   SELECT hayamaster.hibernate_sequence.NEXTVAL, 1 version_, SYSDATE start_,
          NULL end_, 0 issuspended_, maxpd.id_ processdefinition_,
          tmp.t_referencia
     FROM tmp_ugaspfs_bpm_input_con1 tmp
                                        --join prc_procedimientos prc on tmp.prc_id = prc.prc_id
          JOIN tap_tarea_procedimiento tap ON tmp.tap_id = tap.tap_id
          JOIN dd_tpo_tipo_procedimiento tpo ON tap.dd_tpo_id = tpo.dd_tpo_id
          JOIN tar_tareas_notificaciones tar
          ON tmp.t_referencia = tar.t_referencia
          JOIN
          (SELECT   name_, MAX (id_) id_
               FROM hayamaster.jbpm_processdefinition
           GROUP BY name_) maxpd ON tpo.dd_tpo_xml_jbpm = maxpd.name_
          ;

COMMIT ;




MERGE INTO prc_procedimientos t1
   USING (SELECT prc.prc_id, prc.prc_process_bpm viejo, pi.id_ nuevo
            FROM prc_procedimientos prc
                                       --join prc_cex on prc.prc_id = prc_cex.prc_id
                                       --join cex_contratos_expediente cex on prc_cex.cex_id = cex.cex_id
                 JOIN tmp_ugaspfs_bpm_input_con1 tmp ON prc.prc_id =
                                                                    tmp.prc_id
                 JOIN hayamaster.jbpm_processinstance pi
                 ON tmp.t_referencia = pi.t_referencia
                 ) q
   ON (t1.prc_id = q.prc_id)
   WHEN MATCHED THEN
      UPDATE
         SET t1.prc_process_bpm = q.nuevo;  

COMMIT ;

MERGE INTO prc_procedimientos t1
   USING (SELECT prc.prc_id, prc.dd_tpo_id viejo, tap.dd_tpo_id nuevo
                           FROM prc_procedimientos prc
                                                      --join prc_cex on prc.prc_id = prc_cex.prc_id
                                                      --join cex_contratos_expediente cex on prc_cex.cex_id = cex.cex_id
                                JOIN tmp_ugaspfs_bpm_input_con1 tmp
                                ON prc.prc_id = tmp.prc_id
                                JOIN tap_tarea_procedimiento tap
                                ON tmp.tap_id = tap.tap_id
                                ) q
   ON (t1.prc_id = q.prc_id)
   WHEN MATCHED THEN
      UPDATE
         SET t1.dd_tpo_id = q.nuevo;
         
COMMIT ;

INSERT INTO hayamaster.jbpm_token
            (id_, version_, start_, end_, nodeenter_, issuspended_, node_,
             processinstance_, t_referencia)
   SELECT hayamaster.hibernate_sequence.NEXTVAL, 1 version_, SYSDATE start_,
          NULL end_, SYSDATE nodeenter_, 0 issuspended_, node.id_ node_,
          pi.id_ processinstance_, tmp.t_referencia
     FROM tmp_ugaspfs_bpm_input_con1 tmp JOIN tar_tareas_notificaciones tar
          ON tmp.t_referencia = tar.t_referencia
          JOIN tap_tarea_procedimiento tap ON tmp.tap_id = tap.tap_id
          JOIN prc_procedimientos prc ON tmp.prc_id = prc.prc_id
          JOIN dd_tpo_tipo_procedimiento tpo ON prc.dd_tpo_id = tpo.dd_tpo_id
          JOIN
          (SELECT   name_, MAX (id_) id_
               FROM hayamaster.jbpm_processdefinition
           GROUP BY name_) maxpd ON tpo.dd_tpo_xml_jbpm = maxpd.name_
          JOIN hayamaster.jbpm_node node
          ON maxpd.id_ = node.processdefinition_
        AND tap.tap_codigo = node.name_
          JOIN hayamaster.jbpm_processinstance pi
          ON tmp.t_referencia = pi.t_referencia
          ;


COMMIT ;

MERGE INTO hayamaster.jbpm_processinstance t1
   USING (SELECT pi.ID_, pi.roottoken_ viejo, tk.id_ nuevo
                           FROM hayamaster.jbpm_processinstance pi JOIN hayamaster.jbpm_token tk
                                ON pi.t_referencia = tk.t_referencia
                                ) q
    ON (t1.ID_ = q.ID_)
   WHEN MATCHED THEN
      UPDATE
         SET t1.roottoken_ = q.nuevo;


COMMIT ;

merge into tex_tarea_externa t1 
    using (SELECT tex.tex_id, tex.tex_token_id_bpm viejo, tk.id_ nuevo
                           FROM tex_tarea_externa tex JOIN hayamaster.jbpm_token tk
                                ON tex.t_referencia = tk.t_referencia
                                ) q
                            on (t1.tex_id = q.tex_id)
                            when matched then
                            update
                            set t1.tex_token_id_bpm = q.nuevo;
   

COMMIT ;

-------------------- AQUI HAY QUE VOLVER A EMPEZAR


-------------------- AQUI HAY QUE VOLVER A EMPEZAR

INSERT INTO hayamaster.jbpm_moduleinstance
            (id_, class_, version_, processinstance_, name_)
   SELECT hayamaster.hibernate_sequence.NEXTVAL, 'C' class_, 0 version_,
          prc.prc_process_bpm processinstance_,
          'org.jbpm.context.exe.ContextInstance' name_
     FROM prc_procedimientos prc JOIN hayamaster.jbpm_processinstance pi
          ON prc.prc_process_bpm = pi.id_
          JOIN hayamaster.jbpm_token tk ON pi.roottoken_ = tk.id_
          JOIN hayamaster.jbpm_node nd ON tk.node_ = nd.id_
          JOIN tex_tarea_externa tex
          ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
          JOIN tmp_ugaspfs_bpm_input_con1 ug ON ug.prc_id = prc.prc_id
    WHERE NOT EXISTS (SELECT *
                        FROM hayamaster.jbpm_moduleinstance
                       WHERE processinstance_ = prc.prc_process_bpm);

COMMIT ;

INSERT INTO hayamaster.jbpm_tokenvariablemap
            (id_, version_, token_, contextinstance_)
   SELECT hayamaster.hibernate_sequence.NEXTVAL, 0 version_, pi.roottoken_,
          mi.id_ contextinstance_
     FROM prc_procedimientos prc JOIN hayamaster.jbpm_processinstance pi
          ON prc.prc_process_bpm = pi.id_
          JOIN hayamaster.jbpm_moduleinstance mi ON pi.id_ =
                                                           mi.processinstance_
          JOIN hayamaster.jbpm_token tk ON pi.roottoken_ = tk.id_
          JOIN hayamaster.jbpm_node nd ON tk.node_ = nd.id_
          JOIN tex_tarea_externa tex
          ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
    WHERE NOT EXISTS (SELECT *
                        FROM hayamaster.jbpm_tokenvariablemap
                       WHERE token_ = pi.roottoken_);

COMMIT ;

INSERT INTO hayamaster.jbpm_variableinstance
            (id_, class_, version_, name_, token_, tokenvariablemap_,
             processinstance_, longvalue_)
   SELECT hayamaster.hibernate_sequence.NEXTVAL, 'L' class_, 0 version_,
          'DB_ID' name_, pi.roottoken_ tokem_, vm.id_ tokenvariablemap_,
          pi.id_ processinstance_, 1 longvlaue_
     FROM prc_procedimientos prc JOIN hayamaster.jbpm_processinstance pi
          ON prc.prc_process_bpm = pi.id_
          JOIN hayamaster.jbpm_tokenvariablemap vm ON pi.roottoken_ =
                                                                     vm.token_
          JOIN hayamaster.jbpm_token tk ON pi.roottoken_ = tk.id_
          JOIN hayamaster.jbpm_node nd ON tk.node_ = nd.id_
          JOIN tex_tarea_externa tex
          ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
    WHERE NOT EXISTS (SELECT *
                        FROM hayamaster.jbpm_variableinstance
                       WHERE processinstance_ = pi.id_ AND name_ = 'DB_ID');


COMMIT ;

INSERT INTO hayamaster.jbpm_variableinstance
            (id_, class_, version_, name_, token_, tokenvariablemap_,
             processinstance_, longvalue_)
   SELECT hayamaster.hibernate_sequence.NEXTVAL, 'L' class_, 0 version_,
          'procedimientoTareaExterna' name_, pi.roottoken_ tokem_,
          vm.id_ tokenvariablemap_, pi.id_ processinstance_,
          prc.prc_id longvlaue_
     FROM prc_procedimientos prc JOIN hayamaster.jbpm_processinstance pi
          ON prc.prc_process_bpm = pi.id_
          JOIN hayamaster.jbpm_tokenvariablemap vm ON pi.roottoken_ =
                                                                     vm.token_
          JOIN hayamaster.jbpm_token tk ON pi.roottoken_ = tk.id_
          JOIN hayamaster.jbpm_node nd ON tk.node_ = nd.id_
          JOIN tex_tarea_externa tex
          ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
    WHERE NOT EXISTS (
             SELECT *
               FROM hayamaster.jbpm_variableinstance
              WHERE processinstance_ = pi.id_
                AND name_ = 'procedimientoTareaExterna');

COMMIT ;

INSERT INTO hayamaster.jbpm_variableinstance
            (id_, class_, version_, name_, token_, tokenvariablemap_,
             processinstance_, longvalue_)
   SELECT hayamaster.hibernate_sequence.NEXTVAL, 'L' class_, 0 version_,
          'bpmParalizado' name_, pi.roottoken_ tokem_,
          vm.id_ tokenvariablemap_, pi.id_ processinstance_, 0 longvlaue_
     FROM prc_procedimientos prc JOIN hayamaster.jbpm_processinstance pi
          ON prc.prc_process_bpm = pi.id_
          JOIN hayamaster.jbpm_tokenvariablemap vm ON pi.roottoken_ =
                                                                     vm.token_
          JOIN hayamaster.jbpm_token tk ON pi.roottoken_ = tk.id_
          JOIN hayamaster.jbpm_node nd ON tk.node_ = nd.id_
          JOIN tex_tarea_externa tex
          ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
    WHERE NOT EXISTS (
                   SELECT *
                     FROM hayamaster.jbpm_variableinstance
                    WHERE processinstance_ = pi.id_
                          AND name_ = 'bpmParalizado');

COMMIT ;

INSERT INTO hayamaster.jbpm_variableinstance
            (id_, class_, version_, name_, token_, tokenvariablemap_,
             processinstance_, longvalue_)
   SELECT HAYAMASTER.hibernate_sequence.NEXTVAL, 'L' class_, 0 version_,
          'id' || nd.name_ name_, pi.roottoken_ tokem_,
          vm.id_ tokenvariablemap_, pi.id_ processinstance_,
          tex.tex_id longvlaue_
     FROM prc_procedimientos prc JOIN tmp_ugaspfs_bpm_input_con1 tmp
          ON prc.prc_id = tmp.prc_id
          JOIN HAYAMASTER.jbpm_processinstance pi ON prc.prc_process_bpm =
                                                                        pi.id_
          JOIN HAYAMASTER.jbpm_token tk ON pi.roottoken_ = tk.id_
          JOIN HAYAMASTER.jbpm_node nd ON tk.node_ = nd.id_
          JOIN HAYAMASTER.jbpm_tokenvariablemap vm ON pi.roottoken_ =
                                                                     vm.token_
          JOIN tex_tarea_externa tex
          ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
    WHERE NOT EXISTS (
                  SELECT *
                    FROM HAYAMASTER.jbpm_variableinstance
                   WHERE processinstance_ = pi.id_
                         AND name_ = 'id' || nd.name_)
      AND tex.usuariocrear = 'AUTOMATICA';

COMMIT ;

UPDATE HAYAMASTER.jbpm_token
   SET nextlogindex_ = 0
 WHERE nextlogindex_ IS NULL;
UPDATE HAYAMASTER.jbpm_token
   SET isabletoreactivateparent_ = 0
 WHERE isabletoreactivateparent_ IS NULL;
UPDATE HAYAMASTER.jbpm_token
   SET isterminationimplicit_ = 0
 WHERE isterminationimplicit_ IS NULL;

-- Esto es para que funcionen las prorrogas

INSERT INTO HAYAMASTER.jbpm_transition
            (id_, name_, processdefinition_, from_, to_, fromindex_)
   SELECT HAYAMASTER.hibernate_sequence.NEXTVAL id_, 'activarProrroga' name_,
          pd processdefinition_, nd from_, nd to_,
          (max_fromindex + 1) fromindex_
     FROM (SELECT   nd.id_ nd, nd.processdefinition_ pd,
                    MAX (aux.fromindex_) max_fromindex
               FROM tar_tareas_notificaciones tar JOIN tex_tarea_externa tex
                    ON tar.tar_id = tex.tar_id
                    JOIN tap_tarea_procedimiento tap ON tex.tap_id =
                                                                    tap.tap_id
                    JOIN prc_procedimientos prc ON tar.prc_id = prc.prc_id
                    JOIN HAYAMASTER.jbpm_processinstance pi
                    ON prc.prc_process_bpm = pi.id_
                    JOIN HAYAMASTER.jbpm_token tk ON pi.roottoken_ = tk.id_
                    JOIN HAYAMASTER.jbpm_node nd ON tk.node_ = nd.id_
                    JOIN tmp_ugaspfs_bpm_input_con1 ug ON prc.prc_id =
                                                                     ug.prc_id
                    LEFT JOIN HAYAMASTER.jbpm_transition aux
                    ON nd.id_ = aux.from_
                    LEFT JOIN HAYAMASTER.jbpm_transition tr
                    ON nd.id_ = tr.from_ AND tr.name_ = 'activarProrroga'
              WHERE tar.borrado = 0
                AND (   tar.tar_tarea_finalizada IS NULL
                     OR tar.tar_tarea_finalizada = 0
                    )
                AND tar.prc_id IS NOT NULL
                AND tap.tap_autoprorroga = 1
                AND tr.id_ IS NULL
           GROUP BY nd.id_, nd.processdefinition_);

COMMIT ;

COMMIT ;

--alter table tmp_ugaspfs_bpm_input_con1 drop column  t_referencia;
--alter table tar_tareas_notificaciones drop column  t_referencia;
--alter table tex_tarea_externa drop column  t_referencia;
--alter table HAYAMASTER.jbpm_token drop column  t_referencia;
--alter table HAYAMASTER.jbpm_processinstance drop column  t_referencia;

UPDATE tar_tareas_notificaciones
   SET t_referencia = NULL
 WHERE t_referencia IS NOT NULL;
UPDATE tex_tarea_externa
   SET t_referencia = NULL
 WHERE t_referencia IS NOT NULL;
UPDATE HAYAMASTER.jbpm_token
   SET t_referencia = NULL
 WHERE t_referencia IS NOT NULL;
UPDATE HAYAMASTER.jbpm_processinstance
   SET t_referencia = NULL
 WHERE t_referencia IS NOT NULL;

COMMIT ;

-- Ponemos fechas de vencimiento 

UPDATE tar_tareas_notificaciones
   SET tar_fecha_venc = SYSDATE + (DBMS_RANDOM.VALUE (1, 5))
 WHERE fechacrear > SYSDATE - 0.1
   AND tar_fecha_venc IS NULL
   AND prc_id IS NOT NULL
   AND tar_tarea_finalizada IS NULL
   AND tar_tar_id IS NULL;
COMMIT ;
UPDATE tar_tareas_notificaciones
   SET tar_fecha_venc_real = tar_fecha_venc
 WHERE tar_fecha_venc IS NOT NULL AND tar_fecha_venc_real IS NULL;
COMMIT ;