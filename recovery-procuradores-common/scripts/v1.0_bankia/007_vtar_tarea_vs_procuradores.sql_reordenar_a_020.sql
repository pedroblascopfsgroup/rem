DROP VIEW BANK01.VTAR_TAREA_VS_PROCURADORES;

/* Formatted on 2015/05/20 16:49 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW bank01.vtar_tarea_vs_procuradores (usu_pendientes,
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
                                                                grouptareas
                                                               )
AS
   SELECT vtar.usu_pendientes, vtar.tar_id, vtar.asu_id, vtar.tar_tarea, vtar.tar_descripcion, vtar.prc_id,
          vtar.tar_fecha_venc, tr.dd_tr_descripcion, estf.dd_epf_codigo, res.res_id, res.res_tre_id, cat.ctg_id,
          NVL (rrc.cat_id, relcat.cat_id), vtar.usu_espera, vtar.usu_alerta, vtar.dd_tge_id_pendiente,
          vtar.dd_tge_id_espera, vtar.dd_tge_id_alerta, vtar.cli_id, vtar.exp_id, vtar.tar_tar_id, vtar.spr_id,
          vtar.scx_id, vtar.dd_est_id, vtar.dd_ein_id, vtar.dd_sta_id, vtar.tar_codigo, vtar.tar_fecha_fin,
          vtar.tar_fecha_ini, vtar.tar_en_espera, vtar.tar_alerta, vtar.tar_tarea_finalizada, vtar.tar_emisor,
          vtar.VERSION, vtar.usuariocrear, vtar.fechacrear, vtar.usuariomodificar, vtar.fechamodificar,
          vtar.usuarioborrar, vtar.fechaborrar, vtar.borrado, vtar.cmb_id, vtar.set_id, vtar.obj_id,
          vtar.tar_fecha_venc_real, vtar.dtype, vtar.nfa_tar_revisada, vtar.nfa_tar_fecha_revis_aler,
          vtar.nfa_tar_comentarios_alerta, vtar.dd_tra_id, vtar.cnt_id, vtar.tar_destinatario,
          vtar.tar_tipo_destinatario, vtar.tar_id_dest, vtar.per_id, vtar.rpr_referencia, vtar.tar_tipo_ent_cod,
          vtar.tar_dtype, vtar.tar_subtipo_cod, vtar.tar_subtipo_desc, vtar.plazo, vtar.entidadinformacion,
          vtar.codentidad, vtar.gestor, vtar.tiposolicitudsql, vtar.identidad, vtar.fcreacionentidad,
          vtar.codigosituacion, vtar.idtareaasociada, vtar.descripciontareaasociada, vtar.supervisor,
          vtar.diasvencidosql, vtar.descripcionentidad, vtar.subtipotarcodtarea,
          vtar.fechacreacionentidadformateada, vtar.descripcionexpediente, vtar.descripcioncontrato,
          vtar.identidadpersona, vtar.volumenriesgosql, vtar.tipoitinerarioentidad, vtar.prorrogafechapropuesta,
          vtar.prorrogacausadescripcion, vtar.codigocontrato, vtar.contrato,
          (SELECT CASE
                     WHEN vtar.tar_fecha_venc < SYSTIMESTAMP
                        THEN '0'                                           /* Fecha menor a la de hoy => Vencida */
                     WHEN EXTRACT (DAY FROM (vtar.tar_fecha_venc)) = EXTRACT (DAY FROM (SYSTIMESTAMP))
                        THEN '1'                                         /* Fecha igual a la de hoy => vence hoy */
                     WHEN vtar.tar_fecha_venc <= (TRUNC (SYSDATE, 'iw') + 6)
                        THEN '2'                                       /* Fecha menor o igual al proximo domingo */
                     WHEN vtar.tar_fecha_venc <= LAST_DAY (SYSTIMESTAMP)
                        THEN '3'
                     /* Fecha menor o igual al ultimo dia del mes */
                  ELSE '4'
                  END
             FROM DUAL)
     FROM vtar_tarea_vs_usuario vtar JOIN res_resoluciones_masivo res
          ON res.res_tar_id = vtar.tar_id AND res.borrado = 0
          JOIN dd_tr_tipos_resolucion tr ON tr.dd_tr_id = res.res_tre_id
          JOIN dd_epf_estado_proces_fich estf ON estf.dd_epf_id = res.res_epf_id
          LEFT JOIN rel_categorias_tiporesol relctr ON relctr.tr_id = tr.dd_tr_id
          LEFT JOIN rel_categorias relcat ON relcat.rel_id = relctr.rel_id
          LEFT JOIN cat_categorias cat ON cat.cat_id = relcat.cat_id
          LEFT JOIN rec_res_cat rrc ON rrc.res_id = res.res_id
    WHERE ((res.res_epf_id = 2) OR (tr.dd_tr_id = 1003 AND res.res_epf_id = 6));


/* Formatted on 2015/03/31 13:37 (Formatter Plus v4.8.8) 
CREATE OR REPLACE FORCE VIEW bank01.vtar_tarea_vs_procuradores (usu_pendientes,
                                                                tar_id,
                                                                asu_id,
                                                                tar_tarea,
                                                                tar_descripcion,
                                                                prc_id,
                                                                tar_fecha_venc,
                                                                res_descripcion,
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
                                                                grouptareas
                                                               )
AS
   SELECT vtar.usu_pendientes, vtar.tar_id, vtar.asu_id, vtar.tar_tarea,
          vtar.tar_descripcion, vtar.prc_id, vtar.tar_fecha_venc,
          tr.dd_tr_descripcion, res.res_id, res.res_tre_id, cat.ctg_id ,NVL(rrc.cat_id,relcat.cat_id), vtar.usu_espera,
          vtar.usu_alerta, vtar.dd_tge_id_pendiente, vtar.dd_tge_id_espera,
          vtar.dd_tge_id_alerta, vtar.cli_id, vtar.exp_id, vtar.tar_tar_id,
          vtar.spr_id, vtar.scx_id, vtar.dd_est_id, vtar.dd_ein_id,
          vtar.dd_sta_id, vtar.tar_codigo, vtar.tar_fecha_fin,
          vtar.tar_fecha_ini, vtar.tar_en_espera, vtar.tar_alerta,
          vtar.tar_tarea_finalizada, vtar.tar_emisor, vtar.VERSION,
          vtar.usuariocrear, vtar.fechacrear, vtar.usuariomodificar,
          vtar.fechamodificar, vtar.usuarioborrar, vtar.fechaborrar,
          vtar.borrado, vtar.cmb_id, vtar.set_id, vtar.obj_id,
          vtar.tar_fecha_venc_real, vtar.dtype, vtar.nfa_tar_revisada,
          vtar.nfa_tar_fecha_revis_aler, vtar.nfa_tar_comentarios_alerta,
          vtar.dd_tra_id, vtar.cnt_id, vtar.tar_destinatario,
          vtar.tar_tipo_destinatario, vtar.tar_id_dest, vtar.per_id,
          vtar.rpr_referencia, vtar.tar_tipo_ent_cod, vtar.tar_dtype,
          vtar.tar_subtipo_cod, vtar.tar_subtipo_desc, vtar.plazo,
          vtar.entidadinformacion, vtar.codentidad, vtar.gestor,
          vtar.tiposolicitudsql, vtar.identidad, vtar.fcreacionentidad,
          vtar.codigosituacion, vtar.idtareaasociada,
          vtar.descripciontareaasociada, vtar.supervisor, vtar.diasvencidosql,
          vtar.descripcionentidad, vtar.subtipotarcodtarea,
          vtar.fechacreacionentidadformateada, vtar.descripcionexpediente,
          vtar.descripcioncontrato, vtar.identidadpersona,
          vtar.volumenriesgosql, vtar.tipoitinerarioentidad,
          vtar.prorrogafechapropuesta, vtar.prorrogacausadescripcion,
          vtar.codigocontrato, vtar.contrato,
          (SELECT CASE
                     WHEN vtar.tar_fecha_venc < SYSTIMESTAMP
                        THEN '0'      /* Fecha menor a la de hoy => Vencida */
                     WHEN EXTRACT (DAY FROM (vtar.tar_fecha_venc)) =
                                             EXTRACT (DAY FROM (SYSTIMESTAMP))
                        THEN '1'    /* Fecha igual a la de hoy => vence hoy */
                     WHEN vtar.tar_fecha_venc <=
                                         (NEXT_DAY (SYSTIMESTAMP, 'DOMINGO')
                                         )
                        THEN '2'  /* Fecha menor o igual al proximo domingo */
                     WHEN vtar.tar_fecha_venc <= LAST_DAY (SYSTIMESTAMP)
                        THEN '3'
                     /* Fecha menor o igual al ultimo dia del mes */
                  ELSE '4'
                  END
             FROM DUAL)
     FROM vtar_tarea_vs_usuario vtar 
          JOIN res_resoluciones_masivo res ON res.res_tar_id = vtar.tar_id
          JOIN dd_tr_tipos_resolucion tr ON tr.dd_tr_id = res.res_tre_id
          LEFT JOIN rel_categorias_tiporesol relctr ON relctr.tr_id = tr.dd_tr_id
          LEFT JOIN rel_categorias relcat ON relcat.rel_id = relctr.rel_id
          JOIN cat_categorias cat ON cat.cat_id = relcat.cat_id
          LEFT JOIN rec_res_cat rrc ON rrc.res_id = res.res_id
    WHERE ((res.res_epf_id = 2) OR (tr.dd_tr_id = 1003));
    
    */

/*
 * VISTA ANTIGUA
CREATE OR REPLACE FORCE VIEW vtar_tarea_vs_procuradores (usu_pendientes,
                                                                tar_id,
                                                                asu_id,
                                                                tar_tarea,
                                                                tar_descripcion,
                                                                prc_id,
                                                                tar_fecha_venc,
                                                                res_descripcion,
                                                                res_id,
                                                                cat_id
                                                               )
AS
   SELECT vtar.usu_pendientes, vtar.tar_id, vtar.asu_id, vtar.tar_tarea,
          vtar.tar_descripcion, vtar.prc_id, vtar.tar_fecha_venc,
          tr.dd_tr_descripcion, res.res_id, relcat.cat_id
     FROM vtar_tarea_vs_usuario vtar JOIN tex_tarea_externa tex
          ON tex.tar_id = vtar.tar_id
          JOIN res_resoluciones_masivo res ON tex.tex_id = res.res_tex_id
          JOIN dd_tr_tipos_resolucion tr ON tr.dd_tr_id = res.res_tre_id
          LEFT JOIN rel_categorias_tiporesol relctr ON relctr.tr_id = tr.dd_tr_id
          LEFT JOIN rel_categorias relcat ON relcat.rel_id = relctr.rel_id
    WHERE res.res_epf_id = 2;
*/
