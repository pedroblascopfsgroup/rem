CREATE OR REPLACE FORCE VIEW vtar_tarea_vs_usuario_part1 (usu_pendiente,
                                                                 usu_espera,
                                                                 usu_alerta,
                                                                 nombre_asunto,
                                                                 nombre_procedimiento,
                                                                 dd_ein_codigo,
                                                                 tar_dtype,
                                                                 dd_sta_codigo,
                                                                 dd_sta_descripcion,
                                                                 diasvencidosql,
                                                                 tiposolicitudsql,
                                                                 entidadinformacion,
                                                                 asu_fechacrear,
                                                                 prc_fechacrear,
                                                                 asu_situacion,
                                                                 desc_tar_asociada,
                                                                 asu_apenom_gestor,
                                                                 asu_apenom_supervisor,
                                                                 vre_via_prc,
                                                                 tar_tar_id,
                                                                 prc_id,
                                                                 asu_id,
                                                                 rpr_referencia,
                                                                 per_id,
                                                                 tar_id_dest,
                                                                 tar_tipo_destinatario,
                                                                 tar_destinatario,
                                                                 cnt_id,
                                                                 dd_tra_id,
                                                                 nfa_tar_comentarios_alerta,
                                                                 nfa_tar_fecha_revis_aler,
                                                                 nfa_tar_revisada,
                                                                 dtype,
                                                                 tar_fecha_venc_real,
                                                                 obj_id,
                                                                 tar_fecha_venc,
                                                                 set_id,
                                                                 cmb_id,
                                                                 borrado,
                                                                 fechaborrar,
                                                                 usuarioborrar,
                                                                 fechamodificar,
                                                                 usuariomodificar,
                                                                 fechacrear,
                                                                 usuariocrear,
                                                                 VERSION,
                                                                 tar_emisor,
                                                                 tar_tarea_finalizada,
                                                                 tar_alerta,
                                                                 tar_en_espera,
                                                                 tar_fecha_ini,
                                                                 tar_fecha_fin,
                                                                 tar_descripcion,
                                                                 dd_ein_id,
                                                                 tar_tarea,
                                                                 tar_codigo,
                                                                 dd_sta_id,
                                                                 dd_est_id,
                                                                 scx_id,
                                                                 spr_id,
                                                                 exp_id,
                                                                 cli_id,
                                                                 tar_id,
                                                                 dd_tge_id_alerta,
                                                                 dd_tge_id_espera,
                                                                 dd_tge_id_pendiente
                                                                )
AS
   SELECT vtar.usu_pendiente, NVL (vtar.usu_espera, -1) usu_espera, NVL (vtar.usu_alerta, -1) usu_alerta, vtar.asu_nombre nombre_asunto,
          CASE
             WHEN tpo.dd_tpo_descripcion IS NOT NULL
                THEN vtar.asu_nombre || '-' || tpo.dd_tpo_descripcion
             ELSE vtar.asu_nombre
          END nombre_procedimiento, tpo_ent.dd_ein_codigo, vtar.dtype tar_dtype, sbt_tar.dd_sta_codigo, sbt_tar.dd_sta_descripcion,
          EXTRACT (DAY FROM (SYSTIMESTAMP - (TRUNC (vtar.tar_fecha_venc)))) diasvencidosql,
          (SELECT CASE
                     WHEN stb.dd_sta_codigo IN ('5', '6', '54', '41')
                        THEN 'Prórroga'
                     WHEN stb.dd_sta_codigo IN ('17')
                        THEN 'Cancelación Expediente'
                     WHEN stb.dd_sta_codigo IN ('29')
                        THEN 'Expediente Manual'
                     WHEN stb.dd_sta_codigo IN ('16', '28', '24', '26', '27', '589', '590', '15')
                        THEN 'Comunicación'
                     ELSE ''
                  END
             FROM tar_tareas_notificaciones tn, bankmaster.dd_sta_subtipo_tarea_base stb
            WHERE tn.dd_sta_id = stb.dd_sta_id AND tn.tar_id = vtar.tar_id) tiposolicitudsql,
          tpo_ent.dd_ein_descripcion entidadinformacion, vtar.fechacrear_asu asu_fechacrear, prc.fechacrear prc_fechacrear, est.dd_est_descripcion asu_situacion,
          asoc.tar_descripcion desc_tar_asociada, ges.apellido_nombre asu_apenom_gestor, sup.apellido_nombre asu_apenom_supervisor, NVL (vre_prc.vre, 0) vre_via_prc, vtar.tar_tar_id, vtar.prc_id,
          vtar.asu_id, vtar.rpr_referencia, vtar.per_id, vtar.tar_id_dest, vtar.tar_tipo_destinatario, vtar.tar_destinatario, vtar.cnt_id, vtar.dd_tra_id, vtar.nfa_tar_comentarios_alerta,
          vtar.nfa_tar_fecha_revis_aler, vtar.nfa_tar_revisada, vtar.dtype, vtar.tar_fecha_venc_real, vtar.obj_id, vtar.tar_fecha_venc, vtar.set_id, vtar.cmb_id, vtar.borrado, vtar.fechaborrar,
          vtar.usuarioborrar, vtar.fechamodificar, vtar.usuariomodificar, vtar.fechacrear, vtar.usuariocrear, vtar.VERSION, vtar.tar_emisor, vtar.tar_tarea_finalizada, vtar.tar_alerta,
          vtar.tar_en_espera, vtar.tar_fecha_ini, vtar.tar_fecha_fin, vtar.tar_descripcion, vtar.dd_ein_id, vtar.tar_tarea, vtar.tar_codigo, vtar.dd_sta_id, vtar.dd_est_id, vtar.scx_id, vtar.spr_id,
          vtar.exp_id, vtar.cli_id, vtar.tar_id, vtar.dd_tge_id_alerta, vtar.dd_tge_id_espera, vtar.dd_tge_id_pendiente
     FROM vtar_tarea_vs_responsables vtar LEFT JOIN prc_procedimientos prc ON vtar.prc_id = prc.prc_id
          LEFT JOIN dd_tpo_tipo_procedimiento tpo ON prc.dd_tpo_id = tpo.dd_tpo_id
          LEFT JOIN bankmaster.dd_ein_entidad_informacion tpo_ent ON vtar.dd_ein_id = tpo_ent.dd_ein_id
          LEFT JOIN bankmaster.dd_sta_subtipo_tarea_base sbt_tar ON vtar.dd_sta_id = sbt_tar.dd_sta_id
          LEFT JOIN bankmaster.dd_est_estados_itinerarios est ON vtar.dd_est_id = est.dd_est_id
          LEFT JOIN tar_tareas_notificaciones asoc ON vtar.tar_tar_id = asoc.tar_id
          LEFT JOIN vtar_nombres_usuarios ges ON vtar.usu_pendiente = ges.usu_id
          LEFT JOIN vtar_nombres_usuarios sup ON vtar.usu_supervisor = sup.usu_id
          LEFT JOIN vtar_tar_vre_via_prc vre_prc ON vtar.tar_id = vre_prc.tar_id
          ;


