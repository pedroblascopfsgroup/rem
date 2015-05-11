--
-- Optimización de los buzones de tareas
-- Autor: Bruno
-- Versión 1.0
-- Fecha ult. modificación: 04/07/2013
--


--
-- README
-------------------------------------------
--  Al ejecutar este script se solicitará que se informe la variable master_schema con el nombre de la BBDD master.
--

prompt Paso 1. Regenerar la vista VTAR_TAREA_VS_TGE

CREATE OR REPLACE FORCE VIEW vtar_tarea_vs_tge 
AS
   SELECT   CASE
               WHEN (sta.dd_sta_id = 700 OR sta.dd_sta_id = 701
                    )
                  THEN -1                          -- Quitamos las anotaciones
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
                  THEN -2
               ELSE -1
            END dd_tge_id_espera
-- tipo de gestor para las alertas
            ,
            CASE
               WHEN (tar.tar_alerta IS NOT NULL AND tar.tar_alerta = 1
                    )
                  THEN NVL (tap.dd_tsup_id, 3)
               ELSE -1
            END dd_tge_id_alerta,
            NVL (tap.dd_tsup_id, 3) dd_tge_id_supervisor, tar.*
       FROM tar_tareas_notificaciones tar 
            JOIN &&master_schema..dd_sta_subtipo_tarea_base sta  ON tar.dd_sta_id = sta.dd_sta_id
            LEFT JOIN tex_tarea_externa tex ON tar.tar_id = tex.tar_id
            LEFT JOIN tap_tarea_procedimiento tap ON tex.tap_id = tap.tap_id
      WHERE tar.dd_ein_id IN (3, 5)           -- solo asuntos y procedimientos
        AND tar.borrado = 0
        AND (tar.tar_tarea_finalizada IS NULL OR tar.tar_tarea_finalizada = 0
            )
   ORDER BY tar.tar_fecha_venc;
   
prompt Paso 2. Regenerar la vista VTAR_ASU_VS_USU   
   
DROP MATERIALIZED VIEW VTAR_ASU_VS_USU;

CREATE MATERIALIZED VIEW VTAR_ASU_VS_USU
AS 
/* Formatted on 2013/07/04 16:28 (Formatter Plus v4.8.8) */
SELECT DISTINCT CASE usu.usu_grupo
                   WHEN 0
                      THEN usu.usu_id
                   ELSE gru.usu_id_usuario
                END usu_id,
                usd.des_id, ges.dd_tge_id, usd.usu_id usu_id_original, asu.*
           FROM asu_asuntos asu
                JOIN (SELECT asu_id, usd_id, 4 dd_tge_id FROM asu_asuntos WHERE usd_id IS NOT NULL -- procuradores
                        UNION
                        SELECT asu_id, usd_id, dd_tge_id FROM gaa_gestor_adicional_asunto       -- resto de gestores
                      ) ges ON asu.asu_id = ges.asu_id
                JOIN usd_usuarios_despachos usd ON ges.usd_id = usd.usd_id
                JOIN &&master_schema..usu_usuarios usu ON usd.usu_id = usu.usu_id
                LEFT JOIN &&master_schema..gru_grupos_usuarios gru ON usd.usu_id = gru.usu_id_grupo AND gru.borrado = 0;

prompt Paso 3. Regenerar la vista VTAR_TAREA_VS_RESPONSALBES

