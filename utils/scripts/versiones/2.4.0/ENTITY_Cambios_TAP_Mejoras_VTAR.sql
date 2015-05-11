--
-- Ampliar la tabla TAP_TAREA_PROOCEDIMIENTO para poder indicar el usuario supervisor.
-- 

alter table tap_tarea_procedimiento add dd_tsup_id number(16);

-- TAREA_VS_TGE
-- Cambios 
--      * case para el campo dd_tge_id_espera
--      * case para el campo dd_tge_id_alerta
CREATE OR REPLACE FORCE VIEW vtar_tarea_vs_tge 
AS
   SELECT CASE
             WHEN (sta.dd_sta_id = 700 OR sta.dd_sta_id = 701
                  )
                THEN -1                            -- Quitamos las anotaciones
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
             WHEN (tar.tar_en_espera IS NOT NULL AND tar.tar_en_espera = 1
                  )
                    then -2
             ELSE -1
          END dd_tge_id_espera
-- tipo de gestor para las alertas
          ,
          CASE
             WHEN (tar.tar_alerta IS NOT NULL AND tar.tar_alerta = 1
                  )
                THEN nvl(tap.dd_tsup_id, 3)
             ELSE -1
          END dd_tge_id_alerta,
          tar.*
     FROM tar_tareas_notificaciones tar JOIN linmaster.dd_sta_subtipo_tarea_base sta
          ON tar.dd_sta_id = sta.dd_sta_id
          LEFT JOIN tex_tarea_externa tex ON tar.tar_id = tex.tar_id
          LEFT JOIN tap_tarea_procedimiento tap ON tex.tap_id = tap.tap_id
    WHERE tar.dd_ein_id IN (3, 5)             -- solo asuntos y procedimientos
      AND tar.borrado = 0
      AND (tar.tar_tarea_finalizada IS NULL OR tar.tar_tarea_finalizada = 0);