CREATE OR REPLACE FORCE VIEW vtar_tarea_vs_usuario_part2 (usu_pendiente,
                                                                 usu_espra,
                                                                 usu_alerta,
                                                                 nombre_asunto,
                                                                 nombre_procedimiento,
                                                                 dd_ein_codigo,
                                                                 tar_dtype,
                                                                 dd_sta_codigo,
                                                                 dd_sta_descripcion,
                                                                 diasvencidosql,
                                                                 tiposolicitudsql,
                                                                 entidadinformacion,
                                                                 asu_fechacrear,
                                                                 prc_fechacrear,
                                                                 asu_situacion,
                                                                 desc_tar_asociada,
                                                                 asu_apenom_gestor,
                                                                 asu_apenom_supervisor,
                                                                 vre_via_prc,
                                                                 tar_tar_id,
                                                                 prc_id,
                                                                 asu_id,
                                                                 rpr_referencia,
                                                                 per_id,
                                                                 tar_id_dest,
                                                                 tar_tipo_destinatario,
                                                                 tar_destinatario,
                                                                 cnt_id,
                                                                 dd_tra_id,
                                                                 nfa_tar_comentarios_alerta,
                                                                 nfa_tar_fecha_revis_aler,
                                                                 nfa_tar_revisada,
                                                                 dtype,
                                                                 tar_fecha_venc_real,
                                                                 obj_id,
                                                                 tar_fecha_venc,
                                                                 set_id,
                                                                 cmb_id,
                                                                 borrado,
                                                                 fechaborrar,
                                                                 usuarioborrar,
                                                                 fechamodificar,
                                                                 usuariomodificar,
                                                                 fechacrear,
                                                                 usuariocrear,
                                                                 VERSION,
                                                                 tar_emisor,
                                                                 tar_tarea_finalizada,
                                                                 tar_alerta,
                                                                 tar_en_espera,
                                                                 tar_fecha_ini,
                                                                 tar_fecha_fin,
                                                                 tar_descripcion,
                                                                 dd_ein_id,
                                                                 tar_tarea,
                                                                 tar_codigo,
                                                                 dd_sta_id,
                                                                 dd_est_id,
                                                                 scx_id,
                                                                 spr_id,
                                                                 exp_id,
                                                                 cli_id,
                                                                 tar_id,
                                                                 dd_tge_id_alerta,
                                                                 dd_tge_id_espera,
                                                                 dd_tge_id_pendiente
                                                                )
