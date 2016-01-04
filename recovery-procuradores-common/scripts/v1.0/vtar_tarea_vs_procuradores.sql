DROP VIEW VTAR_TAREA_VS_PROCURADORES;

/* Formatted on 2015/02/04 18:40 (Formatter Plus v4.8.8) */
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

