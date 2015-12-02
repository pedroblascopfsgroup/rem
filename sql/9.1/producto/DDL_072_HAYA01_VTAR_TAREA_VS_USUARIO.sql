--/*
--##########################################
--## AUTOR=AGUSTIN MOMPO
--## FECHA_CREACION=20150827
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=ACUERDOS
--## PRODUCTO=SI
--## Finalidad: DDL Para hacer join con la parte nueva de ACUERDOS
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINI#'; -- Configuracion Esquema minirec
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema recovery_bankia_dwh
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; -- Configuracion Esquema recovery_bankia_datastage
    
    V_NOMBRE_VISTA VARCHAR2(30 CHAR):= 'VTAR_TAREA_VS_USUARIO';

BEGIN

    -- Comprobamos si existe la vista   
    V_SQL := 'SELECT COUNT(1) FROM ALL_VIEWS WHERE VIEW_NAME = '''||V_NOMBRE_VISTA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
         
    if V_NUM_TABLAS > 0 
     
     then          
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||' Ya Existe');
          V_MSQL := 'DROP VIEW '||V_ESQUEMA||'.'||V_NOMBRE_VISTA;
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||'... Vista borrada');
    END IF;
    
    
    EXECUTE IMMEDIATE '
CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||' (USU_PENDIENTES, USU_ESPERA, USU_ALERTA, DD_TGE_ID_PENDIENTE, 
             DD_TGE_ID_ESPERA, DD_TGE_ID_ALERTA, TAR_ID, CLI_ID, EXP_ID, ASU_ID, TAR_TAR_ID, SPR_ID, SCX_ID, DD_EST_ID, DD_EIN_ID, DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION,
             TAR_FECHA_FIN, TAR_FECHA_INI, TAR_EN_ESPERA, TAR_ALERTA, TAR_TAREA_FINALIZADA, TAR_EMISOR, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR,
             BORRADO, PRC_ID, CMB_ID, SET_ID, TAR_FECHA_VENC, OBJ_ID, TAR_FECHA_VENC_REAL, DTYPE, NFA_TAR_REVISADA, NFA_TAR_FECHA_REVIS_ALER, NFA_TAR_COMENTARIOS_ALERTA, DD_TRA_ID, CNT_ID,
             TAR_DESTINATARIO, TAR_TIPO_DESTINATARIO, TAR_ID_DEST, PER_ID, RPR_REFERENCIA, TAR_TIPO_ENT_COD, TAR_DTYPE, TAR_SUBTIPO_COD, TAR_SUBTIPO_DESC, PLAZO, ENTIDADINFORMACION,
             CODENTIDAD, GESTOR, TIPOSOLICITUDSQL, IDENTIDAD, FCREACIONENTIDAD, CODIGOSITUACION, IDTAREAASOCIADA, DESCRIPCIONTAREAASOCIADA, SUPERVISOR, DIASVENCIDOSQL, DESCRIPCIONENTIDAD, SUBTIPOTARCODTAREA,
             FECHACREACIONENTIDADFORMATEADA, DESCRIPCIONEXPEDIENTE, DESCRIPCIONCONTRATO, IDENTIDADPERSONA, VOLUMENRIESGOSQL, TIPOITINERARIOENTIDAD, PRORROGAFECHAPROPUESTA, PRORROGACAUSADESCRIPCION,
             CODIGOCONTRATO, CONTRATO) AS 
  SELECT v.usu_pendientes , 
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
      WHEN 5 
        THEN 
          CASE 
            WHEN tpo.dd_tpo_descripcion IS NOT NULL 
              THEN asu.asu_nombre || ''-'' || tpo.dd_tpo_descripcion 
            ELSE asu.asu_nombre 
          END 
      WHEN 3 
        THEN asu.asu_nombre 
      WHEN 10 
        THEN tar.tar_descripcion 
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
    '''' plazo -- TODO Sacar plazo para expediente y cliente 
    ,CASE ein.dd_ein_codigo 
       WHEN ''3''  --Asunto 
          THEN ein.dd_ein_descripcion || '' ['' || tar.asu_id || '']'' 
       WHEN ''5''  --Procedimiento 
          THEN ein.dd_ein_descripcion || '' ['' || tar.prc_id || '']'' 
       WHEN ''2''  --Expediente 
          THEN ein.dd_ein_descripcion || '' ['' || tar.exp_id || '']'' 
       WHEN ''9''  --Persona 
          THEN ein.dd_ein_descripcion || '' ['' || tar.per_id || '']'' 
       WHEN ''10'' --Notificacion 
          THEN ein.dd_ein_descripcion || '' ['' || tar.tar_id || '']'' 
        -- TODO poner para el resto de unidades de gestion 
      ELSE '''' 
    END entidadinformacion , 
    CASE ein.dd_ein_codigo 
      WHEN ''3''  --Asunto 
        THEN tar.asu_id 
      WHEN ''5''  --Procedimiento 
        THEN tar.prc_id 
      WHEN ''2''  --Expediente 
        THEN tar.exp_id 
      WHEN ''9''  --Persona 
        THEN tar.per_id 
      WHEN ''10'' --Notificacion 
        THEN tar.tar_id 
        -- TODO poner para el resto de unidades de gestion 
      ELSE -1 
    END codentidad , 
    CASE 
      WHEN sta.dd_sta_id NOT IN (700, 701) 
        THEN 
          CASE ein.dd_ein_codigo 
            WHEN ''3''  --Asunto 
              THEN ges.apellido_nombre 
            WHEN ''5''  --Procedimiento 
              THEN ges.apellido_nombre 
            WHEN ''2''  --Expediente 
              THEN ges.apellido_nombre 
            WHEN ''9''  --Persona 
              THEN ges.apellido_nombre 
            WHEN ''10'' --Notificacion 
              THEN ges.apellido_nombre 
              -- TODO poner para el resto de unidades de gestion 
            ELSE NULL 
          END 
      ELSE NULL 
    END gestor , 
    CASE 
      WHEN sta.dd_sta_codigo IN (''5'', ''6'', ''54'', ''41'') 
        THEN ''Prórroga'' 
      WHEN sta.dd_sta_codigo IN (''17'') 
        THEN ''Cancelación Expediente'' 
      WHEN sta.dd_sta_codigo IN (''29'') 
        THEN ''Expediente Manual'' 
      WHEN sta.dd_sta_codigo IN (''16'', ''28'', ''24'', ''26'', ''27'', ''589'', ''590'', ''15'') 
        THEN ''Comunicación'' 
      WHEN sta.dd_sta_codigo IN (''NTGPS'') 
        THEN ''Notificación automática'' 
      ELSE '''' 
    END tiposolicitudsql , 
    CASE ein.dd_ein_codigo 
      WHEN ''3''  --Asunto 
        THEN tar.asu_id 
      WHEN ''5''  --Procedimiento 
        THEN tar.prc_id 
      WHEN ''2''  --Expediente 
        THEN tar.EXP_ID 
      WHEN ''9''  --Persona 
        THEN tar.PER_ID 
      WHEN ''10'' --Notificacion 
        THEN tar.PRC_ID --Must be PRC_ID 
        -- TODO poner para el resto de unidades de gestion 
      ELSE -1 
    END identidad , 
    CASE ein.dd_ein_codigo 
      WHEN ''3''  --Asunto 
        THEN asu.fechacrear 
      WHEN ''5''  --Procedimiento 
        THEN prc.fechacrear 
      WHEN ''2''  --Expediente 
        THEN exp.fechacrear 
      WHEN ''9''  --Persona 
        THEN per.fechacrear 
      WHEN ''10'' --Notificacion 
        THEN per.fechacrear 
        -- TODO poner para el resto de unidades de gestion 
      ELSE NULL 
    END fcreacionentidad , 
    CASE ein.dd_ein_codigo 
      WHEN ''3'' 
      THEN est.dd_est_descripcion --asu.asu_situacion 
        -- TODO poner para el resto de unidades de gestion 
      ELSE '''' 
    END codigosituacion , 
    tar.tar_tar_id idtareaasociada, 
    asoc.tar_descripcion descripciontareaasociada , 
    CASE ein.dd_ein_codigo 
      WHEN ''3''  --Asunto 
        THEN sup.apellido_nombre 
      WHEN ''5''  --Procedimiento 
        THEN sup.apellido_nombre 
      WHEN ''2''  --Expediente 
        THEN sup.apellido_nombre 
      WHEN ''9''  --Persona 
        THEN sup.apellido_nombre 
      WHEN ''10'' --Notificacion 
        THEN sup.apellido_nombre 
        -- TODO poner para el resto de unidades de gestion 
      ELSE NULL 
    END supervisor , 
    CASE 
      WHEN TRUNC (tar.tar_fecha_venc) >= TRUNC(sysdate) 
        THEN NULL 
      ELSE EXTRACT (DAY FROM (SYSTIMESTAMP - (TRUNC (tar.tar_fecha_venc)))) 
    END diasvencidosql , 
    CASE ein.dd_ein_codigo 
      WHEN ''3''  --Asunto 
        THEN asu.asu_nombre 
      WHEN ''5''  --Procedimiento 
        THEN 
          CASE 
            WHEN tpo.dd_tpo_descripcion IS NOT NULL 
              THEN asu.asu_nombre || ''-'' || tpo.dd_tpo_descripcion 
            ELSE asu.asu_nombre 
          END 
      WHEN ''2''  --Expediente 
        THEN EXP.EXP_DESCRIPCION 
      WHEN ''9''  --Persona 
        THEN PER.PER_NOM50 
      WHEN ''4''  --Tarea 
        THEN tar.tar_descripcion 
      WHEN ''10'' --Notificacion 
        THEN tar.tar_descripcion 
        -- TODO poner para el resto de unidades de gestion 
      ELSE NULL 
    END descripcionentidad , 
    sta.dd_sta_codigo subtipotarcodtarea, 
    CASE ein.dd_ein_codigo 
      WHEN ''3''  --Asunto 
        THEN TO_CHAR (asu.fechacrear, ''dd/mm/yyyy'') 
      WHEN ''5''  --Procedimiento 
        THEN TO_CHAR (prc.fechacrear, ''dd/mm/yyyy'') 
      WHEN ''2''  --Expediente 
        THEN TO_CHAR (exp.fechacrear, ''dd/mm/yyyy'') 
      WHEN ''9''  --Persona 
        THEN TO_CHAR (per.fechacrear, ''dd/mm/yyyy'') 
      WHEN ''10'' --Notificacion 
        THEN TO_CHAR (tar.fechacrear, ''dd/mm/yyyy'') 
        -- TODO poner para el resto de unidades de gestion 
      ELSE NULL 
    END fechacreacionentidadformateada , 
    NULL descripcionexpediente -- TODO poner para expediente 
    , 
    NULL descripcioncontrato -- TODO poner para contrato 
    , 
    NULL identidadpersona -- TODO poner para objetivo y para cliente 
    ,CASE ein.dd_ein_codigo 
      WHEN ''5'' 
        THEN NVL (vre_prc.vre, 0) --vre_via_prc 
          -- TODO poner para el resto de unidades de gestion 
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
    NULL contrato -- TODO calcular 
  FROM 
    ( 
      SELECT * FROM '||V_ESQUEMA||'.VTAR_TAREA_VS_USUARIO_PART1 
        UNION 
      SELECT * FROM '||V_ESQUEMA||'.VTAR_TAREA_VS_USUARIO_PART2 
        UNION
      SELECT * FROM '||V_ESQUEMA||'.VTAR_TAREA_VS_USUARIO_ACUERDOS 
    ) V 
  JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON V.TAR_ID = TAR.TAR_ID 
  JOIN '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION EIN ON TAR.DD_EIN_ID = EIN.DD_EIN_ID 
  JOIN '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE STA ON TAR.DD_STA_ID = STA.DD_STA_ID 
  LEFT JOIN '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON TAR.PRC_ID = PRC.PRC_ID AND PRC.BORRADO = 0 
  LEFT JOIN '||V_ESQUEMA||'.ASU_ASUNTOS ASU ON TAR.ASU_ID = ASU.ASU_ID AND ASU.BORRADO = 0 
  LEFT JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON PRC.DD_TPO_ID = TPO.DD_TPO_ID 
  LEFT JOIN '||V_ESQUEMA||'.VTAR_NOMBRES_USUARIOS GES ON V.USU_PENDIENTES = GES.USU_ID 
  LEFT JOIN '||V_ESQUEMA||'.VTAR_NOMBRES_USUARIOS SUP ON V.USU_SUPERVISOR = SUP.USU_ID 
  LEFT JOIN '||V_ESQUEMA||'.VTAR_NOMBRES_USUARIOS ESP ON TAR.TAR_EMISOR = ESP.APELLIDO_NOMBRE
  LEFT JOIN '||V_ESQUEMA||'.EXP_EXPEDIENTES EXP ON TAR.EXP_ID = EXP.EXP_ID 
  LEFT JOIN '||V_ESQUEMA||'.PER_PERSONAS PER ON TAR.PER_ID = PER.PER_ID 
  LEFT JOIN '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS EST ON TAR.DD_EST_ID = EST.DD_EST_ID 
  LEFT JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES ASOC ON TAR.TAR_TAR_ID = ASOC.TAR_ID 
  LEFT JOIN '||V_ESQUEMA||'.VTAR_TAR_VRE_VIA_PRC VRE_PRC ON TAR.TAR_ID = VRE_PRC.TAR_ID
';

    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NOMBRE_VISTA||' Creada');     

EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;