AS
   SELECT t.tar_id_dest usu_pendiente, -1 usu_espra, -1 usu_alerta, asu.asu_nombre nombre_asunto,
          CASE
             WHEN tpo.dd_tpo_descripcion IS NOT NULL
                THEN asu.asu_nombre || '-' || tpo.dd_tpo_descripcion
             ELSE asu.asu_nombre
          END nombre_procedimiento, tpo_ent.dd_ein_codigo, t.dtype tar_dtype, sbt_tar.dd_sta_codigo, sbt_tar.dd_sta_descripcion,
          EXTRACT (DAY FROM (SYSTIMESTAMP - (TRUNC (t.tar_fecha_venc)))) diasvencidosql,
          (SELECT CASE
                     WHEN stb.dd_sta_codigo IN ('5', '6', '54', '41')
                        THEN 'Prórroga'
                     WHEN stb.dd_sta_codigo IN ('17')
                        THEN 'Cancelación Expediente'
                     WHEN stb.dd_sta_codigo IN ('29')
                        THEN 'Expediente Manual'
                     WHEN stb.dd_sta_codigo IN ('16', '28', '24', '26', '27', '589', '590', '15')
                        THEN 'Comunicación'
                     ELSE ''
                  END
             FROM tar_tareas_notificaciones tn, bankmaster.dd_sta_subtipo_tarea_base stb
            WHERE tn.dd_sta_id = stb.dd_sta_id AND tn.tar_id = t.tar_id) tiposolicitudsql,
          tpo_ent.dd_ein_descripcion entidadinformacion, asu.fechacrear asu_fechacrear, prc.fechacrear prc_fechacrear, est.dd_est_descripcion asu_situacion, asoc.tar_descripcion desc_tar_asociada,
          ges.apellido_nombre asu_apenom_gestor, sup.apellido_nombre asu_apenom_supervisor, NVL (vre_prc.vre, 0) vre_via_prc, t.tar_tar_id, t.prc_id, t.asu_id, t.rpr_referencia, t.per_id,
          t.tar_id_dest, t.tar_tipo_destinatario, t.tar_destinatario, t.cnt_id, t.dd_tra_id, t.nfa_tar_comentarios_alerta, t.nfa_tar_fecha_revis_aler, t.nfa_tar_revisada, t.dtype,
          t.tar_fecha_venc_real, t.obj_id, t.tar_fecha_venc, t.set_id, t.cmb_id, t.borrado, t.fechaborrar, t.usuarioborrar, t.fechamodificar, t.usuariomodificar, t.fechacrear, t.usuariocrear,
          t.VERSION, t.tar_emisor, t.tar_tarea_finalizada, t.tar_alerta, t.tar_en_espera, t.tar_fecha_ini, t.tar_fecha_fin, t.tar_descripcion, t.dd_ein_id, t.tar_tarea, t.tar_codigo, t.dd_sta_id,
          t.dd_est_id, t.scx_id, t.spr_id, t.exp_id, t.cli_id, t.tar_id, t.dd_tge_id_alerta, t.dd_tge_id_espera, t.dd_tge_id_pendiente
     FROM vtar_tarea_vs_tge t LEFT JOIN asu_asuntos asu ON t.asu_id = asu.asu_id
          LEFT JOIN prc_procedimientos prc ON t.prc_id = prc.prc_id
          LEFT JOIN dd_tpo_tipo_procedimiento tpo ON prc.dd_tpo_id = tpo.dd_tpo_id
          LEFT JOIN bankmaster.dd_ein_entidad_informacion tpo_ent ON t.dd_ein_id = tpo_ent.dd_ein_id
          LEFT JOIN bankmaster.dd_sta_subtipo_tarea_base sbt_tar ON t.dd_sta_id = sbt_tar.dd_sta_id
          LEFT JOIN bankmaster.dd_est_estados_itinerarios est ON asu.dd_est_id = est.dd_est_id
          LEFT JOIN tar_tareas_notificaciones asoc ON t.tar_tar_id = asoc.tar_id
          LEFT JOIN vtar_asunto_gestor sup ON asu.asu_id = sup.asu_id AND t.dd_tge_id_supervisor = sup.dd_tge_id
          LEFT JOIN vtar_asunto_gestor ges ON asu.asu_id = ges.asu_id AND t.dd_tge_id_pendiente = ges.dd_tge_id
          LEFT JOIN vtar_tar_vre_via_prc vre_prc ON t.tar_id = vre_prc.tar_id
    WHERE t.dd_sta_id IN (700, 701);


CREATE OR REPLACE FORCE VIEW vtar_tarea_vs_usuario (usu_pendientes,
                                                           usu_espera,
                                                           usu_alerta,
                                                           dd_tge_id_pendiente,
                                                           dd_tge_id_espera,
                                                           dd_tge_id_alerta,
                                                           tar_id,
                                                           cli_id,
                                                           exp_id,
                                                           asu_id,
                                                           tar_tar_id,
                                                           spr_id,
                                                           scx_id,
                                                           dd_est_id,
                                                           dd_ein_id,
                                                           dd_sta_id,
                                                           tar_codigo,
                                                           tar_tarea,
                                                           tar_descripcion,
                                                           tar_fecha_fin,
                                                           tar_fecha_ini,
                                                           tar_en_espera,
                                                           tar_alerta,
                                                           tar_tarea_finalizada,
                                                           tar_emisor,
                                                           VERSION,
                                                           usuariocrear,
                                                           fechacrear,
                                                           usuariomodificar,
                                                           fechamodificar,
                                                           usuarioborrar,
                                                           fechaborrar,
                                                           borrado,
                                                           prc_id,
                                                           cmb_id,
                                                           set_id,
                                                           tar_fecha_venc,
                                                           obj_id,
                                                           tar_fecha_venc_real,
                                                           dtype,
                                                           nfa_tar_revisada,
                                                           nfa_tar_fecha_revis_aler,
                                                           nfa_tar_comentarios_alerta,
                                                           dd_tra_id,
                                                           cnt_id,
                                                           tar_destinatario,
                                                           tar_tipo_destinatario,
                                                           tar_id_dest,
                                                           per_id,
                                                           rpr_referencia,
                                                           tar_tipo_ent_cod,
                                                           tar_dtype,
                                                           tar_subtipo_cod,
                                                           tar_subtipo_desc,
                                                           plazo,
                                                           entidadinformacion,
                                                           codentidad,
                                                           gestor,
                                                           tiposolicitudsql,
                                                           identidad,
                                                           fcreacionentidad,
                                                           codigosituacion,
                                                           idtareaasociada,
                                                           descripciontareaasociada,
                                                           supervisor,
                                                           diasvencidosql,
                                                           descripcionentidad,
                                                           subtipotarcodtarea,
                                                           fechacreacionentidadformateada,
                                                           descripcionexpediente,
                                                           descripcioncontrato,
                                                           identidadpersona,
                                                           volumenriesgosql,
                                                           tipoitinerarioentidad,
                                                           prorrogafechapropuesta,
                                                           prorrogacausadescripcion,
                                                           codigocontrato,
                                                           contrato
                                                          )
