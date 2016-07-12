
  CREATE OR REPLACE FORCE VIEW "REM01"."VTAR_TAREA_VS_USUARIO" ("USU_PENDIENTES", "USU_ESPERA", "USU_ALERTA", "DD_TGE_ID_PENDIENTE", "DD_TGE_ID_ESPERA", "DD_TGE_ID_ALERTA", "TAR_ID", "CLI_ID", "EXP_ID", "ASU_ID", "TAR_TAR_ID", "SPR_ID", "SCX_ID", "DD_EST_ID", "DD_EIN_ID", "DD_STA_ID", "TAR_CODIGO", "TAR_TAREA", "TAR_DESCRIPCION", "TAR_FECHA_FIN", "TAR_FECHA_INI", "TAR_EN_ESPERA", "TAR_ALERTA", "TAR_TAREA_FINALIZADA", "TAR_EMISOR", "VERSION", "USUARIOCREAR", "FECHACREAR", "USUARIOMODIFICAR", "FECHAMODIFICAR", "USUARIOBORRAR", "FECHABORRAR", "BORRADO", "PRC_ID", "CMB_ID", "SET_ID", "TAR_FECHA_VENC", "OBJ_ID", "TAR_FECHA_VENC_REAL", "DTYPE", "NFA_TAR_REVISADA", "NFA_TAR_FECHA_REVIS_ALER", "NFA_TAR_COMENTARIOS_ALERTA", "DD_TRA_ID", "CNT_ID", "TAR_DESTINATARIO", "TAR_TIPO_DESTINATARIO", "TAR_ID_DEST", "PER_ID", "RPR_REFERENCIA", "TAR_TIPO_ENT_COD", "TAR_DTYPE", "TAR_SUBTIPO_COD", "TAR_SUBTIPO_DESC", "PLAZO", "ENTIDADINFORMACION", "CODENTIDAD", "GESTOR", "TIPOSOLICITUDSQL", "IDENTIDAD", "FCREACIONENTIDAD", "CODIGOSITUACION", "IDTAREAASOCIADA", "DESCRIPCIONTAREAASOCIADA", "SUPERVISOR", "DIASVENCIDOSQL", "DESCRIPCIONENTIDAD", "SUBTIPOTARCODTAREA", "FECHACREACIONENTIDADFORMATEADA", "DESCRIPCIONEXPEDIENTE", "DESCRIPCIONCONTRATO", "IDENTIDADPERSONA", "VOLUMENRIESGOSQL", "TIPOITINERARIOENTIDAD", "PRORROGAFECHAPROPUESTA", "PRORROGACAUSADESCRIPCION", "CODIGOCONTRATO", "CONTRATO") AS 
  SELECT 
    CASE ein.dd_ein_codigo 
      WHEN '61' --Activo 
        THEN nvl(tac.usu_id,v.usu_pendientes) 
-- THEN USU.usu_nombre 
      ELSE NULL 
    END usu_pendientes , 
    CASE 
      WHEN (NVL(tar.tar_en_espera,0) = 1) 
      THEN NVL(esp.usu_id,-1) 
      ELSE                -1 
    END usu_espera 
    -- , CASE WHEN v.en_espera=1 THEN esp.usu_id ELSE 1 END usu_espera 
    , 
    v.usu_alerta, 
    v.dd_tge_id_pendiente , 
    -1 dd_tge_id_espera --DEPRECATED 
    , 
    v.dd_tge_id_alerta , 
    tar.tar_id, 
    tar.cli_id, 
    tar.exp_id, 
    tar.asu_id, 
    tar.tar_tar_id, 
    tar.spr_id, 
    tar.scx_id , 
    tar.dd_est_id, 
    tar.dd_ein_id, 
    tar.dd_sta_id, 
    tar.tar_codigo, 
    tar.tar_tarea , 
    CASE tar.dd_ein_id 
