--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20160802
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.0
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: DDL
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_VIEWNAME VARCHAR2(30):= 'VTAR_TAREA_VS_USUARIO';

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');

DBMS_OUTPUT.PUT_LINE('[INFO] Bloque scripts para la inclusión de un nuevo tipo del histórico de operaciones - Notificación - (7/7)');
DBMS_OUTPUT.PUT('[INFO] Modificación de la vista '||V_VIEWNAME||'...');

--/**
-- * Modificacion o creación de vista: Si existe modifica y si no, la crea como nueva - Script relanzable
-- *************************************************************/
execute immediate 
('CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_VIEWNAME||'  '||Chr(13)||Chr(10)||
'(USU_PENDIENTES, USU_ESPERA, USU_ALERTA, DD_TGE_ID_PENDIENTE, DD_TGE_ID_ESPERA, DD_TGE_ID_ALERTA, TAR_ID, CLI_ID, EXP_ID, ASU_ID,  '||Chr(13)||Chr(10)||
' TAR_TAR_ID, SPR_ID, SCX_ID, DD_EST_ID, DD_EIN_ID, DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION, TAR_FECHA_FIN, TAR_FECHA_INI,  '||Chr(13)||Chr(10)||
' TAR_EN_ESPERA, TAR_ALERTA, TAR_TAREA_FINALIZADA, TAR_EMISOR, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR,  '||Chr(13)||Chr(10)||
' USUARIOBORRAR, FECHABORRAR, BORRADO, PRC_ID, CMB_ID, SET_ID, TAR_FECHA_VENC, OBJ_ID, TAR_FECHA_VENC_REAL, DTYPE, NFA_TAR_REVISADA,  '||Chr(13)||Chr(10)||
' NFA_TAR_FECHA_REVIS_ALER, NFA_TAR_COMENTARIOS_ALERTA, DD_TRA_ID, CNT_ID, TAR_DESTINATARIO, TAR_TIPO_DESTINATARIO, TAR_ID_DEST, PER_ID,  '||Chr(13)||Chr(10)||
' RPR_REFERENCIA, TAR_TIPO_ENT_COD, TAR_DTYPE, TAR_SUBTIPO_COD, TAR_SUBTIPO_DESC, PLAZO, ENTIDADINFORMACION, CODENTIDAD, GESTOR,  '||Chr(13)||Chr(10)||
' TIPOSOLICITUDSQL, IDENTIDAD, FCREACIONENTIDAD, CODIGOSITUACION, IDTAREAASOCIADA, DESCRIPCIONTAREAASOCIADA, SUPERVISOR, DIASVENCIDOSQL,  '||Chr(13)||Chr(10)||
' DESCRIPCIONENTIDAD, SUBTIPOTARCODTAREA, FECHACREACIONENTIDADFORMATEADA, DESCRIPCIONEXPEDIENTE, DESCRIPCIONCONTRATO, IDENTIDADPERSONA,  '||Chr(13)||Chr(10)||
' VOLUMENRIESGOSQL, TIPOITINERARIOENTIDAD, PRORROGAFECHAPROPUESTA, PRORROGACAUSADESCRIPCION, CODIGOCONTRATO, CONTRATO) '||Chr(13)||Chr(10)||
'AS '||Chr(13)||Chr(10)||


'  SELECT '||Chr(13)||Chr(10)||
'    CASE ein.dd_ein_codigo '||Chr(13)||Chr(10)||
'      WHEN ''61'' --Activo '||Chr(13)||Chr(10)||
'        THEN nvl(tac.usu_id,v.usu_pendientes) '||Chr(13)||Chr(10)||
'-- THEN USU.usu_nombre '||Chr(13)||Chr(10)||
'      ELSE NULL '||Chr(13)||Chr(10)||
'    END usu_pendientes , '||Chr(13)||Chr(10)||
'    CASE '||Chr(13)||Chr(10)||
'      WHEN (NVL(tar.tar_en_espera,0) = 1) '||Chr(13)||Chr(10)||
'      THEN NVL(esp.usu_id,-1) '||Chr(13)||Chr(10)||
'      ELSE                -1 '||Chr(13)||Chr(10)||
'    END usu_espera '||Chr(13)||Chr(10)||
'    -- , CASE WHEN v.en_espera=1 THEN esp.usu_id ELSE 1 END usu_espera '||Chr(13)||Chr(10)||
'    , '||Chr(13)||Chr(10)||
'    v.usu_alerta, '||Chr(13)||Chr(10)||
'    v.dd_tge_id_pendiente , '||Chr(13)||Chr(10)||
'    -1 dd_tge_id_espera --DEPRECATED '||Chr(13)||Chr(10)||
'    , '||Chr(13)||Chr(10)||
'    v.dd_tge_id_alerta , '||Chr(13)||Chr(10)||
'    tar.tar_id, '||Chr(13)||Chr(10)||
'    tar.cli_id, '||Chr(13)||Chr(10)||
'    tar.exp_id, '||Chr(13)||Chr(10)||
'    tar.asu_id, '||Chr(13)||Chr(10)||
'    tar.tar_tar_id, '||Chr(13)||Chr(10)||
'    tar.spr_id, '||Chr(13)||Chr(10)||
'    tar.scx_id , '||Chr(13)||Chr(10)||
'    tar.dd_est_id, '||Chr(13)||Chr(10)||
'    tar.dd_ein_id, '||Chr(13)||Chr(10)||
'    tar.dd_sta_id, '||Chr(13)||Chr(10)||
'    tar.tar_codigo, '||Chr(13)||Chr(10)||
'    tar.tar_tarea , '||Chr(13)||Chr(10)||
'    CASE tar.dd_ein_id '||Chr(13)||Chr(10)||
'--      WHEN 5 '||Chr(13)||Chr(10)||
'--        THEN '||Chr(13)||Chr(10)||
'--          CASE '||Chr(13)||Chr(10)||
'--            WHEN tpo.dd_tpo_descripcion IS NOT NULL '||Chr(13)||Chr(10)||
'--              THEN asu.asu_nombre || ''-'' || tpo.dd_tpo_descripcion '||Chr(13)||Chr(10)||
'--            ELSE asu.asu_nombre '||Chr(13)||Chr(10)||
'--          END '||Chr(13)||Chr(10)||
'--      WHEN 3 '||Chr(13)||Chr(10)||
'--        THEN asu.asu_nombre '||Chr(13)||Chr(10)||
'--      WHEN 10 '||Chr(13)||Chr(10)||
'--        THEN tar.tar_descripcion '||Chr(13)||Chr(10)||
'      WHEN 61 '||Chr(13)||Chr(10)||
'		 THEN '||Chr(13)||Chr(10)||
'			CASE '||Chr(13)||Chr(10)||
'				WHEN tpo.dd_tpo_descripcion IS NOT NULL '||Chr(13)||Chr(10)||
'					THEN tpo.dd_tpo_descripcion '||Chr(13)||Chr(10)||
'				ELSE tar.tar_descripcion '||Chr(13)||Chr(10)||
'           END '||Chr(13)||Chr(10)||
'      ELSE tar.tar_descripcion '||Chr(13)||Chr(10)||
'    END tar_descripcion , '||Chr(13)||Chr(10)||
'    tar.tar_fecha_fin, '||Chr(13)||Chr(10)||
'    tar.tar_fecha_ini, '||Chr(13)||Chr(10)||
'    tar.tar_en_espera, '||Chr(13)||Chr(10)||
'    tar.tar_alerta, '||Chr(13)||Chr(10)||
'    tar.tar_tarea_finalizada, '||Chr(13)||Chr(10)||
'    tar.tar_emisor, '||Chr(13)||Chr(10)||
'    tar.VERSION, '||Chr(13)||Chr(10)||
'    tar.usuariocrear, '||Chr(13)||Chr(10)||
'    tar.fechacrear, '||Chr(13)||Chr(10)||
'    tar.usuariomodificar , '||Chr(13)||Chr(10)||
'    tar.fechamodificar, '||Chr(13)||Chr(10)||
'    tar.usuarioborrar, '||Chr(13)||Chr(10)||
'    tar.fechaborrar, '||Chr(13)||Chr(10)||
'    tar.borrado, '||Chr(13)||Chr(10)||
'    tar.prc_id, '||Chr(13)||Chr(10)||
'    tar.cmb_id, '||Chr(13)||Chr(10)||
'    tar.set_id, '||Chr(13)||Chr(10)||
'    tar.tar_fecha_venc, '||Chr(13)||Chr(10)||
'    tar.obj_id, '||Chr(13)||Chr(10)||
'    tar.tar_fecha_venc_real, '||Chr(13)||Chr(10)||
'    tar.dtype, '||Chr(13)||Chr(10)||
'    tar.nfa_tar_revisada , '||Chr(13)||Chr(10)||
'    tar.nfa_tar_fecha_revis_aler, '||Chr(13)||Chr(10)||
'    tar.nfa_tar_comentarios_alerta, '||Chr(13)||Chr(10)||
'    tar.dd_tra_id, '||Chr(13)||Chr(10)||
'    tar.cnt_id, '||Chr(13)||Chr(10)||
'    tar.tar_destinatario, '||Chr(13)||Chr(10)||
'    tar.tar_tipo_destinatario, '||Chr(13)||Chr(10)||
'    tar.tar_id_dest, '||Chr(13)||Chr(10)||
'    tar.per_id, '||Chr(13)||Chr(10)||
'    tar.rpr_referencia, '||Chr(13)||Chr(10)||
'    ein.dd_ein_codigo TAR_TIPO_ENT_COD , '||Chr(13)||Chr(10)||
'    tar.dtype tar_dtype, '||Chr(13)||Chr(10)||
'    STA.dd_sta_codigo TAR_SUBTIPO_COD, '||Chr(13)||Chr(10)||
'    sta.dd_sta_descripcion TAR_SUBTIPO_DESC, '||Chr(13)||Chr(10)||
'    '''' plazo -- TODO Sacar plazo para expediente y cliente '||Chr(13)||Chr(10)||
'    ,CASE ein.dd_ein_codigo '||Chr(13)||Chr(10)||
'--       WHEN ''3''  --Asunto '||Chr(13)||Chr(10)||
'--          THEN ein.dd_ein_descripcion || '' ['' || tar.asu_id || '']'' '||Chr(13)||Chr(10)||
'--       WHEN ''5''  --Procedimiento '||Chr(13)||Chr(10)||
'--          THEN ein.dd_ein_descripcion || '' ['' || tar.prc_id || '']'' '||Chr(13)||Chr(10)||
'--       WHEN ''2''  --Expediente '||Chr(13)||Chr(10)||
'--          THEN ein.dd_ein_descripcion || '' ['' || tar.exp_id || '']'' '||Chr(13)||Chr(10)||
'--       WHEN ''9''  --Persona '||Chr(13)||Chr(10)||
'--          THEN ein.dd_ein_descripcion || '' ['' || tar.per_id || '']'' '||Chr(13)||Chr(10)||
'--       WHEN ''10'' --Notificacion '||Chr(13)||Chr(10)||
'--          THEN ein.dd_ein_descripcion || '' ['' || tar.tar_id || '']'' '||Chr(13)||Chr(10)||
'       WHEN ''61'' --Activo '||Chr(13)||Chr(10)||
'          THEN ein.dd_ein_descripcion || '' ['' || tac.tar_id || '']'' '||Chr(13)||Chr(10)||
'        -- TODO poner para el resto de unidades de gestion '||Chr(13)||Chr(10)||
'      ELSE '''' '||Chr(13)||Chr(10)||
'    END entidadinformacion , '||Chr(13)||Chr(10)||
'    CASE ein.dd_ein_codigo '||Chr(13)||Chr(10)||
'--      WHEN ''3''  --Asunto '||Chr(13)||Chr(10)||
'--        THEN tar.asu_id '||Chr(13)||Chr(10)||
'--      WHEN ''5''  --Procedimiento '||Chr(13)||Chr(10)||
'--        THEN tar.prc_id '||Chr(13)||Chr(10)||
'--      WHEN ''2''  --Expediente '||Chr(13)||Chr(10)||
'--        THEN tar.exp_id '||Chr(13)||Chr(10)||
'--      WHEN ''9''  --Persona '||Chr(13)||Chr(10)||
'--        THEN tar.per_id '||Chr(13)||Chr(10)||
'--      WHEN ''10'' --Notificacion '||Chr(13)||Chr(10)||
'--        THEN tar.tar_id '||Chr(13)||Chr(10)||
'      WHEN ''61'' --Activo '||Chr(13)||Chr(10)||
'        THEN '||Chr(13)||Chr(10)||
'		 	CASE '||Chr(13)||Chr(10)||
'            	WHEN TO_NUMBER(IRG2.IRG_VALOR) IS NULL '||Chr(13)||Chr(10)||
'               	THEN ACT.ACT_NUM_ACTIVO '||Chr(13)||Chr(10)||
'				ELSE TO_NUMBER(IRG2.IRG_VALOR) '||Chr(13)||Chr(10)||
'		 END '||Chr(13)||Chr(10)||
'        -- TODO poner para el resto de unidades de gestion '||Chr(13)||Chr(10)||
'      ELSE -1 '||Chr(13)||Chr(10)||
'    END codentidad , '||Chr(13)||Chr(10)||
'    --CASE '||Chr(13)||Chr(10)||
'    --WHEN sta.dd_sta_id NOT IN (700, 701) '||Chr(13)||Chr(10)||
'    --  THEN '||Chr(13)||Chr(10)||
'    --      CASE ein.dd_ein_codigo '||Chr(13)||Chr(10)||
'--            WHEN ''3''  --Asunto '||Chr(13)||Chr(10)||
'--              THEN ges.apellido_nombre '||Chr(13)||Chr(10)||
'--            WHEN ''5''  --Procedimiento '||Chr(13)||Chr(10)||
'--              THEN ges.apellido_nombre '||Chr(13)||Chr(10)||
'--            WHEN ''2''  --Expediente '||Chr(13)||Chr(10)||
'--              THEN ges.apellido_nombre '||Chr(13)||Chr(10)||
'--            WHEN ''9''  --Persona '||Chr(13)||Chr(10)||
'--              THEN ges.apellido_nombre '||Chr(13)||Chr(10)||
'--            WHEN ''10'' --Notificacion '||Chr(13)||Chr(10)||
'--              THEN ges.apellido_nombre '||Chr(13)||Chr(10)||
'--            WHEN ''61'' --Notificacion '||Chr(13)||Chr(10)||
'--              THEN ges.apellido_nombre '||Chr(13)||Chr(10)||
'--              -- TODO poner para el resto de unidades de gestion '||Chr(13)||Chr(10)||
' --           ELSE NULL '||Chr(13)||Chr(10)||
'--          END '||Chr(13)||Chr(10)||
'--      ELSE NULL '||Chr(13)||Chr(10)||
' --   END gestor , '||Chr(13)||Chr(10)||
'	 ges.apellido_nombre gestor,'||Chr(13)||Chr(10)||
'    CASE '||Chr(13)||Chr(10)||
'--      WHEN sta.dd_sta_codigo IN (''5'', ''6'', ''54'', ''41'') '||Chr(13)||Chr(10)||
'--        THEN ''Prórroga'' '||Chr(13)||Chr(10)||
'--      WHEN sta.dd_sta_codigo IN (''17'') '||Chr(13)||Chr(10)||
'--        THEN ''Cancelación Expediente'' '||Chr(13)||Chr(10)||
'--      WHEN sta.dd_sta_codigo IN (''29'') '||Chr(13)||Chr(10)||
'--        THEN ''Expediente Manual'' '||Chr(13)||Chr(10)||
'--      WHEN sta.dd_sta_codigo IN (''16'', ''28'', ''24'', ''26'', ''27'', ''589'', ''590'', ''15'') '||Chr(13)||Chr(10)||
'--        THEN ''Comunicación'' '||Chr(13)||Chr(10)||
'      WHEN sta.dd_sta_codigo IN (''NTGPS'') '||Chr(13)||Chr(10)||
'        THEN ''Notificación automática'' '||Chr(13)||Chr(10)||
'      ELSE '''' '||Chr(13)||Chr(10)||
'    END tiposolicitudsql , '||Chr(13)||Chr(10)||
'    CASE ein.dd_ein_codigo '||Chr(13)||Chr(10)||
'--      WHEN ''3''  --Asunto '||Chr(13)||Chr(10)||
'--        THEN tar.asu_id '||Chr(13)||Chr(10)||
'--      WHEN ''5''  --Procedimiento '||Chr(13)||Chr(10)||
'--        THEN tar.prc_id '||Chr(13)||Chr(10)||
'--      WHEN ''2''  --Expediente '||Chr(13)||Chr(10)||
'--        THEN tar.EXP_ID '||Chr(13)||Chr(10)||
'--      WHEN ''9''  --Persona '||Chr(13)||Chr(10)||
'--        THEN tar.PER_ID '||Chr(13)||Chr(10)||
'--      WHEN ''10'' --Notificacion '||Chr(13)||Chr(10)||
'--        THEN tar.PRC_ID --Must be PRC_ID '||Chr(13)||Chr(10)||
'      WHEN ''61'' --Activo '||Chr(13)||Chr(10)||
'        THEN tac.ACT_ID '||Chr(13)||Chr(10)||
'        -- TODO poner para el resto de unidades de gestion '||Chr(13)||Chr(10)||
'      ELSE -1 '||Chr(13)||Chr(10)||
'    END identidad , '||Chr(13)||Chr(10)||
'    CASE ein.dd_ein_codigo '||Chr(13)||Chr(10)||
'--      WHEN ''3''  --Asunto '||Chr(13)||Chr(10)||
'--        THEN asu.fechacrear '||Chr(13)||Chr(10)||
'--      WHEN ''5''  --Procedimiento '||Chr(13)||Chr(10)||
'--        THEN prc.fechacrear '||Chr(13)||Chr(10)||
'--      WHEN ''2''  --Expediente '||Chr(13)||Chr(10)||
'--        THEN exp.fechacrear '||Chr(13)||Chr(10)||
'--      WHEN ''9''  --Persona '||Chr(13)||Chr(10)||
'--        THEN per.fechacrear '||Chr(13)||Chr(10)||
'--      WHEN ''10'' --Notificacion '||Chr(13)||Chr(10)||
'--        THEN per.fechacrear '||Chr(13)||Chr(10)||
'      WHEN ''61'' --Activo '||Chr(13)||Chr(10)||
'        THEN tac.fechacrear '||Chr(13)||Chr(10)||
'        -- TODO poner para el resto de unidades de gestion '||Chr(13)||Chr(10)||
'      ELSE NULL '||Chr(13)||Chr(10)||
'    END fcreacionentidad , '||Chr(13)||Chr(10)||
'    CASE ein.dd_ein_codigo '||Chr(13)||Chr(10)||
'--      WHEN ''3'' '||Chr(13)||Chr(10)||
'--      THEN est.dd_est_descripcion --asu.asu_situacion '||Chr(13)||Chr(10)||
'      WHEN ''61'' '||Chr(13)||Chr(10)||
'	      THEN '''' '||Chr(13)||Chr(10)||
'        -- TODO poner para el resto de unidades de gestion '||Chr(13)||Chr(10)||
'      ELSE '''' '||Chr(13)||Chr(10)||
'    END codigosituacion , '||Chr(13)||Chr(10)||
'    tar.tar_tar_id idtareaasociada, '||Chr(13)||Chr(10)||
'    asoc.tar_descripcion descripciontareaasociada , '||Chr(13)||Chr(10)||
'    CASE ein.dd_ein_codigo '||Chr(13)||Chr(10)||
'--      WHEN ''3''  --Asunto '||Chr(13)||Chr(10)||
'--        THEN sup.apellido_nombre '||Chr(13)||Chr(10)||
'--      WHEN ''5''  --Procedimiento '||Chr(13)||Chr(10)||
'--        THEN sup.apellido_nombre '||Chr(13)||Chr(10)||
'--      WHEN ''2''  --Expediente '||Chr(13)||Chr(10)||
'--        THEN sup.apellido_nombre '||Chr(13)||Chr(10)||
'--      WHEN ''9''  --Persona '||Chr(13)||Chr(10)||
'--        THEN sup.apellido_nombre '||Chr(13)||Chr(10)||
'--      WHEN ''10'' --Notificacion '||Chr(13)||Chr(10)||
'--        THEN sup.apellido_nombre '||Chr(13)||Chr(10)||
'      WHEN ''61'' --Activo '||Chr(13)||Chr(10)||
'        THEN sup.apellido_nombre '||Chr(13)||Chr(10)||
'        -- TODO poner para el resto de unidades de gestion '||Chr(13)||Chr(10)||
'      ELSE NULL '||Chr(13)||Chr(10)||
'    END supervisor , '||Chr(13)||Chr(10)||
'--    CASE '||Chr(13)||Chr(10)||
'--      WHEN TRUNC (tar.tar_fecha_venc) >= TRUNC(sysdate) '||Chr(13)||Chr(10)||
'--        THEN NULL '||Chr(13)||Chr(10)||
'--      ELSE EXTRACT (DAY FROM (SYSTIMESTAMP - (TRUNC (tar.tar_fecha_venc)))) '||Chr(13)||Chr(10)||
'--    END diasvencidosql , '||Chr(13)||Chr(10)||
'	 EXTRACT (DAY FROM ((TRUNC (tar.tar_fecha_venc)) - SYSTIMESTAMP)) diasvencidosql, '||Chr(13)||Chr(10)||
'    CASE ein.dd_ein_codigo '||Chr(13)||Chr(10)||
'--      WHEN ''3''  --Asunto '||Chr(13)||Chr(10)||
'--        THEN asu.asu_nombre '||Chr(13)||Chr(10)||
'--      WHEN ''5''  --Procedimiento '||Chr(13)||Chr(10)||
'--        THEN '||Chr(13)||Chr(10)||
'--          CASE '||Chr(13)||Chr(10)||
'--            WHEN tpo.dd_tpo_descripcion IS NOT NULL '||Chr(13)||Chr(10)||
'--              THEN asu.asu_nombre || ''-'' || tpo.dd_tpo_descripcion '||Chr(13)||Chr(10)||
'--            ELSE asu.asu_nombre '||Chr(13)||Chr(10)||
'--          END '||Chr(13)||Chr(10)||
'--      WHEN ''2''  --Expediente '||Chr(13)||Chr(10)||
'--        THEN EXP.EXP_DESCRIPCION '||Chr(13)||Chr(10)||
'--      WHEN ''9''  --Persona '||Chr(13)||Chr(10)||
'--        THEN PER.PER_NOM50 '||Chr(13)||Chr(10)||
'--      WHEN ''4''  --Tarea '||Chr(13)||Chr(10)||
'--        THEN tar.tar_descripcion '||Chr(13)||Chr(10)||
'--      WHEN ''10'' --Notificacion '||Chr(13)||Chr(10)||
'--        THEN tar.tar_descripcion '||Chr(13)||Chr(10)||
'      WHEN ''61'' --Activo '||Chr(13)||Chr(10)||
'        THEN nvl(tpo.dd_tpo_descripcion,''--'') '||Chr(13)||Chr(10)||
'        -- TODO poner para el resto de unidades de gestion '||Chr(13)||Chr(10)||
'      ELSE ''--'' '||Chr(13)||Chr(10)||
'    END descripcionentidad , '||Chr(13)||Chr(10)||
'    sta.dd_sta_codigo subtipotarcodtarea, '||Chr(13)||Chr(10)||
'    CASE ein.dd_ein_codigo '||Chr(13)||Chr(10)||
'--      WHEN ''3''  --Asunto '||Chr(13)||Chr(10)||
'--        THEN TO_CHAR (asu.fechacrear, ''dd/mm/yyyy'') '||Chr(13)||Chr(10)||
'--      WHEN ''5''  --Procedimiento '||Chr(13)||Chr(10)||
'--        THEN TO_CHAR (prc.fechacrear, ''dd/mm/yyyy'') '||Chr(13)||Chr(10)||
'--      WHEN ''2''  --Expediente '||Chr(13)||Chr(10)||
'--        THEN TO_CHAR (exp.fechacrear, ''dd/mm/yyyy'') '||Chr(13)||Chr(10)||
'--      WHEN ''9''  --Persona '||Chr(13)||Chr(10)||
'--        THEN TO_CHAR (per.fechacrear, ''dd/mm/yyyy'') '||Chr(13)||Chr(10)||
'--      WHEN ''10'' --Notificacion '||Chr(13)||Chr(10)||
'--        THEN TO_CHAR (tar.fechacrear, ''dd/mm/yyyy'') '||Chr(13)||Chr(10)||
'      WHEN ''61'' --Activo '||Chr(13)||Chr(10)||
'        THEN TO_CHAR (tac.fechacrear, ''dd/mm/yyyy'') '||Chr(13)||Chr(10)||
'        -- TODO poner para el resto de unidades de gestion '||Chr(13)||Chr(10)||
'      ELSE NULL '||Chr(13)||Chr(10)||
'    END fechacreacionentidadformateada , '||Chr(13)||Chr(10)||
'    NULL descripcionexpediente -- TODO poner para expediente '||Chr(13)||Chr(10)||
'    , '||Chr(13)||Chr(10)||
'    NULL descripcioncontrato -- TODO poner para contrato '||Chr(13)||Chr(10)||
'    , '||Chr(13)||Chr(10)||
'    NULL identidadpersona -- TODO poner para objetivo y para cliente '||Chr(13)||Chr(10)||
'    ,CASE ein.dd_ein_codigo '||Chr(13)||Chr(10)||
'--      WHEN ''5'' '||Chr(13)||Chr(10)||
'--        THEN NVL (vre_prc.vre, 0) --vre_via_prc '||Chr(13)||Chr(10)||
'          -- TODO poner para el resto de unidades de gestion '||Chr(13)||Chr(10)||
'      WHEN ''61'' '||Chr(13)||Chr(10)||
'        THEN 0 '||Chr(13)||Chr(10)||
'      ELSE 0 '||Chr(13)||Chr(10)||
'    END volumenriesgosql , '||Chr(13)||Chr(10)||
'    NULL tipoitinerarioentidad -- TODO sacar para cliente y expediente '||Chr(13)||Chr(10)||
'    , '||Chr(13)||Chr(10)||
'    NULL prorrogafechapropuesta -- TODO calcular la fecha prorroga propuesta '||Chr(13)||Chr(10)||
'    , '||Chr(13)||Chr(10)||
'    NULL prorrogacausadescripcion -- TODO calcular la causa de la prorroga '||Chr(13)||Chr(10)||
'    , '||Chr(13)||Chr(10)||
'    NULL codigocontrato -- TODO poner para contrato '||Chr(13)||Chr(10)||
'    , '||Chr(13)||Chr(10)||
'    tac.tra_id contrato '||Chr(13)||Chr(10)||
'--    NULL contrato -- TODO calcular '||Chr(13)||Chr(10)||
'  FROM '||Chr(13)||Chr(10)||
'    ( '||Chr(13)||Chr(10)||
'--      SELECT * FROM '||V_ESQUEMA||'.VTAR_TAREA_VS_USUARIO_PART1 '||Chr(13)||Chr(10)||
'--        UNION '||Chr(13)||Chr(10)||
'      SELECT * FROM '||V_ESQUEMA||'.VTAR_TAREA_VS_USUARIO_PART2 '||Chr(13)||Chr(10)||
'		 UNION ALL '||Chr(13)||Chr(10)||
'	   SELECT * FROM '||V_ESQUEMA||'.VTAR_TAREA_VS_USUARIO_PART3 '||Chr(13)||Chr(10)||
'    ) V '||Chr(13)||Chr(10)||
'  JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON V.TAR_ID = TAR.TAR_ID '||Chr(13)||Chr(10)||
'  LEFT JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAR.TAR_ID = TAC.TAR_ID '||Chr(13)||Chr(10)||
'  JOIN '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION EIN ON TAR.DD_EIN_ID = EIN.DD_EIN_ID '||Chr(13)||Chr(10)||
'  JOIN '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE STA ON TAR.DD_STA_ID = STA.DD_STA_ID '||Chr(13)||Chr(10)||
'--  LEFT JOIN '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON TAR.PRC_ID = PRC.PRC_ID AND PRC.BORRADO = 0 '||Chr(13)||Chr(10)||
'--  LEFT JOIN '||V_ESQUEMA||'.ASU_ASUNTOS ASU ON TAR.ASU_ID = ASU.ASU_ID AND ASU.BORRADO = 0 '||Chr(13)||Chr(10)||
'--  LEFT JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON PRC.DD_TPO_ID = TPO.DD_TPO_ID '||Chr(13)||Chr(10)||
'  LEFT JOIN '||V_ESQUEMA||'.VTAR_NOMBRES_USUARIOS GES ON V.USU_PENDIENTES = GES.USU_ID '||Chr(13)||Chr(10)||
'  LEFT JOIN '||V_ESQUEMA||'.VTAR_NOMBRES_USUARIOS SUP ON V.USU_SUPERVISOR = SUP.USU_ID '||Chr(13)||Chr(10)||
'  LEFT JOIN '||V_ESQUEMA||'.VTAR_NOMBRES_USUARIOS ESP ON TAR.TAR_EMISOR = ESP.APELLIDO_NOMBRE '||Chr(13)||Chr(10)||
'--  LEFT JOIN '||V_ESQUEMA||'.EXP_EXPEDIENTES EXP ON TAR.EXP_ID = EXP.EXP_ID '||Chr(13)||Chr(10)||
'--  LEFT JOIN '||V_ESQUEMA||'.PER_PERSONAS PER ON TAR.PER_ID = PER.PER_ID '||Chr(13)||Chr(10)||
'--  LEFT JOIN '||V_ESQUEMA_M||'.DD_EST_ESTADOS_ITINERARIOS EST ON TAR.DD_EST_ID = EST.DD_EST_ID '||Chr(13)||Chr(10)||
'  LEFT JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES ASOC ON TAR.TAR_TAR_ID = ASOC.TAR_ID and (tar.borrado = 0 and tar.tar_fecha_fin is null) '||Chr(13)||Chr(10)||
'  LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON TAC.ACT_ID = ACT.ACT_ID '||Chr(13)||Chr(10)||
'  LEFT JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE ATT ON TAC.TRA_ID = ATT.TRA_ID '||Chr(13)||Chr(10)||
'  LEFT JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON ATT.DD_TPO_ID = TPO.DD_TPO_ID '||Chr(13)||Chr(10)||
'--  LEFT JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_ID = TAC.USU_ID '||Chr(13)||Chr(10)||
'--  LEFT JOIN '||V_ESQUEMA||'.VTAR_TAR_VRE_VIA_PRC VRE_PRC ON TAR.TAR_ID = VRE_PRC.TAR_ID '||Chr(13)||Chr(10)||
'  LEFT JOIN '||V_ESQUEMA||'.MEJ_IRG_INFO_REGISTRO IRG ON IRG.IRG_VALOR = TAR.TAR_ID AND IRG.IRG_CLAVE = ''ID_NOTIF'' '||Chr(13)||Chr(10)||
'  LEFT JOIN '||V_ESQUEMA||'.MEJ_IRG_INFO_REGISTRO IRG2 ON IRG2.REG_ID = IRG.REG_ID AND IRG2.IRG_CLAVE = ''NUM_AGR''
');

--/* Recompilar nueva vista
--************************************************************/
execute immediate ('alter view '||V_ESQUEMA||'.'||V_VIEWNAME||' compile');


COMMIT;

DBMS_OUTPUT.PUT_LINE('OK modificada');

DBMS_OUTPUT.PUT_LINE('[FIN]');



EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificada');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT