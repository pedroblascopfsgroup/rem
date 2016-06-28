
--/*
--##########################################
--## AUTOR=Óscar Dorado
--## FECHA_CREACION=20160622
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=RECOVERY-120
--## PRODUCTO=SI
--## Finalidad: DDL la vista de tareas pendientes de procuradores
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

    V_NOMBRE_VISTA VARCHAR2(30 CHAR):= 'vtar_tarea_vs_procuradores';

BEGIN

    V_MSQL := 'CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||' (usu_pendientes,
                                                                tar_id,
                                                                asu_id,
                                                                tar_tarea,
                                                                tar_descripcion,
                                                                prc_id,
                                                                tar_fecha_venc,
                                                                res_descripcion,
                                                                estado_proces_codigo,
                                                                res_id,
                                                                tipo_res_id,
                                                                categ_id,
                                                                cat_id,
                                                                usu_espera,
                                                                usu_alerta,
                                                                dd_tge_id_pendiente,
                                                                dd_tge_id_espera,
                                                                dd_tge_id_alerta,
                                                                cli_id,
                                                                exp_id,
                                                                tar_tar_id,
                                                                spr_id,
                                                                scx_id,
                                                                dd_est_id,
                                                                dd_ein_id,
                                                                dd_sta_id,
                                                                tar_codigo,
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
                                                                cmb_id,
                                                                set_id,
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
                                                                contrato,
                                                                tipo_accion_codigo,
                                                                procedimiento_descripcion,
                                                                grouptareas,
                                                                zon_cod,
                                                                pef_id
                                                               )
AS
   SELECT vtar.usu_pendientes, vtar.tar_id, vtar.asu_id, vtar.tar_tarea, vtar.tar_descripcion, vtar.prc_id, vtar.tar_fecha_venc, tr.dd_tr_descripcion, estf.dd_epf_codigo, res.res_id, res.res_tre_id,
          cat.ctg_id, NVL (rrc.cat_id, relcat.cat_id), vtar.usu_espera, vtar.usu_alerta, vtar.dd_tge_id_pendiente, vtar.dd_tge_id_espera, vtar.dd_tge_id_alerta, vtar.cli_id, vtar.exp_id,
          vtar.tar_tar_id, vtar.spr_id, vtar.scx_id, vtar.dd_est_id, vtar.dd_ein_id, vtar.dd_sta_id, vtar.tar_codigo, vtar.tar_fecha_fin, vtar.tar_fecha_ini, vtar.tar_en_espera, vtar.tar_alerta,
          vtar.tar_tarea_finalizada, vtar.tar_emisor, vtar.VERSION, vtar.usuariocrear, vtar.fechacrear, vtar.usuariomodificar, vtar.fechamodificar, vtar.usuarioborrar, vtar.fechaborrar, vtar.borrado,
          vtar.cmb_id, vtar.set_id, vtar.obj_id, vtar.tar_fecha_venc_real, vtar.dtype, vtar.nfa_tar_revisada, vtar.nfa_tar_fecha_revis_aler, vtar.nfa_tar_comentarios_alerta, vtar.dd_tra_id,
          vtar.cnt_id, vtar.tar_destinatario, vtar.tar_tipo_destinatario, vtar.tar_id_dest, vtar.per_id, vtar.rpr_referencia, vtar.tar_tipo_ent_cod, vtar.tar_dtype, vtar.tar_subtipo_cod,
          vtar.tar_subtipo_desc, vtar.plazo, vtar.entidadinformacion, vtar.codentidad, vtar.gestor, vtar.tiposolicitudsql, vtar.identidad, vtar.fcreacionentidad, vtar.codigosituacion,
          vtar.idtareaasociada, vtar.descripciontareaasociada, vtar.supervisor, vtar.diasvencidosql, vtar.descripcionentidad, vtar.subtipotarcodtarea, vtar.fechacreacionentidadformateada,
          vtar.descripcionexpediente, vtar.descripcioncontrato, vtar.identidadpersona, vtar.volumenriesgosql, vtar.tipoitinerarioentidad, vtar.prorrogafechapropuesta, vtar.prorrogacausadescripcion,
          vtar.codigocontrato, vtar.contrato, tpa.bpm_dd_tac_codigo, tpo.dd_tpo_descripcion_larga,
          (SELECT CASE
                     WHEN vtar.tar_fecha_venc < SYSTIMESTAMP
                        THEN ''0''
                     WHEN EXTRACT (DAY FROM (vtar.tar_fecha_venc)) = EXTRACT (DAY FROM (SYSTIMESTAMP))
                        THEN ''1''
                     WHEN vtar.tar_fecha_venc <= (TRUNC (SYSDATE, ''iw'') + 6)
                        THEN ''2''
                     WHEN vtar.tar_fecha_venc <= LAST_DAY (SYSTIMESTAMP)
                        THEN ''3''
                     ELSE ''4''
                  END
             FROM DUAL),
          vtar.zon_cod zon_cod, vtar.pef_id pef_id
     FROM '||V_ESQUEMA||'.vtar_tarea_vs_usuario vtar JOIN '||V_ESQUEMA||'.res_resoluciones_masivo res ON res.res_tar_id = vtar.tar_id AND res.borrado = 0
          JOIN '||V_ESQUEMA||'.dd_tr_tipos_resolucion tr ON tr.dd_tr_id = res.res_tre_id
          JOIN '||V_ESQUEMA||'.bpm_dd_tac_tipo_accion tpa ON tpa.bpm_dd_tac_id = tr.bpm_dd_tac_id
          JOIN '||V_ESQUEMA||'.dd_epf_estado_proces_fich estf ON estf.dd_epf_id = res.res_epf_id
          LEFT JOIN '||V_ESQUEMA||'.rel_categorias_tiporesol relctr ON relctr.tr_id = tr.dd_tr_id
          LEFT JOIN '||V_ESQUEMA||'.rel_categorias relcat ON relcat.rel_id = relctr.rel_id
          LEFT JOIN '||V_ESQUEMA||'.rec_res_cat rrc ON rrc.res_id = res.res_id
          LEFT JOIN '||V_ESQUEMA||'.cat_categorias cat ON (cat.cat_id = relcat.cat_id OR cat.cat_id = rrc.cat_id)
          LEFT JOIN '||V_ESQUEMA||'.prc_procedimientos prc ON prc.prc_id = vtar.prc_id
          LEFT JOIN '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento tpo ON tpo.dd_tpo_id = prc.dd_tpo_id
    WHERE ((res.res_epf_id = 2) OR (tr.dd_tr_id = 1003 AND res.res_epf_id = 6))';

 EXECUTE IMMEDIATE V_MSQL;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NOMBRE_VISTA||' Creada o reemplazada');

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