--      WHEN 5 
--        THEN 
--          CASE 
--            WHEN tpo.dd_tpo_descripcion IS NOT NULL 
--              THEN asu.asu_nombre || '-' || tpo.dd_tpo_descripcion 
--            ELSE asu.asu_nombre 
--          END 
--      WHEN 3 
--        THEN asu.asu_nombre 
--      WHEN 10 
--        THEN tar.tar_descripcion 
      WHEN 61 
		 THEN 
			CASE 
				WHEN tpo.dd_tpo_descripcion IS NOT NULL 
					THEN tpo.dd_tpo_descripcion 
				ELSE tar.tar_descripcion 
           END 
      ELSE tar.tar_descripcion 
    END tar_descripcion , 
    tar.tar_fecha_fin, 
    tar.tar_fecha_ini, 
    tar.tar_en_espera, 
    tar.tar_alerta, 
    tar.tar_tarea_finalizada, 
    tar.tar_emisor, 
    tar.VERSION, 
    tar.usuariocrear, 
    tar.fechacrear, 
    tar.usuariomodificar , 
    tar.fechamodificar, 
    tar.usuarioborrar, 
    tar.fechaborrar, 
    tar.borrado, 
    tar.prc_id, 
    tar.cmb_id, 
    tar.set_id, 
    tar.tar_fecha_venc, 
    tar.obj_id, 
    tar.tar_fecha_venc_real, 
    tar.dtype, 
    tar.nfa_tar_revisada , 
    tar.nfa_tar_fecha_revis_aler, 
    tar.nfa_tar_comentarios_alerta, 
    tar.dd_tra_id, 
    tar.cnt_id, 
    tar.tar_destinatario, 
    tar.tar_tipo_destinatario, 
    tar.tar_id_dest, 
    tar.per_id, 
    tar.rpr_referencia, 
    ein.dd_ein_codigo TAR_TIPO_ENT_COD , 
    tar.dtype tar_dtype, 
    STA.dd_sta_codigo TAR_SUBTIPO_COD, 
    sta.dd_sta_descripcion TAR_SUBTIPO_DESC, 
    '' plazo -- TODO Sacar plazo para expediente y cliente 
    ,CASE ein.dd_ein_codigo 
--       WHEN '3'  --Asunto 
--          THEN ein.dd_ein_descripcion || ' [' || tar.asu_id || ']' 
--       WHEN '5'  --Procedimiento 
--          THEN ein.dd_ein_descripcion || ' [' || tar.prc_id || ']' 
--       WHEN '2'  --Expediente 
--          THEN ein.dd_ein_descripcion || ' [' || tar.exp_id || ']' 
--       WHEN '9'  --Persona 
--          THEN ein.dd_ein_descripcion || ' [' || tar.per_id || ']' 
--       WHEN '10' --Notificacion 
--          THEN ein.dd_ein_descripcion || ' [' || tar.tar_id || ']' 
       WHEN '61' --Activo 
          THEN ein.dd_ein_descripcion || ' [' || tac.tar_id || ']' 
        -- TODO poner para el resto de unidades de gestion 
      ELSE '' 
    END entidadinformacion , 
    CASE ein.dd_ein_codigo 
--      WHEN '3'  --Asunto 
--        THEN tar.asu_id 
--      WHEN '5'  --Procedimiento 
--        THEN tar.prc_id 
--      WHEN '2'  --Expediente 
--        THEN tar.exp_id 
--      WHEN '9'  --Persona 
--        THEN tar.per_id 
--      WHEN '10' --Notificacion 
--        THEN tar.tar_id 
      WHEN '61' --Activo 
        THEN ACT.ACT_NUM_ACTIVO  
        -- TODO poner para el resto de unidades de gestion 
      ELSE -1 
    END codentidad , 
    --CASE 
    --WHEN sta.dd_sta_id NOT IN (700, 701) 
    --  THEN 
    --      CASE ein.dd_ein_codigo 
--            WHEN '3'  --Asunto 
--              THEN ges.apellido_nombre 
--            WHEN '5'  --Procedimiento 
--              THEN ges.apellido_nombre 
--            WHEN '2'  --Expediente 
--              THEN ges.apellido_nombre 
--            WHEN '9'  --Persona 
--              THEN ges.apellido_nombre 
--            WHEN '10' --Notificacion 
--              THEN ges.apellido_nombre 
--            WHEN '61' --Notificacion 
--              THEN ges.apellido_nombre 
--              -- TODO poner para el resto de unidades de gestion 
 --           ELSE NULL 
--          END 
--      ELSE NULL 
 --   END gestor , 
	 ges.apellido_nombre gestor,
    CASE 
--      WHEN sta.dd_sta_codigo IN ('5', '6', '54', '41') 
--        THEN 'Prórroga' 
--      WHEN sta.dd_sta_codigo IN ('17') 
--        THEN 'Cancelación Expediente' 
--      WHEN sta.dd_sta_codigo IN ('29') 
--        THEN 'Expediente Manual' 
--      WHEN sta.dd_sta_codigo IN ('16', '28', '24', '26', '27', '589', '590', '15') 
--        THEN 'Comunicación' 
      WHEN sta.dd_sta_codigo IN ('NTGPS') 
        THEN 'Notificación automática' 
      ELSE '' 
    END tiposolicitudsql , 
    CASE ein.dd_ein_codigo 