AS
   SELECT v.usu_pendiente, v.usu_espera, v.usu_alerta, v.dd_tge_id_pendiente, v.dd_tge_id_espera, v.dd_tge_id_alerta, v.tar_id, v.cli_id, v.exp_id, v.asu_id, v.tar_tar_id, v.spr_id, v.scx_id,
          v.dd_est_id, v.dd_ein_id, v.dd_sta_id, v.tar_codigo, v.tar_tarea, CASE dd_ein_id
             WHEN 5
                THEN v.nombre_procedimiento
             WHEN 3
                THEN v.nombre_asunto
             ELSE v.tar_descripcion
          END tar_descripcion, v.tar_fecha_fin, v.tar_fecha_ini, v.tar_en_espera, v.tar_alerta, v.tar_tarea_finalizada, v.tar_emisor, v.VERSION, v.usuariocrear, v.fechacrear, v.usuariomodificar,
          v.fechamodificar, v.usuarioborrar, v.fechaborrar, v.borrado, v.prc_id, v.cmb_id, v.set_id, v.tar_fecha_venc, v.obj_id, v.tar_fecha_venc_real, v.dtype, v.nfa_tar_revisada,
          v.nfa_tar_fecha_revis_aler, v.nfa_tar_comentarios_alerta, v.dd_tra_id, v.cnt_id, v.tar_destinatario, v.tar_tipo_destinatario, v.tar_id_dest, v.per_id, v.rpr_referencia, v.dd_ein_codigo,
          v.tar_dtype, v.dd_sta_codigo, v.dd_sta_descripcion, '' plazo                                                                                     -- TODO Sacar plazo para expediente y cliente
                                                                      ,
          CASE v.dd_ein_codigo
             WHEN '3'
                THEN v.entidadinformacion || ' [' || v.asu_id || ']'
             WHEN '5'
                THEN v.entidadinformacion || ' [' || v.prc_id || ']'
             -- TODO poner para el resto de unidades de gestion
          ELSE ''
          END entidadinformacion, CASE v.dd_ein_codigo
             WHEN '3'
                THEN v.asu_id
             WHEN '5'
                THEN v.prc_id
             -- TODO poner para el resto de unidades de gestion
          ELSE -1
          END codentidad, CASE v.dd_ein_codigo
             WHEN '3'
                THEN v.asu_apenom_gestor
             WHEN '5'
                THEN v.asu_apenom_gestor
             -- TODO poner para el resto de unidades de gestion
          ELSE NULL
          END gestor, v.tiposolicitudsql, CASE v.dd_ein_codigo
             WHEN '3'
                THEN v.asu_id
             WHEN '5'
                THEN v.prc_id
             -- TODO poner para el resto de unidades de gestion
          ELSE -1
          END identidad, CASE v.dd_ein_codigo
             WHEN '3'
                THEN v.asu_fechacrear
             WHEN '5'
                THEN v.prc_fechacrear
             -- TODO poner para el resto de unidades de gestion
          ELSE NULL
          END fcreacionentidad, CASE v.dd_ein_codigo
             WHEN '3'
                THEN v.asu_situacion
             -- TODO poner para el resto de unidades de gestion
          ELSE ''
          END codigosituacion, v.tar_tar_id idtareaasociada, v.desc_tar_asociada descripciontareaasociada,
          CASE v.dd_ein_codigo
             WHEN '3'
                THEN v.asu_apenom_supervisor
             WHEN '5'
                THEN v.asu_apenom_supervisor
             -- TODO poner para el resto de unidades de gestion
          ELSE NULL
          END supervisor, CASE
             WHEN v.diasvencidosql <= 0
                THEN NULL
             ELSE v.diasvencidosql
          END diasvencidosql, CASE v.dd_ein_codigo
             WHEN '3'
                THEN v.nombre_asunto
             WHEN '5'
                THEN v.nombre_procedimiento
             -- TODO poner para el resto de unidades de gestion
          ELSE NULL
          END descripcionentidad, v.dd_sta_codigo subtipotarcodtarea,
          CASE v.dd_ein_codigo
             WHEN '3'
                THEN TO_CHAR (v.asu_fechacrear, 'dd/mm/yyyy')
             WHEN '5'
                THEN TO_CHAR (v.prc_fechacrear, 'dd/mm/yyyy')
             -- TODO poner para el resto de unidades de gestion
          ELSE NULL
          END fechacreacionentidadformateada, NULL descripcionexpediente                                                                                                   -- TODO poner para expediente
                                                                        ,
          NULL descripcioncontrato                                                                                                                                           -- TODO poner para contrato
                                  ,
          NULL identidadpersona                                                                                                                               -- TODO poner para objetivo y para cliente
                               ,
          CASE v.dd_ein_codigo
             WHEN '5'
                THEN v.vre_via_prc
             -- TODO poner para el resto de unidades de gestion
          ELSE 0
          END volumenriesgosql, NULL tipoitinerarioentidad                                                                                                       -- TODO sacar para cliente y expediente
                                                          ,
          NULL prorrogafechapropuesta
                                     -- TODO calcular la fecha prorroga propuesta
          , NULL prorrogacausadescripcion
                                         -- TODO calcular la causa de la prorroga
          , NULL codigocontrato                                                                                                                                              -- TODO poner para contrato
                               ,
          NULL contrato                                                                                                                                                                 -- TODO calcular
     FROM (SELECT *
             FROM vtar_tarea_vs_usuario_part1
           UNION ALL
           SELECT *
             FROM vtar_tarea_vs_usuario_part2) v;