CREATE OR REPLACE FORCE VIEW vtar_tarea_vs_responsables
AS
   SELECT tar_id, dtype, tar_fecha_venc, prc_id, dd_ein_id, dd_sta_id,
          tar_tar_id, dd_est_id, asu_id, asu_nombre, fechacrear_asu,
          rpr_referencia, per_id, tar_id_dest, tar_tipo_destinatario,
          tar_destinatario, cnt_id, dd_tra_id, nfa_tar_comentarios_alerta,
          nfa_tar_fecha_revis_aler, nfa_tar_revisada, tar_fecha_venc_real,
          obj_id, set_id, cmb_id, borrado, fechaborrar, usuarioborrar,
          fechacrear, usuariocrear, fechamodificar, usuariomodificar, VERSION,
          tar_emisor, tar_tarea_finalizada, tar_alerta, tar_en_espera,
          tar_fecha_ini, tar_fecha_fin, tar_descripcion, tar_tarea,
          tar_codigo, scx_id, spr_id, exp_id, cli_id, dd_tge_id_alerta,
          dd_tge_id_espera, dd_tge_id_pendiente, dd_tge_id_supervisor,
          NVL (usu_pendiente, -1) usu_pendiente,
          NVL (usu_alerta, -1) usu_alerta, NVL (usu_espera, 1) usu_espera,
          NVL (usu_id_original, -1) usu_id_original,
          NVL (usu_supervisor, -1) usu_supervisor
     FROM (
        SELECT vtar.*, vusu.asu_nombre, vusu.fechacrear fechacrear_asu,
                  DECODE (vusu.dd_tge_id,
                          vtar.dd_tge_id_pendiente, vusu.usu_id
                         ) usu_pendiente,
                  DECODE (vusu.dd_tge_id,
                          vtar.dd_tge_id_espera, vusu.usu_id
                         ) usu_espera,
                  DECODE (vusu.dd_tge_id,
                          vtar.dd_tge_id_alerta, vusu.usu_id
                         ) usu_alerta,
                  DECODE (vusu.dd_tge_id,
                          vtar.dd_tge_id_supervisor, vusu.usu_id
                         ) usu_supervisor,
                  DECODE (vusu.dd_tge_id,
                          vtar.dd_tge_id_pendiente, vusu.usu_id_original
                         ) usu_id_original
             FROM vtar_tarea_vs_tge vtar 
                JOIN vtar_asu_vs_usu vusu ON vtar.asu_id = vusu.asu_id
            WHERE vtar.tar_fecha_venc <= TRUNC (SYSDATE + 90))
    WHERE usu_pendiente > 0;

prompt Paso 4. Regenerar la vista VTAR_NOMBRES_USUARIOS

CREATE OR REPLACE FORCE VIEW vtar_nombres_usuarios 
AS
   SELECT usu.usu_id,
          CASE
             WHEN usu.usu_apellido1 IS NULL
             AND usu.usu_apellido2 IS NULL
                THEN usu.usu_nombre
             WHEN usu.usu_apellido2 IS NULL
                THEN usu.usu_apellido1 || ', ' || usu.usu_nombre
             WHEN usu.usu_apellido1 IS NULL
                THEN usu.usu_apellido2 || ', ' || usu.usu_nombre
             ELSE    usu.usu_apellido1
                  || ' '
                  || usu.usu_apellido2
                  || ', '
                  || usu.usu_nombre
          END apellido_nombre
     FROM &&master_schema..usu_usuarios usu;


prompt Paso 5. Regenerar la vista VTAR_ASUNTO_GESTOR

DROP MATERIALIZED VIEW VTAR_ASUNTO_GESTOR;

CREATE MATERIALIZED VIEW VTAR_ASUNTO_GESTOR
AS 
SELECT DISTINCT asu.asu_id, asu.dd_tge_id,
                CASE
                   WHEN usu.usu_apellido1 IS NULL
                   AND usu.usu_apellido2 IS NULL
                      THEN usu.usu_nombre
                   WHEN usu.usu_apellido2 IS NULL
                      THEN usu.usu_apellido1 || ', ' || usu.usu_nombre
                   WHEN usu.usu_apellido1 IS NULL
                      THEN usu.usu_apellido2 || ', ' || usu.usu_nombre
                   ELSE    usu.usu_apellido1
                        || ' '
                        || usu.usu_apellido2
                        || ', '
                        || usu.usu_nombre
                END apellido_nombre,
                usu.*
           FROM vtar_asu_vs_usu asu 
            JOIN &&master_schema..usu_usuarios usu ON asu.usu_id_original = usu.usu_id;
            
            
prompt Paso 6. Regenerar la vista VTAR_TAR_VRE_VIA_PRC            

CREATE OR REPLACE FORCE VIEW vtar_tar_vre_via_prc (tar_id, vre)
AS
   SELECT t.tar_id, NVL (p.prc_saldo_recuperacion, 0) vre
     FROM prc_procedimientos p, tar_tareas_notificaciones t
    WHERE p.prc_id = t.prc_id;

prompt Paso 7. Regenerar la vista VTAR_TAREA_VS_USUARIO_PART1