--      WHEN '3'  --Asunto 
--        THEN tar.asu_id 
--      WHEN '5'  --Procedimiento 
--        THEN tar.prc_id 
--      WHEN '2'  --Expediente 
--        THEN tar.EXP_ID 
--      WHEN '9'  --Persona 
--        THEN tar.PER_ID 
--      WHEN '10' --Notificacion 
--        THEN tar.PRC_ID --Must be PRC_ID 
      WHEN '61' --Activo 
        THEN tac.ACT_ID 
        -- TODO poner para el resto de unidades de gestion 
      ELSE -1 
    END identidad , 
    CASE ein.dd_ein_codigo 
--      WHEN '3'  --Asunto 
--        THEN asu.fechacrear 
--      WHEN '5'  --Procedimiento 
--        THEN prc.fechacrear 
--      WHEN '2'  --Expediente 
--        THEN exp.fechacrear 
--      WHEN '9'  --Persona 
--        THEN per.fechacrear 
--      WHEN '10' --Notificacion 
--        THEN per.fechacrear 
      WHEN '61' --Activo 
        THEN tac.fechacrear 
        -- TODO poner para el resto de unidades de gestion 
      ELSE NULL 
    END fcreacionentidad , 
    CASE ein.dd_ein_codigo 
--      WHEN '3' 
--      THEN est.dd_est_descripcion --asu.asu_situacion 
      WHEN '61' 
	      THEN '' 
        -- TODO poner para el resto de unidades de gestion 
      ELSE '' 
    END codigosituacion , 
    tar.tar_tar_id idtareaasociada, 
    asoc.tar_descripcion descripciontareaasociada , 
    CASE ein.dd_ein_codigo 
--      WHEN '3'  --Asunto 
--        THEN sup.apellido_nombre 
--      WHEN '5'  --Procedimiento 
--        THEN sup.apellido_nombre 
--      WHEN '2'  --Expediente 
--        THEN sup.apellido_nombre 
--      WHEN '9'  --Persona 
--        THEN sup.apellido_nombre 
--      WHEN '10' --Notificacion 
--        THEN sup.apellido_nombre 
      WHEN '61' --Activo 
        THEN sup.apellido_nombre 
        -- TODO poner para el resto de unidades de gestion 
      ELSE NULL 
    END supervisor , 
--    CASE 
--      WHEN TRUNC (tar.tar_fecha_venc) >= TRUNC(sysdate) 
--        THEN NULL 
--      ELSE EXTRACT (DAY FROM (SYSTIMESTAMP - (TRUNC (tar.tar_fecha_venc)))) 
--    END diasvencidosql , 
	 EXTRACT (DAY FROM ((TRUNC (tar.tar_fecha_venc)) - SYSTIMESTAMP)) diasvencidosql, 
    CASE ein.dd_ein_codigo 
--      WHEN '3'  --Asunto 
--        THEN asu.asu_nombre 
--      WHEN '5'  --Procedimiento 
--        THEN 
--          CASE 
--            WHEN tpo.dd_tpo_descripcion IS NOT NULL 
--              THEN asu.asu_nombre || '-' || tpo.dd_tpo_descripcion 
--            ELSE asu.asu_nombre 
--          END 
--      WHEN '2'  --Expediente 
--        THEN EXP.EXP_DESCRIPCION 
--      WHEN '9'  --Persona 
--        THEN PER.PER_NOM50 
--      WHEN '4'  --Tarea 
--        THEN tar.tar_descripcion 
--      WHEN '10' --Notificacion 
--        THEN tar.tar_descripcion 
      WHEN '61' --Activo 
        THEN nvl(tpo.dd_tpo_descripcion,'--') 
        -- TODO poner para el resto de unidades de gestion 
      ELSE '--' 
    END descripcionentidad , 
    sta.dd_sta_codigo subtipotarcodtarea, 
    CASE ein.dd_ein_codigo 
--      WHEN '3'  --Asunto 
--        THEN TO_CHAR (asu.fechacrear, 'dd/mm/yyyy') 
--      WHEN '5'  --Procedimiento 
--        THEN TO_CHAR (prc.fechacrear, 'dd/mm/yyyy') 
--      WHEN '2'  --Expediente 
--        THEN TO_CHAR (exp.fechacrear, 'dd/mm/yyyy') 
--      WHEN '9'  --Persona 
--        THEN TO_CHAR (per.fechacrear, 'dd/mm/yyyy') 
--      WHEN '10' --Notificacion 
--        THEN TO_CHAR (tar.fechacrear, 'dd/mm/yyyy') 
      WHEN '61' --Activo 
        THEN TO_CHAR (tac.fechacrear, 'dd/mm/yyyy') 
        -- TODO poner para el resto de unidades de gestion 
      ELSE NULL 
    END fechacreacionentidadformateada , 
    NULL descripcionexpediente -- TODO poner para expediente 
    , 
    NULL descripcioncontrato -- TODO poner para contrato 
    , 
    NULL identidadpersona -- TODO poner para objetivo y para cliente 
    ,CASE ein.dd_ein_codigo 