CREATE OR REPLACE FORCE VIEW vtar_tarea_vs_tge (dd_tge_id_pendiente,
                                                       dd_tge_id_espera,
                                                       dd_tge_id_alerta,
                                                       dd_tge_id_supervisor,
                                                       tar_id,
                                                       cli_id,
                                                       exp_id,
                                                       asu_id,
                                                       tar_tar_id,
                                                       spr_id,
                                                       scx_id,
                                                       dd_est_id,
                                                       dd_ein_id,
                                                       dd_sta_id,
                                                       tar_codigo,
                                                       tar_tarea,
                                                       tar_descripcion,
                                                       tar_fecha_fin,
                                                       tar_fecha_ini,
                                                       tar_en_espera,
                                                       tar_alerta,
                                                       tar_tarea_finalizada,
                                                       tar_emisor,
                                                       VERSION,
                                                       usuariocrear,
                                                       fechacrear,
                                                       usuariomodificar,
                                                       fechamodificar,
                                                       usuarioborrar,
                                                       fechaborrar,
                                                       borrado,
                                                       prc_id,
                                                       cmb_id,
                                                       set_id,
                                                       tar_fecha_venc,
                                                       obj_id,
                                                       tar_fecha_venc_real,
                                                       dtype,
                                                       nfa_tar_revisada,
                                                       nfa_tar_fecha_revis_aler,
                                                       nfa_tar_comentarios_alerta,
                                                       dd_tra_id,
                                                       cnt_id,
                                                       tar_destinatario,
                                                       tar_tipo_destinatario,
                                                       tar_id_dest,
                                                       per_id,
                                                       rpr_referencia,
                                                       t_referencia
                                                      )