CREATE OR REPLACE FORCE VIEW vtar_tarea_vs_usuario_part1 
AS
   SELECT vtar.usu_pendiente, NVL (vtar.usu_espera, -1) usu_espera,
          NVL (vtar.usu_alerta, -1) usu_alerta, vtar.asu_nombre nombre_asunto,
          CASE
             WHEN tpo.dd_tpo_descripcion IS NOT NULL
                THEN    vtar.asu_nombre
                     || '-'
                     || tpo.dd_tpo_descripcion
             ELSE vtar.asu_nombre
          END nombre_procedimiento,
          tpo_ent.dd_ein_codigo, vtar.dtype tar_dtype, sbt_tar.dd_sta_codigo,
          sbt_tar.dd_sta_descripcion,
          EXTRACT (DAY FROM (SYSTIMESTAMP - (TRUNC (vtar.tar_fecha_venc)))
                  ) diasvencidosql,
          (SELECT CASE
                     WHEN stb.dd_sta_codigo IN
                                     ('5', '6', '54', '41')
                        THEN 'Prórroga'
                     WHEN stb.dd_sta_codigo IN ('17')
                        THEN 'Cancelación Expediente'
                     WHEN stb.dd_sta_codigo IN ('29')
                        THEN 'Expediente Manual'
                     WHEN stb.dd_sta_codigo IN
                            ('16', '28', '24', '26', '27',
                             '589', '590', '15')
                        THEN 'Comunicación'
                     ELSE ''
                  END
             FROM tar_tareas_notificaciones tn,
                  &&master_schema..dd_sta_subtipo_tarea_base stb
            WHERE tn.dd_sta_id = stb.dd_sta_id AND tn.tar_id = vtar.tar_id)
                                                             tiposolicitudsql,
          tpo_ent.dd_ein_descripcion entidadinformacion,
          vtar.fechacrear_asu asu_fechacrear, prc.fechacrear prc_fechacrear,
          est.dd_est_descripcion asu_situacion,
          asoc.tar_descripcion desc_tar_asociada,
          ges.apellido_nombre asu_apenom_gestor,
          sup.apellido_nombre asu_apenom_supervisor,
          NVL (vre_prc.vre, 0) vre_via_prc, vtar.tar_tar_id, vtar.prc_id,
          vtar.asu_id, vtar.rpr_referencia, vtar.per_id, vtar.tar_id_dest,
          vtar.tar_tipo_destinatario, vtar.tar_destinatario, vtar.cnt_id,
          vtar.dd_tra_id, vtar.nfa_tar_comentarios_alerta,
          vtar.nfa_tar_fecha_revis_aler, vtar.nfa_tar_revisada, vtar.dtype,
          vtar.tar_fecha_venc_real, vtar.obj_id, vtar.tar_fecha_venc,
          vtar.set_id, vtar.cmb_id, vtar.borrado, vtar.fechaborrar,
          vtar.usuarioborrar, vtar.fechamodificar, vtar.usuariomodificar,
          vtar.fechacrear, vtar.usuariocrear, vtar.VERSION, vtar.tar_emisor,
          vtar.tar_tarea_finalizada, vtar.tar_alerta, vtar.tar_en_espera,
          vtar.tar_fecha_ini, vtar.tar_fecha_fin, vtar.tar_descripcion,
          vtar.dd_ein_id, vtar.tar_tarea, vtar.tar_codigo, vtar.dd_sta_id,
          vtar.dd_est_id, vtar.scx_id, vtar.spr_id, vtar.exp_id, vtar.cli_id,
          vtar.tar_id, vtar.dd_tge_id_alerta, vtar.dd_tge_id_espera,
          vtar.dd_tge_id_pendiente
     FROM vtar_tarea_vs_responsables vtar 
          LEFT JOIN prc_procedimientos prc  ON vtar.prc_id = prc.prc_id
          LEFT JOIN dd_tpo_tipo_procedimiento tpo  ON prc.dd_tpo_id = tpo.dd_tpo_id
          LEFT JOIN &&master_schema..dd_ein_entidad_informacion tpo_ent ON vtar.dd_ein_id = tpo_ent.dd_ein_id
          LEFT JOIN &&master_schema..dd_sta_subtipo_tarea_base sbt_tar ON vtar.dd_sta_id = sbt_tar.dd_sta_id
          LEFT JOIN &&master_schema..dd_est_estados_itinerarios est ON vtar.dd_est_id = est.dd_est_id
          LEFT JOIN tar_tareas_notificaciones asoc ON vtar.tar_tar_id = asoc.tar_id
          LEFT JOIN vtar_nombres_usuarios ges ON vtar.usu_pendiente =  ges.usu_id
          LEFT JOIN vtar_nombres_usuarios sup ON vtar.usu_supervisor = sup.usu_id
          LEFT JOIN vtar_tar_vre_via_prc vre_prc ON vtar.tar_id = vre_prc.tar_id ;