--
-- VTAR_TAREA_VS_USUARIO
-- Cambios
--      * Nuevo case para el campo usu_espera
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
   SELECT   v.usu_pendientes, v.usu_espera, v.usu_alerta,
            v.dd_tge_id_pendiente, v.dd_tge_id_espera, v.dd_tge_id_alerta,
            v.tar_id, v.cli_id, v.exp_id, v.asu_id, v.tar_tar_id, v.spr_id,
            v.scx_id, v.dd_est_id, v.dd_ein_id, v.dd_sta_id, v.tar_codigo,
            v.tar_tarea,
            CASE dd_ein_id
               WHEN 5
                  THEN v.nombre_procedimiento
               WHEN 3
                  THEN v.nombre_asunto
               ELSE v.tar_descripcion
            END tar_descripcion,
            v.tar_fecha_fin, v.tar_fecha_ini, v.tar_en_espera, v.tar_alerta,
            v.tar_tarea_finalizada, v.tar_emisor, v.VERSION, v.usuariocrear,
            v.fechacrear, v.usuariomodificar, v.fechamodificar,
            v.usuarioborrar, v.fechaborrar, v.borrado, v.prc_id, v.cmb_id,
            v.set_id, v.tar_fecha_venc, v.obj_id, v.tar_fecha_venc_real,
            v.dtype, v.nfa_tar_revisada, v.nfa_tar_fecha_revis_aler,
            v.nfa_tar_comentarios_alerta, v.dd_tra_id, v.cnt_id,
            v.tar_destinatario, v.tar_tipo_destinatario, v.tar_id_dest,
            v.per_id, v.rpr_referencia, v.dd_ein_codigo, v.tar_dtype,
            v.dd_sta_codigo, v.dd_sta_descripcion,
            '' plazo             -- TODO Sacar plazo para expediente y cliente
                    ,
            CASE v.dd_ein_codigo
               WHEN '3'
                  THEN    v.entidadinformacion
                       || ' ['
                       || v.asu_id
                       || ']'
               WHEN '5'
                  THEN v.entidadinformacion || ' [' || v.prc_id || ']'
               -- TODO poner para el resto de unidades de gestion
            ELSE ''
            END entidadinformacion,
            CASE v.dd_ein_codigo
               WHEN '3'
                  THEN v.asu_id
               WHEN '5'
                  THEN v.prc_id
               -- TODO poner para el resto de unidades de gestion
            ELSE -1
            END codentidad,
            CASE v.dd_ein_codigo
               WHEN '3'
                  THEN v.asu_apenom_gestor
               WHEN '5'
                  THEN v.asu_apenom_gestor
               -- TODO poner para el resto de unidades de gestion
            ELSE NULL
            END gestor,
            v.tiposolicitudsql,
            CASE v.dd_ein_codigo
               WHEN '3'
                  THEN v.asu_id
               WHEN '5'
                  THEN v.prc_id
               -- TODO poner para el resto de unidades de gestion
            ELSE -1
            END identidad,
            CASE v.dd_ein_codigo
               WHEN '3'
                  THEN v.asu_fechacrear
               WHEN '5'
                  THEN v.prc_fechacrear
               -- TODO poner para el resto de unidades de gestion
            ELSE NULL
            END fcreacionentidad,
            CASE v.dd_ein_codigo
               WHEN '3'
                  THEN v.asu_situacion
               -- TODO poner para el resto de unidades de gestion
            ELSE ''
            END codigosituacion,
            v.tar_tar_id idtareaasociada,
            v.desc_tar_asociada descripciontareaasociada,
            CASE v.dd_ein_codigo
               WHEN '3'
                  THEN v.asu_apenom_supervisor
               WHEN '5'
                  THEN v.asu_apenom_supervisor
               -- TODO poner para el resto de unidades de gestion
            ELSE NULL
            END supervisor,
            CASE
               WHEN v.diasvencidosql <= 0
                  THEN NULL
               ELSE v.diasvencidosql
            END diasvencidosql,
            CASE v.dd_ein_codigo
               WHEN '3'
                  THEN v.nombre_asunto
               WHEN '5'
                  THEN v.nombre_procedimiento
               -- TODO poner para el resto de unidades de gestion
            ELSE NULL
            END descripcionentidad,
            v.dd_sta_codigo subtipotarcodtarea,
            CASE v.dd_ein_codigo
               WHEN '3'
                  THEN TO_CHAR
                            (v.asu_fechacrear,
                             'dd/mm/yyyy'
                            )
               WHEN '5'
                  THEN TO_CHAR (v.prc_fechacrear, 'dd/mm/yyyy')
               -- TODO poner para el resto de unidades de gestion
            ELSE NULL
            END fechacreacionentidadformateada,
            NULL descripcionexpediente           -- TODO poner para expediente
                                      ,
            NULL descripcioncontrato               -- TODO poner para contrato
                                    ,
            NULL identidadpersona   -- TODO poner para objetivo y para cliente
                                 ,
            CASE v.dd_ein_codigo
               WHEN '5'
                  THEN v.vre_via_prc
               -- TODO poner para el resto de unidades de gestion
            ELSE 0
            END volumenriesgosql,
            NULL tipoitinerarioentidad -- TODO sacar para cliente y expediente
                                      ,
            NULL prorrogafechapropuesta
                                  -- TODO calcular la fecha prorroga propuesta
                                       ,
            NULL prorrogacausadescripcion
                                      -- TODO calcular la causa de la prorroga
                                         ,
            NULL codigocontrato                    -- TODO poner para contrato
                               ,
            NULL contrato                                     -- TODO calcular
       FROM (SELECT DISTINCT ptes.usu_id usu_pendientes,
                             case 
                                 when vtar.dd_tge_id_espera = -2 then nvl(usu.usu_id, -1)
                                 else -1
                             end usu_espera,
                             NVL (alerta.usu_id, -1) usu_alerta, vtar.*,
                             NVL (ptes.asu_nombre,
                                  NVL (espera.asu_nombre, alerta.asu_nombre)
                                 ) nombre_asunto,
                             CASE
                                WHEN tpo.dd_tpo_descripcion IS NOT NULL
                                   THEN    NVL
                                              (ptes.asu_nombre,
                                               NVL (espera.asu_nombre,
                                                    alerta.asu_nombre
                                                   )
                                              )
                                        || '-'
                                        || tpo.dd_tpo_descripcion
                                ELSE NVL (ptes.asu_nombre,
                                          NVL (espera.asu_nombre,
                                               alerta.asu_nombre
                                              )
                                         )
                             END nombre_procedimiento,
                             tpo_ent.dd_ein_codigo, vtar.dtype tar_dtype,
                             sbt_tar.dd_sta_codigo,
                             sbt_tar.dd_sta_descripcion,
                             EXTRACT
                                (DAY FROM (  SYSTIMESTAMP
                                           - (TRUNC (vtar.tar_fecha_venc))
                                          )
                                ) diasvencidosql,
                             (SELECT CASE
                                        WHEN stb.dd_sta_codigo IN
                                               ('5', '6',
                                                '54', '41')
                                           THEN 'Prórroga'
                                        WHEN stb.dd_sta_codigo IN
                                                     ('17')
                                           THEN 'Cancelación Expediente'
                                        WHEN stb.dd_sta_codigo IN
                                                     ('29')
                                           THEN 'Expediente Manual'
                                        WHEN stb.dd_sta_codigo IN
                                               ('16', '28',
                                                '24', '26',
                                                '27', '589',
                                                '590', '15')
                                           THEN 'Comunicación'
                                        ELSE ''
                                     END
                                FROM tar_tareas_notificaciones tn,
                                     &&master_schema..dd_sta_subtipo_tarea_base stb
                               WHERE tn.dd_sta_id = stb.dd_sta_id
                                 AND tn.tar_id = vtar.tar_id)
                                                             tiposolicitudsql,
                             tpo_ent.dd_ein_descripcion entidadinformacion,
                             ptes.fechacrear asu_fechacrear,
                             prc.fechacrear prc_fechacrear,
                             est.dd_est_descripcion asu_situacion,
                             asoc.tar_descripcion desc_tar_asociada,
                             ges.apellido_nombre asu_apenom_gestor,
                             sup.apellido_nombre asu_apenom_supervisor,
                             NVL (vre_prc.vre, 0) vre_via_prc
                        FROM vtar_tarea_vs_tge vtar JOIN vtar_asu_vs_usu ptes
                             ON vtar.asu_id = ptes.asu_id
                           AND vtar.dd_tge_id_pendiente = ptes.dd_tge_id
                             LEFT JOIN vtar_asu_vs_usu espera
                             ON vtar.asu_id = espera.asu_id
                           AND vtar.dd_tge_id_espera = espera.dd_tge_id
                             LEFT JOIN vtar_asu_vs_usu alerta
                             ON vtar.asu_id = alerta.asu_id
                           AND vtar.dd_tge_id_alerta = alerta.dd_tge_id
                             LEFT JOIN prc_procedimientos prc
                             ON vtar.prc_id = prc.prc_id
                             LEFT JOIN dd_tpo_tipo_procedimiento tpo
                             ON prc.dd_tpo_id = tpo.dd_tpo_id
                             LEFT JOIN &&master_schema..dd_ein_entidad_informacion tpo_ent
                             ON vtar.dd_ein_id = tpo_ent.dd_ein_id
                             LEFT JOIN &&master_schema..dd_sta_subtipo_tarea_base sbt_tar
                             ON vtar.dd_sta_id = sbt_tar.dd_sta_id
                             LEFT JOIN &&master_schema..dd_est_estados_itinerarios est
                             ON ptes.dd_est_id = est.dd_est_id
                             LEFT JOIN tar_tareas_notificaciones asoc
                             ON vtar.tar_tar_id = asoc.tar_id
                             LEFT JOIN vtar_asunto_gestor ges
                             ON ptes.asu_id = ges.asu_id
                             LEFT JOIN vtar_asunto_supervisor sup
                             ON ptes.asu_id = sup.asu_id
                             LEFT JOIN vtar_tar_vre_via_prc vre_prc
                             ON vtar.tar_id = vre_prc.tar_id
                             LEFT JOIN &&master_schema..usu_usuarios usu
                             ON vtar.tar_emisor = usu.usu_username
             UNION
             SELECT t.tar_id_dest usu_pendientes, -1 usu_espra, -1 usu_alerta,
                    t.*, asu.asu_nombre nombre_asunto,
                    CASE
                       WHEN tpo.dd_tpo_descripcion IS NOT NULL
                          THEN    asu.asu_nombre
                               || '-'
                               || tpo.dd_tpo_descripcion
                       ELSE asu.asu_nombre
                    END nombre_procedimiento,
                    tpo_ent.dd_ein_codigo, t.dtype tar_dtype,
                    sbt_tar.dd_sta_codigo, sbt_tar.dd_sta_descripcion,
                    EXTRACT
                           (DAY FROM (  SYSTIMESTAMP
                                      - (TRUNC (t.tar_fecha_venc))
                                     )
                           ) diasvencidosql,
                    (SELECT CASE
                               WHEN stb.dd_sta_codigo IN
                                      ('5', '6', '54', '41')
                                  THEN 'Prórroga'
                               WHEN stb.dd_sta_codigo IN
                                                     ('17')
                                  THEN 'Cancelación Expediente'
                               WHEN stb.dd_sta_codigo IN
                                                     ('29')
                                  THEN 'Expediente Manual'
                               WHEN stb.dd_sta_codigo IN
                                      ('16', '28', '24',
                                       '26', '27', '589',
                                       '590', '15')
                                  THEN 'Comunicación'
                               ELSE ''
                            END
                       FROM tar_tareas_notificaciones tn,
                            &&master_schema..dd_sta_subtipo_tarea_base stb
                      WHERE tn.dd_sta_id = stb.dd_sta_id
                        AND tn.tar_id = t.tar_id) tiposolicitudsql,
                    tpo_ent.dd_ein_descripcion entidadinformacion,
                    asu.fechacrear asu_fechacrear,
                    prc.fechacrear prc_fechacrear,
                    est.dd_est_descripcion asu_situacion,
                    asoc.tar_descripcion desc_tar_asociada,
                    ges.apellido_nombre asu_apenom_gestor,
                    sup.apellido_nombre asu_apenom_supervisor,
                    NVL (vre_prc.vre, 0) vre_via_prc
               FROM vtar_tarea_vs_tge t LEFT JOIN asu_asuntos asu
                    ON t.asu_id = asu.asu_id
                    LEFT JOIN prc_procedimientos prc ON t.prc_id = prc.prc_id
                    LEFT JOIN dd_tpo_tipo_procedimiento tpo
                    ON prc.dd_tpo_id = tpo.dd_tpo_id
                    LEFT JOIN &&master_schema..dd_ein_entidad_informacion tpo_ent
                    ON t.dd_ein_id = tpo_ent.dd_ein_id
                    LEFT JOIN &&master_schema..dd_sta_subtipo_tarea_base sbt_tar
                    ON t.dd_sta_id = sbt_tar.dd_sta_id
                    LEFT JOIN &&master_schema..dd_est_estados_itinerarios est
                    ON asu.dd_est_id = est.dd_est_id
                    LEFT JOIN tar_tareas_notificaciones asoc
                    ON t.tar_tar_id = asoc.tar_id
                    LEFT JOIN vtar_asunto_gestor ges ON asu.asu_id =
                                                                    ges.asu_id
                    LEFT JOIN vtar_asunto_supervisor sup
                    ON asu.asu_id = sup.asu_id
                    LEFT JOIN vtar_tar_vre_via_prc vre_prc
                    ON t.tar_id = vre_prc.tar_id
              WHERE t.dd_sta_id IN
                       (700, 701) -- añadimos aqui las tareas individualizadas
                                 ) v
   ORDER BY tar_fecha_venc;      
          
--
-- Opcional, puede ser que esta vista no esté materializada.
--          
exec DBMS_SNAPSHOT.REFRESH( 'VTAR_ASU_VS_USU');         