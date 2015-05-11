DROP VIEW LIN001.V_MSV_BUSQUEDA_ASUNTOS;

/* Formatted on 2013/07/12 19:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW lin001.v_msv_busqueda_asuntos (id_,
                                                            asu_id,
                                                            prc_id,
                                                            asu_nombre,
                                                            plaza,
                                                            juzgado,
                                                            AUTO,
                                                            tipo_prc,
                                                            principal,
                                                            tex_id,
                                                            cod_estado_prc,
                                                            des_estado_prc
                                                           )
AS (SELECT DISTINCT ROWNUM id_, asu.asu_id "ASU_ID", prc.prc_id "PRC_ID",
                asu.asu_nombre "ASU_NOMBRE", pla.dd_pla_descripcion "PLAZA",
                juz.dd_juz_descripcion "JUZGADO",
                prc.prc_cod_proc_en_juzgado "AUTO",
                tpo.dd_tpo_descripcion "TIPO_PRC",
                prc.prc_saldo_recuperacion "PRINCIPAL", tex.tex_id "TEX_ID",
                epr.DD_EPR_CODIGO "COD_ESTADO_PRC", epr.DD_EPR_DESCRIPCION "DES_ESTADO_PRC"
           FROM asu_asuntos asu INNER JOIN prc_procedimientos prc
                ON asu.asu_id = prc.asu_id
                LEFT JOIN dd_juz_juzgados_plaza juz
                ON prc.dd_juz_id = juz.dd_juz_id
                LEFT JOIN dd_pla_plazas pla ON pla.dd_pla_id = juz.dd_pla_id
                INNER JOIN dd_tj_tipo_juicio tj ON prc.dd_tpo_id =
                                                                  tj.dd_tpo_id
                INNER JOIN dd_tpo_tipo_procedimiento tpo
                ON prc.dd_tpo_id = tpo.dd_tpo_id
                INNER JOIN tar_tareas_notificaciones tar
                ON prc.prc_id = tar.prc_id
                INNER JOIN tex_tarea_externa tex ON tex.tar_id = tar.tar_id
                INNER JOIN linmaster.dd_epr_estado_procedimiento epr 
                ON prc.dd_epr_id = epr.DD_EPR_ID
          WHERE asu.borrado = 0
            AND asu.dd_eas_id = (SELECT dd_eas_id
                                   FROM linmaster.dd_eas_estado_asuntos
                                  WHERE dd_eas_codigo = '03')
            AND prc.borrado = 0
            AND prc.dd_epr_id NOT IN
                   ((SELECT dd_epr_id
                       FROM linmaster.dd_epr_estado_procedimiento
                      WHERE dd_epr_codigo = '04'),
                    (SELECT dd_epr_id
                       FROM linmaster.dd_epr_estado_procedimiento
                      WHERE dd_epr_codigo = '05')
                   )
            AND (juz.borrado = 0 OR juz.borrado IS NULL)
            AND (pla.borrado = 0 OR pla.borrado IS NULL)
            AND (   tar.tar_tarea_finalizada = 0
                 OR tar.tar_tarea_finalizada IS NULL
                ));
                
                
DROP VIEW LIN001.V_MSV_BUSQUEDA_ASUNTOS_USUARIO;

/* Formatted on 2013/07/12 19:36 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW lin001.v_msv_busqueda_asuntos_usuario (id_,
                                                                    asu_id,
                                                                    prc_id,
                                                                    asu_nombre,
                                                                    plaza,
                                                                    juzgado,
                                                                    AUTO,
                                                                    tipo_prc,                                                                    
                                                                    principal,
                                                                    tex_id,
                                                                    cod_estado_prc,
                                                                    des_estado_prc,
                                                                    usu_id                                                                    
                                                                   )
AS
   SELECT DISTINCT asu.*, usu.usu_id
              FROM v_msv_busqueda_asuntos asu LEFT JOIN vtar_asu_vs_usu usu
                   ON asu.asu_id = usu.asu_id;                