prompt Paso 8. Regenerar la vista VTAR_TAREA_VS_USUARIO_PART2

CREATE OR REPLACE FORCE VIEW vtar_tarea_vs_usuario_part2 
AS
   SELECT t.tar_id_dest usu_pendiente, -1 usu_espra, -1 usu_alerta,
          asu.asu_nombre nombre_asunto,
          CASE
             WHEN tpo.dd_tpo_descripcion IS NOT NULL
                THEN    asu.asu_nombre
                     || '-'
                     || tpo.dd_tpo_descripcion
             ELSE asu.asu_nombre
          END nombre_procedimiento,
          tpo_ent.dd_ein_codigo, t.dtype tar_dtype, sbt_tar.dd_sta_codigo,
          sbt_tar.dd_sta_descripcion,
          EXTRACT (DAY FROM (SYSTIMESTAMP - (TRUNC (t.tar_fecha_venc)))
                  ) diasvencidosql,
          (SELECT CASE
                     WHEN stb.dd_sta_codigo IN
                                     ('5', '6', '54', '41')
                        THEN 'Prórroga'
                     WHEN stb.dd_sta_codigo IN ('17')
                        THEN 'Cancelación Expediente'
                     WHEN stb.dd_sta_codigo IN ('29')
                        THEN 'Expediente Manual'
                     WHEN stb.dd_sta_codigo IN
                            ('16', '28', '24', '26', '27',
                             '589', '590', '15')
                        THEN 'Comunicación'
                     ELSE ''
                  END
             FROM tar_tareas_notificaciones tn,
                  &&master_schema..dd_sta_subtipo_tarea_base stb
            WHERE tn.dd_sta_id = stb.dd_sta_id AND tn.tar_id = t.tar_id)
                                                             tiposolicitudsql,
          tpo_ent.dd_ein_descripcion entidadinformacion,
          asu.fechacrear asu_fechacrear, prc.fechacrear prc_fechacrear,
          est.dd_est_descripcion asu_situacion,
          asoc.tar_descripcion desc_tar_asociada,
          ges.apellido_nombre asu_apenom_gestor,
          sup.apellido_nombre asu_apenom_supervisor,
          NVL (vre_prc.vre, 0) vre_via_prc, t.tar_tar_id, t.prc_id, t.asu_id,
          t.rpr_referencia, t.per_id, t.tar_id_dest, t.tar_tipo_destinatario,
          t.tar_destinatario, t.cnt_id, t.dd_tra_id,
          t.nfa_tar_comentarios_alerta, t.nfa_tar_fecha_revis_aler,
          t.nfa_tar_revisada, t.dtype, t.tar_fecha_venc_real, t.obj_id,
          t.tar_fecha_venc, t.set_id, t.cmb_id, t.borrado, t.fechaborrar,
          t.usuarioborrar, t.fechamodificar, t.usuariomodificar, t.fechacrear,
          t.usuariocrear, t.VERSION, t.tar_emisor, t.tar_tarea_finalizada,
          t.tar_alerta, t.tar_en_espera, t.tar_fecha_ini, t.tar_fecha_fin,
          t.tar_descripcion, t.dd_ein_id, t.tar_tarea, t.tar_codigo,
          t.dd_sta_id, t.dd_est_id, t.scx_id, t.spr_id, t.exp_id, t.cli_id,
          t.tar_id, t.dd_tge_id_alerta, t.dd_tge_id_espera,
          t.dd_tge_id_pendiente
     FROM vtar_tarea_vs_tge t 
          lEFT JOIN asu_asuntos asu ON t.asu_id =asu.asu_id
          LEFT JOIN prc_procedimientos prc ON t.prc_id = prc.prc_id
          LEFT JOIN dd_tpo_tipo_procedimiento tpo ON prc.dd_tpo_id = tpo.dd_tpo_id
          LEFT JOIN &&master_schema..dd_ein_entidad_informacion tpo_ent  ON t.dd_ein_id = tpo_ent.dd_ein_id
          LEFT JOIN &&master_schema..dd_sta_subtipo_tarea_base sbt_tar ON t.dd_sta_id = sbt_tar.dd_sta_id
          LEFT JOIN &&master_schema..dd_est_estados_itinerarios est ON asu.dd_est_id = est.dd_est_id
          LEFT JOIN tar_tareas_notificaciones asoc ON t.tar_tar_id = asoc.tar_id
          LEFT JOIN vtar_asunto_gestor sup  ON asu.asu_id = sup.asu_id AND t.dd_tge_id_supervisor = sup.dd_tge_id
          LEFT JOIN vtar_asunto_gestor ges ON asu.asu_id = ges.asu_id AND t.dd_tge_id_pendiente = ges.dd_tge_id
          LEFT JOIN vtar_tar_vre_via_prc vre_prc ON t.tar_id = vre_prc.tar_id
    WHERE t.dd_sta_id IN (700, 701);

