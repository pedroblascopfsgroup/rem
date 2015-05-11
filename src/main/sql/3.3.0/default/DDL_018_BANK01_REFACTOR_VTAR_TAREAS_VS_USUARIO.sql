--/*
--##########################################
--## Author: Gonzalo
--## Test de optimización de la búsqueda de tareas pendientes
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 
    
BEGIN

  DBMS_OUTPUT.PUT_LINE('CREATE VISTAS ');

--REFACTORIZACIÓN DE: VTAR_TAREA_VS_TGE
EXECUTE IMMEDIATE 'CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'."VTAR_TAREA_VS_TGE"
AS 
SELECT
  CASE
    WHEN (sta.dd_sta_id = 700 OR sta.dd_sta_id = 701) THEN -1
    WHEN NVL (tap.dd_tge_id, 0) != 0 THEN tap.dd_tge_id
    WHEN sta.dd_tge_id IS NULL THEN CASE sta.dd_sta_gestor  WHEN 0 THEN 3 ELSE 2 END
    ELSE sta.dd_tge_id
  END dd_tge_id_pendiente 
--  , CASE
--    WHEN (tar.tar_en_espera IS NOT NULL AND tar.tar_en_espera = 1) THEN 1
--    ELSE 0
--  END en_espera
  , CASE
    WHEN (tar.tar_alerta IS NOT NULL AND tar.tar_alerta = 1) THEN NVL (tap.dd_tsup_id, 3)
    ELSE -1
  END dd_tge_id_alerta
  , NVL (tap.dd_tsup_id, 3) dd_tge_id_supervisor, tar.ASU_ID, tar.TAR_ID, tar.dd_sta_id, tar.tar_id_dest
FROM tar_tareas_notificaciones tar
  JOIN '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base sta ON tar.dd_sta_id = sta.dd_sta_id
  LEFT JOIN tex_tarea_externa tex ON tar.tar_id = tex.tar_id
  LEFT JOIN tap_tarea_procedimiento tap ON tex.tap_id = tap.tap_id
 -- LEFT JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON TAR.USUARIOCREAR = USU.USU_USERNAME
WHERE  (tar.tar_tarea_finalizada IS NULL OR tar.tar_tarea_finalizada = 0) AND tar.dd_ein_id IN (3, 5, 2, 9) AND tar.borrado = 0';

--REFACTORIZACIÓN DE:-VTAR_TAREA_VS_RESPONSABLES
EXECUTE IMMEDIATE 'CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'."VTAR_TAREA_VS_RESPONSABLES"
AS
SELECT tar_id, MAX(dd_tge_id_alerta) AS dd_tge_id_alerta
        , MAX(dd_tge_id_pendiente) as dd_tge_id_pendiente, MAX(dd_tge_id_supervisor) as dd_tge_id_supervisor, MAX(NVL (usu_pendientes, -1)) usu_pendientes
        , MAX(NVL (usu_alerta, -1)) usu_alerta, MAX(NVL (usu_supervisor, -1)) usu_supervisor
        --,MAX(NVL (en_espera, 0)) en_espera
     FROM (
     SELECT vtar.tar_id, vtar.dd_tge_id_alerta
                  , vtar.dd_tge_id_pendiente, vtar.dd_tge_id_supervisor
                  , DECODE (vusu.dd_tge_id, vtar.dd_tge_id_pendiente, vusu.usu_id) usu_pendientes
                  --, vtar.en_espera en_espera
                  , DECODE (vusu.dd_tge_id, vtar.dd_tge_id_alerta, vusu.usu_id) usu_alerta
                  , DECODE (vusu.dd_tge_id, vtar.dd_tge_id_supervisor, vusu.usu_id) usu_supervisor
      FROM VTAR_TAREA_VS_TGE vtar 
        JOIN vtar_asu_vs_usu vusu ON vtar.asu_id = vusu.asu_id 
      )
  WHERE (usu_pendientes>0 
    -- or en_espera>0 
    or usu_alerta>0) 
  GROUP BY tar_id';

--REFACTORIZACIÓN DE: VTAR_TAREA_VS_USUARIO_PART1
EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW '||V_ESQUEMA||'."VTAR_TAREA_VS_USUARIO_PART1"
AS
SELECT TAR_ID 
  ,usu_pendientes
  --,NVL (en_espera, 0) en_espera
  ,NVL (usu_alerta, -1) usu_alerta, NVL(usu_supervisor, -1) usu_supervisor
  ,dd_tge_id_alerta
  , dd_tge_id_pendiente
FROM VTAR_TAREA_VS_RESPONSABLES';

--REFACTORIZACIÓN DE: VTAR_TAREA_VS_USUARIO_PART2
EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW '||V_ESQUEMA||'."VTAR_TAREA_VS_USUARIO_PART2"
AS 
SELECT TAR_ID 
  , t.tar_id_dest usu_pendientes
  --, 0 usu_espera
  , -1 usu_alerta, t.dd_tge_id_supervisor usu_supervisor
  , t.dd_tge_id_alerta
  , t.dd_tge_id_pendiente
FROM VTAR_TAREA_VS_TGE t
WHERE t.dd_sta_id IN (700, 701) ';

--REFACTORIZACIÓN DE: VTAR_TAREA_VS_USUARIO
EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW '||V_ESQUEMA||'.VTAR_TAREA_VS_USUARIO
AS
SELECT v.usu_pendientes
      , CASE WHEN (NVL(tar.tar_en_espera,0) = 1) THEN NVL(esp.usu_id,-1) ELSE -1 END usu_espera
		  -- , CASE WHEN v.en_espera=1 THEN esp.usu_id ELSE 1 END usu_espera  
		  , v.usu_alerta, v.dd_tge_id_pendiente
          , -1 dd_tge_id_espera --DEPRECATED 
          , v.dd_tge_id_alerta
          , tar.tar_id, tar.cli_id, tar.exp_id, tar.asu_id, tar.tar_tar_id, tar.spr_id, tar.scx_id 
          , tar.dd_est_id, tar.dd_ein_id, tar.dd_sta_id, tar.tar_codigo, tar.tar_tarea 
          , CASE tar.dd_ein_id 
             WHEN 5 
                THEN CASE WHEN tpo.dd_tpo_descripcion IS NOT NULL THEN asu.asu_nombre || ''-'' || tpo.dd_tpo_descripcion ELSE asu.asu_nombre END 
             WHEN 3 
                THEN asu.asu_nombre 
             ELSE tar.tar_descripcion 
          END tar_descripcion 
          , tar.tar_fecha_fin, tar.tar_fecha_ini, tar.tar_en_espera, tar.tar_alerta, tar.tar_tarea_finalizada, tar.tar_emisor, tar.VERSION, tar.usuariocrear, tar.fechacrear, tar.usuariomodificar 
          , tar.fechamodificar, tar.usuarioborrar, tar.fechaborrar, tar.borrado, tar.prc_id, tar.cmb_id, tar.set_id, tar.tar_fecha_venc, tar.obj_id, tar.tar_fecha_venc_real, tar.dtype, tar.nfa_tar_revisada 
          , tar.nfa_tar_fecha_revis_aler, tar.nfa_tar_comentarios_alerta, tar.dd_tra_id, tar.cnt_id, tar.tar_destinatario, tar.tar_tipo_destinatario, tar.tar_id_dest, tar.per_id, tar.rpr_referencia, ein.dd_ein_codigo TAR_TIPO_ENT_COD
          , tar.dtype tar_dtype, STA.dd_sta_codigo TAR_SUBTIPO_COD, sta.dd_sta_descripcion TAR_SUBTIPO_DESC, '''' plazo  -- TODO Sacar plazo para expediente y cliente
          , CASE ein.dd_ein_codigo
             WHEN ''3''
                THEN ein.dd_ein_descripcion || '' ['' || tar.asu_id || '']''
             WHEN ''5''
                THEN ein.dd_ein_descripcion || '' ['' || tar.prc_id || '']''
             WHEN ''2''
                THEN ein.dd_ein_descripcion || '' ['' || tar.exp_id || '']''
             WHEN ''9''
                THEN ein.dd_ein_descripcion || '' ['' || tar.per_id || '']''
             -- TODO poner para el resto de unidades de gestion
          ELSE ''''
          END entidadinformacion
          , CASE ein.dd_ein_codigo
             WHEN ''3''
                THEN tar.asu_id
             WHEN ''5''
                THEN tar.prc_id
             WHEN ''2''
                THEN tar.exp_id
             WHEN ''9''
                THEN tar.per_id
             -- TODO poner para el resto de unidades de gestion
          ELSE -1
          END codentidad
          , CASE WHEN sta.dd_sta_id NOT IN (700, 701) THEN CASE ein.dd_ein_codigo
             WHEN ''3''
                THEN ges.apellido_nombre
             WHEN ''5''
                THEN ges.apellido_nombre
             WHEN ''2''
                THEN ges.apellido_nombre
             WHEN ''9''
                THEN ges.apellido_nombre
             -- TODO poner para el resto de unidades de gestion
          ELSE NULL
          END ELSE NULL END gestor
          , CASE
              WHEN sta.dd_sta_codigo IN (''5'', ''6'', ''54'', ''41'') THEN ''Prórroga''
              WHEN sta.dd_sta_codigo IN (''17'') THEN ''Cancelación Expediente''
              WHEN sta.dd_sta_codigo IN (''29'') THEN ''Expediente Manual''
              WHEN sta.dd_sta_codigo IN (''16'', ''28'', ''24'', ''26'', ''27'', ''589'', ''590'', ''15'') THEN ''Comunicación''
              ELSE ''''
          END tiposolicitudsql
          , CASE ein.dd_ein_codigo
             WHEN ''3''
                THEN tar.asu_id
             WHEN ''5''
                THEN tar.prc_id
             WHEN ''2'' THEN tar.EXP_ID
             WHEN ''9'' THEN tar.PER_ID
             -- TODO poner para el resto de unidades de gestion
          ELSE -1
          END identidad
          , CASE ein.dd_ein_codigo
             WHEN ''3''
                THEN asu.fechacrear
             WHEN ''5''
                THEN prc.fechacrear
             WHEN ''2''
                THEN exp.fechacrear
             WHEN ''2''
                THEN per.fechacrear
             -- TODO poner para el resto de unidades de gestion
          ELSE NULL
          END fcreacionentidad
          , CASE ein.dd_ein_codigo
             WHEN ''3''
                THEN est.dd_est_descripcion --asu.asu_situacion
             -- TODO poner para el resto de unidades de gestion
          ELSE ''''
          END codigosituacion
          , tar.tar_tar_id idtareaasociada, asoc.tar_descripcion descripciontareaasociada
         , CASE ein.dd_ein_codigo
             WHEN ''3''
                THEN sup.apellido_nombre
             WHEN ''5''
                THEN sup.apellido_nombre
             when ''2'' then sup.apellido_nombre
             when ''9'' then sup.apellido_nombre
             -- TODO poner para el resto de unidades de gestion
          ELSE NULL
          END supervisor
          , CASE
             WHEN TRUNC (tar.tar_fecha_venc) >= trunc(sysdate)
                THEN NULL
             ELSE EXTRACT (DAY FROM (SYSTIMESTAMP - (TRUNC (tar.tar_fecha_venc))))
          END diasvencidosql
          , CASE ein.dd_ein_codigo
             WHEN ''3''
                THEN asu.asu_nombre
             WHEN ''5''
                THEN CASE WHEN tpo.dd_tpo_descripcion IS NOT NULL THEN asu.asu_nombre || ''-'' || tpo.dd_tpo_descripcion ELSE asu.asu_nombre END
             when ''2'' then EXP.EXP_DESCRIPCION
             when ''9'' then PER.PER_NOM50
             -- TODO poner para el resto de unidades de gestion
          ELSE NULL
          END descripcionentidad
          , sta.dd_sta_codigo subtipotarcodtarea,
          CASE ein.dd_ein_codigo
             WHEN ''3''
                THEN TO_CHAR (asu.fechacrear, ''dd/mm/yyyy'')
             WHEN ''5''
                THEN TO_CHAR (prc.fechacrear, ''dd/mm/yyyy'')
             WHEN ''2''
                THEN TO_CHAR (exp.fechacrear, ''dd/mm/yyyy'')
             WHEN ''9''
                THEN TO_CHAR (per.fechacrear, ''dd/mm/yyyy'')
             -- TODO poner para el resto de unidades de gestion
            ELSE NULL
          END fechacreacionentidadformateada
          , NULL descripcionexpediente  -- TODO poner para expediente
          , NULL descripcioncontrato     -- TODO poner para contrato                                                                                                                                       
          , NULL identidadpersona   -- TODO poner para objetivo y para cliente                                                                                                                            
          , CASE ein.dd_ein_codigo 
             WHEN ''5'' 
                THEN NVL (vre_prc.vre, 0)  --vre_via_prc
              -- TODO poner para el resto de unidades de gestion
          ELSE 0 
          END volumenriesgosql 
          , NULL tipoitinerarioentidad      -- TODO sacar para cliente y expediente                                                                                                  
          , NULL prorrogafechapropuesta  -- TODO calcular la fecha prorroga propuesta
          , NULL prorrogacausadescripcion   -- TODO calcular la causa de la prorroga
          , NULL codigocontrato   -- TODO poner para contrato
          , NULL contrato    -- TODO calcular
FROM (SELECT * 
             FROM VTAR_TAREA_VS_USUARIO_PART1 
           UNION 
           SELECT * 
             FROM VTAR_TAREA_VS_USUARIO_PART2) v 
    JOIN TAR_TAREAS_NOTIFICACIONES TAR ON V.TAR_ID = TAR.TAR_ID 
    JOIN '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION EIN ON TAR.DD_EIN_ID = EIN.DD_EIN_ID 
    JOIN '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE STA ON TAR.DD_STA_ID = STA.DD_STA_ID 
    LEFT JOIN PRC_PROCEDIMIENTOS PRC ON TAR.PRC_ID = PRC.PRC_ID AND PRC.BORRADO = 0 
    LEFT JOIN ASU_ASUNTOS ASU ON TAR.ASU_ID = ASU.ASU_ID AND ASU.BORRADO = 0 
    LEFT JOIN DD_TPO_TIPO_PROCEDIMIENTO TPO ON PRC.DD_TPO_ID = TPO.DD_TPO_ID 
    LEFT JOIN vtar_nombres_usuarios ges ON v.usu_pendientes = ges.usu_id 
    LEFT JOIN vtar_nombres_usuarios sup ON v.usu_supervisor = sup.usu_id
    LEFT JOIN vtar_nombres_usuarios esp ON tar.tar_emisor = esp.apellido_nombre
    LEFT JOIN EXP_EXPEDIENTES EXP ON TAR.EXP_ID = EXP.EXP_ID 
    LEFT JOIN PER_PERSONAS PER ON TAR.PER_ID = PER.PER_ID 
    LEFT JOIN '||V_ESQUEMA_M||'.dd_est_estados_itinerarios est ON tar.dd_est_id = est.dd_est_id
    LEFT JOIN tar_tareas_notificaciones asoc ON tar.tar_tar_id = asoc.tar_id
    LEFT JOIN vtar_tar_vre_via_prc vre_prc ON tar.tar_id = vre_prc.tar_id';

  DBMS_OUTPUT.PUT_LINE('FIN CREA VISTAS ');

END;
/

EXIT;