--      WHEN '5' 
--        THEN NVL (vre_prc.vre, 0) --vre_via_prc 
          -- TODO poner para el resto de unidades de gestion 
      WHEN '61' 
        THEN 0 
      ELSE 0 
    END volumenriesgosql , 
    NULL tipoitinerarioentidad -- TODO sacar para cliente y expediente 
    , 
    NULL prorrogafechapropuesta -- TODO calcular la fecha prorroga propuesta 
    , 
    NULL prorrogacausadescripcion -- TODO calcular la causa de la prorroga 
    , 
    NULL codigocontrato -- TODO poner para contrato 
    , 
    tac.tra_id contrato 
--    NULL contrato -- TODO calcular 
  FROM 
    ( 
--      SELECT * FROM REM01.VTAR_TAREA_VS_USUARIO_PART1 
--        UNION 
      SELECT * FROM REM01.VTAR_TAREA_VS_USUARIO_PART2 
		 UNION ALL 
	   SELECT * FROM REM01.VTAR_TAREA_VS_USUARIO_PART3 
    ) V 
  JOIN REM01.TAR_TAREAS_NOTIFICACIONES TAR ON V.TAR_ID = TAR.TAR_ID 
  LEFT JOIN REM01.TAC_TAREAS_ACTIVOS TAC ON TAR.TAR_ID = TAC.TAR_ID 
  JOIN REMMASTER.DD_EIN_ENTIDAD_INFORMACION EIN ON TAR.DD_EIN_ID = EIN.DD_EIN_ID 
  JOIN REMMASTER.DD_STA_SUBTIPO_TAREA_BASE STA ON TAR.DD_STA_ID = STA.DD_STA_ID 
--  LEFT JOIN REM01.PRC_PROCEDIMIENTOS PRC ON TAR.PRC_ID = PRC.PRC_ID AND PRC.BORRADO = 0 
--  LEFT JOIN REM01.ASU_ASUNTOS ASU ON TAR.ASU_ID = ASU.ASU_ID AND ASU.BORRADO = 0 
--  LEFT JOIN REM01.DD_TPO_TIPO_PROCEDIMIENTO TPO ON PRC.DD_TPO_ID = TPO.DD_TPO_ID 
  LEFT JOIN REM01.VTAR_NOMBRES_USUARIOS GES ON V.USU_PENDIENTES = GES.USU_ID 
  LEFT JOIN REM01.VTAR_NOMBRES_USUARIOS SUP ON V.USU_SUPERVISOR = SUP.USU_ID 
  LEFT JOIN REM01.VTAR_NOMBRES_USUARIOS ESP ON TAR.TAR_EMISOR = ESP.APELLIDO_NOMBRE 
--  LEFT JOIN REM01.EXP_EXPEDIENTES EXP ON TAR.EXP_ID = EXP.EXP_ID 
--  LEFT JOIN REM01.PER_PERSONAS PER ON TAR.PER_ID = PER.PER_ID 
--  LEFT JOIN REMMASTER.DD_EST_ESTADOS_ITINERARIOS EST ON TAR.DD_EST_ID = EST.DD_EST_ID 
  LEFT JOIN REM01.TAR_TAREAS_NOTIFICACIONES ASOC ON TAR.TAR_TAR_ID = ASOC.TAR_ID 
  LEFT JOIN REM01.ACT_ACTIVO ACT ON TAC.ACT_ID = ACT.ACT_ID 
  LEFT JOIN REM01.ACT_TRA_TRAMITE ATT ON TAC.TRA_ID = ATT.TRA_ID 
  LEFT JOIN REM01.DD_TPO_TIPO_PROCEDIMIENTO TPO ON ATT.DD_TPO_ID = TPO.DD_TPO_ID 
--  LEFT JOIN REMMASTER.USU_USUARIOS USU ON USU.USU_ID = TAC.USU_ID 
--  LEFT JOIN REM01.VTAR_TAR_VRE_VIA_PRC VRE_PRC ON TAR.TAR_ID = VRE_PRC.TAR_ID 
;
 