prompt Paso 9. Regenerar la vista VTAR_TAREA_VS_USUARIO

CREATE OR REPLACE FORCE VIEW vtar_tarea_vs_usuario
AS
   SELECT v.usu_pendiente usu_pendientes, v.usu_espera, v.usu_alerta, v.dd_tge_id_pendiente,
          v.dd_tge_id_espera, v.dd_tge_id_alerta, v.tar_id, v.cli_id,
          v.exp_id, v.asu_id, v.tar_tar_id, v.spr_id, v.scx_id, v.dd_est_id,
          v.dd_ein_id, v.dd_sta_id, v.tar_codigo, v.tar_tarea,
          CASE dd_ein_id
             WHEN 5
                THEN v.nombre_procedimiento
             WHEN 3
                THEN v.nombre_asunto
             ELSE v.tar_descripcion
          END tar_descripcion,
          v.tar_fecha_fin, v.tar_fecha_ini, v.tar_en_espera, v.tar_alerta,
          v.tar_tarea_finalizada, v.tar_emisor, v.VERSION, v.usuariocrear,
          v.fechacrear, v.usuariomodificar, v.fechamodificar, v.usuarioborrar,
          v.fechaborrar, v.borrado, v.prc_id, v.cmb_id, v.set_id,
          v.tar_fecha_venc, v.obj_id, v.tar_fecha_venc_real, v.dtype,
          v.nfa_tar_revisada, v.nfa_tar_fecha_revis_aler,
          v.nfa_tar_comentarios_alerta, v.dd_tra_id, v.cnt_id,
          v.tar_destinatario, v.tar_tipo_destinatario, v.tar_id_dest,
          v.per_id, v.rpr_referencia, v.dd_ein_codigo tar_tipo_ent_cod, v.tar_dtype,
          v.dd_sta_codigo tar_subtipo_cod, v.dd_sta_descripcion tar_subtipo_desc, 
          '' plazo               -- TODO Sacar plazo para expediente y cliente
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
          NULL descripcionexpediente             -- TODO poner para expediente
                                    ,
          NULL descripcioncontrato                 -- TODO poner para contrato
                                  ,
          NULL identidadpersona     -- TODO poner para objetivo y para cliente
                               ,
          CASE v.dd_ein_codigo
             WHEN '5'
                THEN v.vre_via_prc
             -- TODO poner para el resto de unidades de gestion
          ELSE 0
          END volumenriesgosql,
          NULL tipoitinerarioentidad   -- TODO sacar para cliente y expediente
                                    ,
          NULL prorrogafechapropuesta
                                     -- TODO calcular la fecha prorroga propuesta
          , NULL prorrogacausadescripcion
                                         -- TODO calcular la causa de la prorroga
          ,
          NULL codigocontrato                      -- TODO poner para contrato
                             ,
          NULL contrato                                       -- TODO calcular
     FROM (SELECT *
             FROM vtar_tarea_vs_usuario_part1
           UNION ALL
           SELECT *
             FROM vtar_tarea_vs_usuario_part2) v;

prompt Paso 10. Crear indices

CREATE INDEX IDX_VTAR_ASU_VS_USU_ASU_ID ON VTAR_ASU_VS_USU (ASU_ID);

-- Puede que ya exista.
CREATE UNIQUE INDEX UK_DD_IFC_CODIGO ON EXT_DD_IFC_INFO_CONTRATO (DD_IFC_CODIGO);

-- Puede que ya exista.
CREATE INDEX IDX_TEX_TAR_ID ON TEX_TAREA_EXTERNA(TAR_ID)