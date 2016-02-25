--/*
--##########################################
--## AUTOR=JORGE MARTIN
--## FECHA_CREACION=20160118
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-585
--## PRODUCTO=SI
--##
--## Finalidad: Vista VTAR_TAREA_VS_PROCURADORES
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(6000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA02'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    table_count2 number(3);
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('******** VTAR_TAREA_VS_PROCURADORES ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.VTAR_TAREA_VS_PROCURADORES... Comprobaciones previas');
	

	-- Comprobamos si existe la vista
	V_MSQL := 'SELECT COUNT(1) FROM ALL_VIEWS WHERE VIEW_NAME = ''VTAR_TAREA_VS_PROCURADORES'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.VTAR_TAREA_VS_PROCURADORES... ya existe, se reemplazará');
		EXECUTE IMMEDIATE 'DROP VIEW VTAR_TAREA_VS_PROCURADORES';
		V_MSQL := 'CREATE OR REPLACE VIEW ' ||V_ESQUEMA||'.VTAR_TAREA_VS_PROCURADORES 
			("USU_PENDIENTES", "TAR_ID", "ASU_ID", "TAR_TAREA", "TAR_DESCRIPCION", "PRC_ID", "TAR_FECHA_VENC", "RES_DESCRIPCION", "ESTADO_PROCES_CODIGO", "RES_ID", "TIPO_RES_ID", "CATEG_ID", "CAT_ID", "USU_ESPERA", "USU_ALERTA", "DD_TGE_ID_PENDIENTE", "DD_TGE_ID_ESPERA", "DD_TGE_ID_ALERTA", "CLI_ID", "EXP_ID", "TAR_TAR_ID", "SPR_ID", "SCX_ID", "DD_EST_ID", "DD_EIN_ID", "DD_STA_ID", "TAR_CODIGO", "TAR_FECHA_FIN", "TAR_FECHA_INI", "TAR_EN_ESPERA", "TAR_ALERTA", "TAR_TAREA_FINALIZADA", "TAR_EMISOR", "VERSION", "USUARIOCREAR", "FECHACREAR", "USUARIOMODIFICAR", "FECHAMODIFICAR", "USUARIOBORRAR", "FECHABORRAR", "BORRADO", "CMB_ID", "SET_ID", "OBJ_ID", "TAR_FECHA_VENC_REAL", "DTYPE", "NFA_TAR_REVISADA", "NFA_TAR_FECHA_REVIS_ALER", "NFA_TAR_COMENTARIOS_ALERTA", "DD_TRA_ID", "CNT_ID", "TAR_DESTINATARIO", "TAR_TIPO_DESTINATARIO", "TAR_ID_DEST", "PER_ID", "RPR_REFERENCIA", "TAR_TIPO_ENT_COD", "TAR_DTYPE", "TAR_SUBTIPO_COD", "TAR_SUBTIPO_DESC", "PLAZO", "ENTIDADINFORMACION", "CODENTIDAD", "GESTOR", "TIPOSOLICITUDSQL", "IDENTIDAD", "FCREACIONENTIDAD", "CODIGOSITUACION", "IDTAREAASOCIADA", "DESCRIPCIONTAREAASOCIADA", "SUPERVISOR", "DIASVENCIDOSQL", "DESCRIPCIONENTIDAD", "SUBTIPOTARCODTAREA", "FECHACREACIONENTIDADFORMATEADA", "DESCRIPCIONEXPEDIENTE", "DESCRIPCIONCONTRATO", "IDENTIDADPERSONA", "VOLUMENRIESGOSQL", "TIPOITINERARIOENTIDAD", "PRORROGAFECHAPROPUESTA", "PRORROGACAUSADESCRIPCION", "CODIGOCONTRATO", "CONTRATO", "TIPO_ACCION_CODIGO", "PROCEDIMIENTO_DESCRIPCION", "GROUPTAREAS", zon_cod, pef_id) AS 
	            SELECT vtar.usu_pendientes, vtar.tar_id, vtar.asu_id, vtar.tar_tarea,
	          vtar.tar_descripcion, vtar.prc_id, vtar.tar_fecha_venc,
	          tr.dd_tr_descripcion, estf.dd_epf_codigo, res.res_id,
	          res.res_tre_id, cat.ctg_id, NVL (rrc.cat_id, relcat.cat_id),
	          vtar.usu_espera, vtar.usu_alerta, vtar.dd_tge_id_pendiente,
	          vtar.dd_tge_id_espera, vtar.dd_tge_id_alerta, vtar.cli_id,
	          vtar.exp_id, vtar.tar_tar_id, vtar.spr_id, vtar.scx_id,
	          vtar.dd_est_id, vtar.dd_ein_id, vtar.dd_sta_id, vtar.tar_codigo,
	          vtar.tar_fecha_fin, vtar.tar_fecha_ini, vtar.tar_en_espera,
	          vtar.tar_alerta, vtar.tar_tarea_finalizada, vtar.tar_emisor,
	          vtar.VERSION, vtar.usuariocrear, vtar.fechacrear,
	          vtar.usuariomodificar, vtar.fechamodificar, vtar.usuarioborrar,
	          vtar.fechaborrar, vtar.borrado, vtar.cmb_id, vtar.set_id,
	          vtar.obj_id, vtar.tar_fecha_venc_real, vtar.dtype,
	          vtar.nfa_tar_revisada, vtar.nfa_tar_fecha_revis_aler,
	          vtar.nfa_tar_comentarios_alerta, vtar.dd_tra_id, vtar.cnt_id,
	          vtar.tar_destinatario, vtar.tar_tipo_destinatario, vtar.tar_id_dest,
	          vtar.per_id, vtar.rpr_referencia, vtar.tar_tipo_ent_cod,
	          vtar.tar_dtype, vtar.tar_subtipo_cod, vtar.tar_subtipo_desc,
	          vtar.plazo, vtar.entidadinformacion, vtar.codentidad, vtar.gestor,
	          vtar.tiposolicitudsql, vtar.identidad, vtar.fcreacionentidad,
	          vtar.codigosituacion, vtar.idtareaasociada,
	          vtar.descripciontareaasociada, vtar.supervisor, vtar.diasvencidosql,
	          vtar.descripcionentidad, vtar.subtipotarcodtarea,
	          vtar.fechacreacionentidadformateada, vtar.descripcionexpediente,
	          vtar.descripcioncontrato, vtar.identidadpersona,
	          vtar.volumenriesgosql, vtar.tipoitinerarioentidad,
	          vtar.prorrogafechapropuesta, vtar.prorrogacausadescripcion,
	          vtar.codigocontrato, vtar.contrato, tpa.bpm_dd_tac_codigo, tpo.dd_tpo_descripcion_larga,
	          (SELECT CASE
	                     WHEN vtar.tar_fecha_venc < SYSTIMESTAMP
	                        THEN ''0''
	                     WHEN EXTRACT (DAY FROM (vtar.tar_fecha_venc)) =
	                                             EXTRACT (DAY FROM (SYSTIMESTAMP))
	                        THEN ''1''
	                     WHEN vtar.tar_fecha_venc <= (TRUNC (SYSDATE, ''iw'') + 6)
	                        THEN ''2''
	                     WHEN vtar.tar_fecha_venc <= LAST_DAY (SYSTIMESTAMP)
	                        THEN ''3''
	                     ELSE ''4''
	                  END
	             FROM DUAL),
	          vtar.ZON_COD zon_cod,
	          vtar.PEF_ID pef_id
	     FROM vtar_tarea_vs_usuario vtar JOIN res_resoluciones_masivo res
	          ON res.res_tar_id = vtar.tar_id AND res.borrado = 0
	          JOIN dd_tr_tipos_resolucion tr ON tr.dd_tr_id = res.res_tre_id
	          JOIN bpm_dd_tac_tipo_accion tpa ON tpa.bpm_dd_tac_id =
	                                                              tr.bpm_dd_tac_id
	          JOIN dd_epf_estado_proces_fich estf ON estf.dd_epf_id =
	                                                                res.res_epf_id
	          LEFT JOIN rel_categorias_tiporesol relctr ON relctr.tr_id =
	                                                                   tr.dd_tr_id
	          LEFT JOIN rel_categorias relcat ON relcat.rel_id = relctr.rel_id
	          LEFT JOIN cat_categorias cat ON cat.cat_id = relcat.cat_id
	          LEFT JOIN rec_res_cat rrc ON rrc.res_id = res.res_id
	          LEFT JOIN prc_procedimientos prc ON prc.prc_id = vtar.prc_id
	          LEFT JOIN dd_tpo_tipo_procedimiento tpo ON tpo.dd_tpo_id = prc.dd_tpo_id
	    WHERE (   (res.res_epf_id = 2)
	           OR (tr.dd_tr_id = 1003 AND res.res_epf_id = 6)
	          )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.VTAR_TAREA_VS_PROCURADORES... Creando vista');
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.VTAR_TAREA_VS_PROCURADORES... OK');
			
		ELSE
			V_MSQL := 'CREATE OR REPLACE VIEW ' ||V_ESQUEMA||'.VTAR_TAREA_VS_PROCURADORES 
			("USU_PENDIENTES", "TAR_ID", "ASU_ID", "TAR_TAREA", "TAR_DESCRIPCION", "PRC_ID", "TAR_FECHA_VENC", "RES_DESCRIPCION", "ESTADO_PROCES_CODIGO", "RES_ID", "TIPO_RES_ID", "CATEG_ID", "CAT_ID", "USU_ESPERA", "USU_ALERTA", "DD_TGE_ID_PENDIENTE", "DD_TGE_ID_ESPERA", "DD_TGE_ID_ALERTA", "CLI_ID", "EXP_ID", "TAR_TAR_ID", "SPR_ID", "SCX_ID", "DD_EST_ID", "DD_EIN_ID", "DD_STA_ID", "TAR_CODIGO", "TAR_FECHA_FIN", "TAR_FECHA_INI", "TAR_EN_ESPERA", "TAR_ALERTA", "TAR_TAREA_FINALIZADA", "TAR_EMISOR", "VERSION", "USUARIOCREAR", "FECHACREAR", "USUARIOMODIFICAR", "FECHAMODIFICAR", "USUARIOBORRAR", "FECHABORRAR", "BORRADO", "CMB_ID", "SET_ID", "OBJ_ID", "TAR_FECHA_VENC_REAL", "DTYPE", "NFA_TAR_REVISADA", "NFA_TAR_FECHA_REVIS_ALER", "NFA_TAR_COMENTARIOS_ALERTA", "DD_TRA_ID", "CNT_ID", "TAR_DESTINATARIO", "TAR_TIPO_DESTINATARIO", "TAR_ID_DEST", "PER_ID", "RPR_REFERENCIA", "TAR_TIPO_ENT_COD", "TAR_DTYPE", "TAR_SUBTIPO_COD", "TAR_SUBTIPO_DESC", "PLAZO", "ENTIDADINFORMACION", "CODENTIDAD", "GESTOR", "TIPOSOLICITUDSQL", "IDENTIDAD", "FCREACIONENTIDAD", "CODIGOSITUACION", "IDTAREAASOCIADA", "DESCRIPCIONTAREAASOCIADA", "SUPERVISOR", "DIASVENCIDOSQL", "DESCRIPCIONENTIDAD", "SUBTIPOTARCODTAREA", "FECHACREACIONENTIDADFORMATEADA", "DESCRIPCIONEXPEDIENTE", "DESCRIPCIONCONTRATO", "IDENTIDADPERSONA", "VOLUMENRIESGOSQL", "TIPOITINERARIOENTIDAD", "PRORROGAFECHAPROPUESTA", "PRORROGACAUSADESCRIPCION", "CODIGOCONTRATO", "CONTRATO", "TIPO_ACCION_CODIGO", "PROCEDIMIENTO_DESCRIPCION", "GROUPTAREAS", zon_cod, pef_id) AS 
	            SELECT vtar.usu_pendientes, vtar.tar_id, vtar.asu_id, vtar.tar_tarea,
	          vtar.tar_descripcion, vtar.prc_id, vtar.tar_fecha_venc,
	          tr.dd_tr_descripcion, estf.dd_epf_codigo, res.res_id,
	          res.res_tre_id, cat.ctg_id, NVL (rrc.cat_id, relcat.cat_id),
	          vtar.usu_espera, vtar.usu_alerta, vtar.dd_tge_id_pendiente,
	          vtar.dd_tge_id_espera, vtar.dd_tge_id_alerta, vtar.cli_id,
	          vtar.exp_id, vtar.tar_tar_id, vtar.spr_id, vtar.scx_id,
	          vtar.dd_est_id, vtar.dd_ein_id, vtar.dd_sta_id, vtar.tar_codigo,
	          vtar.tar_fecha_fin, vtar.tar_fecha_ini, vtar.tar_en_espera,
	          vtar.tar_alerta, vtar.tar_tarea_finalizada, vtar.tar_emisor,
	          vtar.VERSION, vtar.usuariocrear, vtar.fechacrear,
	          vtar.usuariomodificar, vtar.fechamodificar, vtar.usuarioborrar,
	          vtar.fechaborrar, vtar.borrado, vtar.cmb_id, vtar.set_id,
	          vtar.obj_id, vtar.tar_fecha_venc_real, vtar.dtype,
	          vtar.nfa_tar_revisada, vtar.nfa_tar_fecha_revis_aler,
	          vtar.nfa_tar_comentarios_alerta, vtar.dd_tra_id, vtar.cnt_id,
	          vtar.tar_destinatario, vtar.tar_tipo_destinatario, vtar.tar_id_dest,
	          vtar.per_id, vtar.rpr_referencia, vtar.tar_tipo_ent_cod,
	          vtar.tar_dtype, vtar.tar_subtipo_cod, vtar.tar_subtipo_desc,
	          vtar.plazo, vtar.entidadinformacion, vtar.codentidad, vtar.gestor,
	          vtar.tiposolicitudsql, vtar.identidad, vtar.fcreacionentidad,
	          vtar.codigosituacion, vtar.idtareaasociada,
	          vtar.descripciontareaasociada, vtar.supervisor, vtar.diasvencidosql,
	          vtar.descripcionentidad, vtar.subtipotarcodtarea,
	          vtar.fechacreacionentidadformateada, vtar.descripcionexpediente,
	          vtar.descripcioncontrato, vtar.identidadpersona,
	          vtar.volumenriesgosql, vtar.tipoitinerarioentidad,
	          vtar.prorrogafechapropuesta, vtar.prorrogacausadescripcion,
	          vtar.codigocontrato, vtar.contrato, tpa.bpm_dd_tac_codigo, tpo.dd_tpo_descripcion_larga,
	          (SELECT CASE
	                     WHEN vtar.tar_fecha_venc < SYSTIMESTAMP
	                        THEN ''0''
	                     WHEN EXTRACT (DAY FROM (vtar.tar_fecha_venc)) =
	                                             EXTRACT (DAY FROM (SYSTIMESTAMP))
	                        THEN ''1''
	                     WHEN vtar.tar_fecha_venc <= (TRUNC (SYSDATE, ''iw'') + 6)
	                        THEN ''2''
	                     WHEN vtar.tar_fecha_venc <= LAST_DAY (SYSTIMESTAMP)
	                        THEN ''3''
	                     ELSE ''4''
	                  END
	             FROM DUAL),
	          vtar.ZON_COD zon_cod,
	          vtar.PEF_ID pef_id
	     FROM vtar_tarea_vs_usuario vtar JOIN res_resoluciones_masivo res
	          ON res.res_tar_id = vtar.tar_id AND res.borrado = 0
	          JOIN dd_tr_tipos_resolucion tr ON tr.dd_tr_id = res.res_tre_id
	          JOIN bpm_dd_tac_tipo_accion tpa ON tpa.bpm_dd_tac_id =
	                                                              tr.bpm_dd_tac_id
	          JOIN dd_epf_estado_proces_fich estf ON estf.dd_epf_id =
	                                                                res.res_epf_id
	          LEFT JOIN rel_categorias_tiporesol relctr ON relctr.tr_id =
	                                                                   tr.dd_tr_id
	          LEFT JOIN rel_categorias relcat ON relcat.rel_id = relctr.rel_id
	          LEFT JOIN cat_categorias cat ON cat.cat_id = relcat.cat_id
	          LEFT JOIN rec_res_cat rrc ON rrc.res_id = res.res_id
	          LEFT JOIN prc_procedimientos prc ON prc.prc_id = vtar.prc_id
	          LEFT JOIN dd_tpo_tipo_procedimiento tpo ON tpo.dd_tpo_id = prc.dd_tpo_id
	    WHERE (   (res.res_epf_id = 2)
	           OR (tr.dd_tr_id = 1003 AND res.res_epf_id = 6)
	          )';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.VTAR_TAREA_VS_PROCURADORES... Creando vista');
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.VTAR_TAREA_VS_PROCURADORES... OK');
	END IF;

	COMMIT;
	
EXCEPTION


	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		ROLLBACK;
		RAISE;
END;
/

EXIT;