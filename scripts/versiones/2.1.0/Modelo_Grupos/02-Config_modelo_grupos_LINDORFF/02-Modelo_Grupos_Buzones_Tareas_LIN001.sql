--
-- Vistas par obtener el buzon de tareas
--

-- TAREA_VS_TGE
-- Tarea vs Tipo de gestos
-- Nos dice quien tiene que hacer una determinada tarea
CREATE OR REPLACE FORCE VIEW vtar_tarea_vs_tge (dd_tge_id_pendiente,
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
                                                        rpr_referencia
                                                       )
AS
   SELECT CASE
             WHEN (sta.dd_sta_id = 700 OR sta.dd_sta_id = 701
                  )
                THEN -1                            -- Quitamos las anotaciones
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
                THEN CASE sta.dd_tge_id
                       WHEN 3
                          THEN 2
                           -- la tarea del supervisor en espera para el gestor
                       WHEN 2
                          THEN 3
                           -- la tarea del gestor en espera para el supervisor
                       ELSE -1
                    END
             ELSE -1
          END dd_tge_id_espera
-- tipo de gestor para las alertas
          ,
          CASE
             WHEN (tar.tar_alerta IS NOT NULL AND tar.tar_alerta = 1
                  )
                THEN 3                    -- las alertas siempre al supervisor
             ELSE -1
          END dd_tge_id_alerta,
          tar.*
     FROM tar_tareas_notificaciones tar JOIN linmaster.dd_sta_subtipo_tarea_base sta
          ON tar.dd_sta_id = sta.dd_sta_id
    WHERE tar.dd_ein_id IN (3, 5)             -- solo asuntos y procedimientos
      AND tar.borrado = 0
      AND (tar.tar_tarea_finalizada IS NULL OR tar.tar_tarea_finalizada = 0
          );   

-- ASUNTO_VS_USU
-- Asunto vs Usuario
-- Nos cruza asuntos con usuarios y nos dice el tipo de relacion que tienen
drop materialized view vtar_asu_vs_usu;

--drop view vtar_asu_vs_usu;

CREATE MATERIALIZED VIEW VTAR_ASU_VS_USU 
BUILD IMMEDIATE
REFRESH COMPLETE
START WITH trunc(sysdate)
NEXT SYSDATE + 1/1152             
WITH PRIMARY KEY    
AS
SELECT distinct
    case usu.usu_grupo
        when 0 then usu.usu_id
        else gru.usu_id_usuario 
    end usu_id
    , usd.des_id, ges.dd_tge_id, usd.usu_id usu_id_original, asu.*
  FROM asu_asuntos asu
       JOIN
       (SELECT asu_id, usd_id, 4 dd_tge_id
          FROM asu_asuntos
         WHERE usd_id IS NOT NULL                              -- procuradores
        UNION
        SELECT asu_id, usd_id, dd_tge_id
          FROM gaa_gestor_adicional_asunto                -- resto de gestores
                                          ) ges ON asu.asu_id = ges.asu_id
       JOIN usd_usuarios_despachos usd ON ges.usd_id = usd.usd_id
       join linmaster.usu_usuarios usu on usd.usu_id = usu.usu_id
       left join linmaster.gru_grupos_usuarios gru on usd.usu_id = gru.usu_id_grupo and gru.borrado = 0;

-- ASUNTO_GESTOR
-- Esta vista nos saca los gestores del asunto
create or replace view vtar_asunto_gestor
as 
select distinct asu.asu_id
    , case
            when usu.usu_apellido1 is null and usu.usu_apellido2 is null then usu.usu_nombre
            when usu.usu_apellido2 is null then usu.usu_apellido1||', '|| usu.usu_nombre
            when usu.usu_apellido1 is null then usu.usu_apellido2||', '|| usu.usu_nombre
            else usu.usu_apellido1||' ' ||usu.usu_apellido2||', '|| usu.usu_nombre
        end apellido_nombre
    , usu.*
from vtar_asu_vs_usu asu
    join linmaster.usu_usuarios usu on asu.usu_id_original = usu.usu_id
where asu.dd_tge_id = 2;


-- ASUNTO_SUPERVISOR
-- Esta vista nos saca los supervisores del asunto
create or replace view vtar_asunto_supervisor
as 
select distinct asu.asu_id
    , case
            when usu.usu_apellido1 is null and usu.usu_apellido2 is null then usu.usu_nombre
            when usu.usu_apellido2 is null then usu.usu_apellido1||', '|| usu.usu_nombre
            when usu.usu_apellido1 is null then usu.usu_apellido2||', '|| usu.usu_nombre
            else usu.usu_apellido1||' ' ||usu.usu_apellido2||', '|| usu.usu_nombre
        end apellido_nombre
    , usu.*
from vtar_asu_vs_usu asu
    join linmaster.usu_usuarios usu on asu.usu_id_original = usu.usu_id
where asu.dd_tge_id = 3;

--
-- CALCULO DEL VRE PARA TAREAS
--
create or replace view VTAR_TAR_VRE_VIA_PRC as
select t.tar_id, NVL(p.PRC_SALDO_RECUPERACION,0) vre
			from prc_procedimientos p, TAR_TAREAS_NOTIFICACIONES t
	where p.prc_id = t.prc_id ;

-- TAR vs USU
-- Tarea vs Usuario (Responsable)
-- Nos cruza una determinada tarea pendiente con el usuario que debe hacerla
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
            v.dd_sta_codigo, v.dd_sta_descripcion
            ,''  plazo -- TODO Sacar plazo para expediente y cliente
            , case v.dd_ein_codigo
                when '3' then v.entidadinformacion||' ['||v.asu_id||']'
                when '5' then v.entidadinformacion||' ['||v.prc_id||']'
                -- TODO poner para el resto de unidades de gestion
                else ''
            end entidadinformacion
            , case v.dd_ein_codigo
                when '3' then v.asu_id
                when '5' then v.prc_id
                -- TODO poner para el resto de unidades de gestion
                else -1
            end codentidad
            , case v.dd_ein_codigo
                when '3' then v.asu_apenom_gestor
                when '5' then v.asu_apenom_gestor
                -- TODO poner para el resto de unidades de gestion
                else null
            end gestor,
            v.tiposolicitudsql
            , case v.dd_ein_codigo
                when '3' then v.asu_id
                when '5' then v.prc_id
                -- TODO poner para el resto de unidades de gestion
                else -1
            end identidad
            ,case v.dd_ein_codigo
                when '3' then v.asu_fechacrear
                when '5' then v.prc_fechacrear
                -- TODO poner para el resto de unidades de gestion
                else null
            end fcreacionentidad
            , case v.dd_ein_codigo
                when '3' then v.asu_situacion
                -- TODO poner para el resto de unidades de gestion
                else ''
            end codigosituacion
            , v.tar_tar_id idtareaasociada,
            v.desc_tar_asociada descripciontareaasociada
            ,case v.dd_ein_codigo
                when '3' then v.asu_apenom_supervisor
                when '5' then v.asu_apenom_supervisor
                -- TODO poner para el resto de unidades de gestion
                else null
            end  supervisor,
            case 
               when v.diasvencidosql<=0 then null
               else v.diasvencidosql
               end diasvencidosql
            , case v.dd_ein_codigo
                when '3' then v.nombre_asunto
                when '5' then v.nombre_procedimiento
                -- TODO poner para el resto de unidades de gestion
                else null
            end descripcionentidad,
            v.dd_sta_codigo subtipotarcodtarea
            , case v.dd_ein_codigo
                when '3' then to_char(v.asu_fechacrear,'dd/mm/yyyy')
                when '5' then to_char(v.prc_fechacrear,'dd/mm/yyyy')
                -- TODO poner para el resto de unidades de gestion
                else null
            end fechacreacionentidadformateada
            , null descripcionexpediente -- TODO poner para expediente
            , null descripcioncontrato -- TODO poner para contrato
            , null identidadpersona -- TODO poner para objetivo y para cliente
            , case v.dd_ein_codigo
                when '5' then v.vre_via_prc
                -- TODO poner para el resto de unidades de gestion
                else 0
            end volumenriesgosql
            , null tipoitinerarioentidad -- TODO sacar para cliente y expediente
            , null prorrogafechapropuesta -- TODO calcular la fecha prorroga propuesta
            , null prorrogacausadescripcion -- TODO calcular la causa de la prorroga
            , null codigocontrato -- TODO poner para contrato
            , null contrato -- TODO calcular
       FROM (              
       SELECT DISTINCT ptes.usu_id usu_pendientes,
                             NVL (espera.usu_id, -1) usu_espera,
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
                             EXTRACT (DAY FROM (  SYSTIMESTAMP
                                                         - (trunc(vtar.tar_fecha_venc)
                                                           )
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
                                     linmaster.dd_sta_subtipo_tarea_base stb
                               WHERE tn.dd_sta_id = stb.dd_sta_id
                                 AND tn.tar_id = vtar.tar_id)
                                                             tiposolicitudsql
                               , tpo_ent.DD_EIN_DESCRIPCION entidadinformacion      
                               , ptes.fechacrear asu_fechacrear
                               , prc.fechacrear prc_fechacrear 
                               , est.dd_est_descripcion asu_situacion  
                               , asoc.tar_descripcion desc_tar_asociada
                               , ges.apellido_nombre asu_apenom_gestor   
                               , sup.apellido_nombre asu_apenom_supervisor
                               , nvl(vre_prc.vre,0) vre_via_prc                  
                        FROM vtar_tarea_vs_tge vtar 
                             JOIN vtar_asu_vs_usu ptes ON vtar.asu_id = ptes.asu_id AND vtar.dd_tge_id_pendiente = ptes.dd_tge_id
                             LEFT JOIN vtar_asu_vs_usu espera ON vtar.asu_id = espera.asu_id AND vtar.dd_tge_id_espera = espera.dd_tge_id
                             LEFT JOIN vtar_asu_vs_usu alerta ON vtar.asu_id = alerta.asu_id AND vtar.dd_tge_id_alerta = alerta.dd_tge_id
                             LEFT JOIN prc_procedimientos prc ON vtar.prc_id = prc.prc_id
                             LEFT JOIN dd_tpo_tipo_procedimiento tpo ON prc.dd_tpo_id = tpo.dd_tpo_id
                             LEFT JOIN linmaster.dd_ein_entidad_informacion tpo_ent ON vtar.dd_ein_id = tpo_ent.dd_ein_id
                             LEFT JOIN linmaster.dd_sta_subtipo_tarea_base sbt_tar ON vtar.dd_sta_id = sbt_tar.dd_sta_id
                             LEFT JOIN linmaster.dd_est_estados_itinerarios est on ptes.dd_est_id = est.dd_est_id
                             left join tar_tareas_notificaciones asoc on vtar.tar_tar_id = asoc.tar_id
                             left join vtar_asunto_gestor ges on ptes.asu_id = ges.asu_id 
                             left join vtar_asunto_supervisor sup on ptes.asu_id = sup.asu_id
                             left join vtar_tar_vre_via_prc vre_prc on vtar.tar_id = vre_prc.tar_id
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
                    EXTRACT (DAY FROM (  SYSTIMESTAMP
                                                - (trunc(t.tar_fecha_venc))
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
                            linmaster.dd_sta_subtipo_tarea_base stb
                      WHERE tn.dd_sta_id = stb.dd_sta_id
                        AND tn.tar_id = t.tar_id) tiposolicitudsql
                     ,tpo_ent.DD_EIN_DESCRIPCION entidadinformacion
                     , asu.fechacrear asu_fechacrear
                     , prc.fechacrear prc_fechacrear
                     , est.dd_est_descripcion asu_situacion
                     , asoc.tar_descripcion desc_tar_asociada
                     , ges.apellido_nombre asu_apenom_gestor  
                     , sup.apellido_nombre asu_apenom_supervisor 
                     , nvl(vre_prc.vre,0) vre_via_prc
               FROM vtar_tarea_vs_tge t 
                    LEFT JOIN asu_asuntos asu ON t.asu_id = asu.asu_id
                    LEFT JOIN prc_procedimientos prc ON t.prc_id = prc.prc_id
                    LEFT JOIN dd_tpo_tipo_procedimiento tpo ON prc.dd_tpo_id = tpo.dd_tpo_id
                    LEFT JOIN linmaster.dd_ein_entidad_informacion tpo_ent ON t.dd_ein_id = tpo_ent.dd_ein_id
                    LEFT JOIN linmaster.dd_sta_subtipo_tarea_base sbt_tar ON t.dd_sta_id = sbt_tar.dd_sta_id
                    LEFT JOIN linmaster.dd_est_estados_itinerarios est on asu.dd_est_id = est.dd_est_id
                    left join tar_tareas_notificaciones asoc on t.tar_tar_id = asoc.tar_id
                    left join vtar_asunto_gestor ges on asu.asu_id = ges.asu_id 
                    left join vtar_asunto_supervisor sup on asu.asu_id = sup.asu_id
                    left join vtar_tar_vre_via_prc vre_prc on t.tar_id = vre_prc.tar_id
              WHERE t.dd_sta_id IN
                       (700, 701) -- añadimos aqui las tareas individualizadas                       
                                 ) v             
   ORDER BY tar_fecha_venc;