AS
   SELECT   CASE
               WHEN (sta.dd_sta_id = 700 OR sta.dd_sta_id = 701)
                  THEN -1                                                                                                                               -- Quitamos las anotaciones
               WHEN NVL (tap.dd_tge_id, 0) != 0
                  THEN tap.dd_tge_id
               WHEN sta.dd_tge_id IS NULL
                  THEN CASE sta.dd_sta_gestor
                         WHEN 0
                            THEN 3
                         ELSE 2
                      END
               ELSE sta.dd_tge_id
            END dd_tge_id_pendiente
-- tipo de gestor para las tareas en espera
            ,
            CASE
               WHEN (tar.tar_en_espera IS NOT NULL AND tar.tar_en_espera = 1)
                  THEN -2
               ELSE -1
            END dd_tge_id_espera
-- tipo de gestor para las alertas
            , CASE
               WHEN (tar.tar_alerta IS NOT NULL AND tar.tar_alerta = 1)
                  THEN NVL (tap.dd_tsup_id, 3)
               ELSE -1
            END dd_tge_id_alerta, NVL (tap.dd_tsup_id, 3) dd_tge_id_supervisor, tar."TAR_ID", tar."CLI_ID", tar."EXP_ID", tar."ASU_ID", tar."TAR_TAR_ID", tar."SPR_ID", tar."SCX_ID", tar."DD_EST_ID",
            tar."DD_EIN_ID", tar."DD_STA_ID", tar."TAR_CODIGO", tar."TAR_TAREA", tar."TAR_DESCRIPCION", tar."TAR_FECHA_FIN", tar."TAR_FECHA_INI", tar."TAR_EN_ESPERA", tar."TAR_ALERTA",
            tar."TAR_TAREA_FINALIZADA", tar."TAR_EMISOR", tar."VERSION", tar."USUARIOCREAR", tar."FECHACREAR", tar."USUARIOMODIFICAR", tar."FECHAMODIFICAR", tar."USUARIOBORRAR", tar."FECHABORRAR",
            tar."BORRADO", tar."PRC_ID", tar."CMB_ID", tar."SET_ID", tar."TAR_FECHA_VENC", tar."OBJ_ID", tar."TAR_FECHA_VENC_REAL", tar."DTYPE", tar."NFA_TAR_REVISADA", tar."NFA_TAR_FECHA_REVIS_ALER",
            tar."NFA_TAR_COMENTARIOS_ALERTA", tar."DD_TRA_ID", tar."CNT_ID", tar."TAR_DESTINATARIO", tar."TAR_TIPO_DESTINATARIO", tar."TAR_ID_DEST", tar."PER_ID", tar."RPR_REFERENCIA",
            tar."T_REFERENCIA"
       FROM tar_tareas_notificaciones tar JOIN bankmaster.dd_sta_subtipo_tarea_base sta ON tar.dd_sta_id = sta.dd_sta_id
            LEFT JOIN tex_tarea_externa tex ON tar.tar_id = tex.tar_id
            LEFT JOIN tap_tarea_procedimiento tap ON tex.tap_id = tap.tap_id
      WHERE tar.dd_ein_id IN (3, 5)                                                                                                                                     -- solo asuntos y procedimientos
            AND tar.borrado = 0 AND (tar.tar_tarea_finalizada IS NULL OR tar.tar_tarea_finalizada = 0)
   ORDER BY tar.tar_fecha_venc;


