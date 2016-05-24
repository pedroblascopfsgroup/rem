CREATE OR REPLACE FORCE VIEW haya01.v_msv_busqueda_asu_tram (id_,
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
                                                             prc_saldo_recuperacion,
                                                             prc_fecha_crear,
                                                             tar_tarea
                                                            )
AS
   (SELECT DISTINCT ROWNUM id_, asu.asu_id "ASU_ID", prc.prc_id "PRC_ID",
                    asu.asu_nombre "ASU_NOMBRE",
                    pla.dd_pla_descripcion "PLAZA",
                    juz.dd_juz_descripcion "JUZGADO",
                    prc.prc_cod_proc_en_juzgado "AUTO",
                    tpo.dd_tpo_descripcion "TIPO_PRC",
                    prc.prc_saldo_recuperacion "PRINCIPAL",
                    tex.tex_id "TEX_ID", epr.dd_epr_codigo "COD_ESTADO_PRC",
                    epr.dd_epr_descripcion "DES_ESTADO_PRC",
                    prc.prc_saldo_recuperacion, prc.fechacrear, tar.tar_tarea
               FROM asu_asuntos asu INNER JOIN prc_procedimientos prc
                    ON asu.asu_id = prc.asu_id AND prc.borrado = 0
                    LEFT JOIN dd_juz_juzgados_plaza juz
                    ON prc.dd_juz_id = juz.dd_juz_id
                  AND (juz.borrado = 0 OR juz.borrado IS NULL)
                    LEFT JOIN dd_pla_plazas pla
                    ON pla.dd_pla_id = juz.dd_pla_id
                  AND (pla.borrado = 0 OR pla.borrado IS NULL)
                    INNER JOIN dd_tj_tipo_juicio tj
                    ON prc.dd_tpo_id = tj.dd_tpo_id
                    INNER JOIN dd_tpo_tipo_procedimiento tpo
                    ON prc.dd_tpo_id = tpo.dd_tpo_id
                  AND (tpo.dd_tac_id = (SELECT dd_tac_id
                                          FROM dd_tac_tipo_actuacion tac
                                         WHERE tac.dd_tac_codigo = 'TR'))
                    INNER JOIN tar_tareas_notificaciones tar
                    ON prc.prc_id = tar.prc_id
                  AND (   tar.tar_tarea_finalizada = 0
                       OR tar.tar_tarea_finalizada IS NULL
                      )
                    INNER JOIN tex_tarea_externa tex ON tex.tar_id =
                                                                    tar.tar_id
                    INNER JOIN hayamaster.dd_epr_estado_procedimiento epr
                    ON prc.dd_epr_id = epr.dd_epr_id
              WHERE asu.borrado = 0 AND prc.prc_paralizado = 0);
              
              
              
              
              
              
CREATE OR REPLACE FORCE VIEW haya01.v_msv_busqueda_asu_proc (id_,
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
                                                             prc_saldo_recuperacion,
                                                             prc_fecha_crear,
                                                             tar_tarea
                                                            )
AS
   (SELECT DISTINCT ROWNUM id_, asu.asu_id "ASU_ID", prc.prc_id "PRC_ID",
                    asu.asu_nombre "ASU_NOMBRE",
                    pla.dd_pla_descripcion "PLAZA",
                    juz.dd_juz_descripcion "JUZGADO",
                    prc.prc_cod_proc_en_juzgado "AUTO",
                    tpo.dd_tpo_descripcion "TIPO_PRC",
                    prc.prc_saldo_recuperacion "PRINCIPAL",
                    tex.tex_id "TEX_ID", epr.dd_epr_codigo "COD_ESTADO_PRC",
                    epr.dd_epr_descripcion "DES_ESTADO_PRC",
                    prc.prc_saldo_recuperacion, prc.fechacrear, tar.tar_tarea
               FROM asu_asuntos asu INNER JOIN prc_procedimientos prc
                    ON asu.asu_id = prc.asu_id AND prc.borrado = 0
                    LEFT JOIN dd_juz_juzgados_plaza juz
                    ON prc.dd_juz_id = juz.dd_juz_id
                  AND (juz.borrado = 0 OR juz.borrado IS NULL)
                    LEFT JOIN dd_pla_plazas pla
                    ON pla.dd_pla_id = juz.dd_pla_id
                  AND (pla.borrado = 0 OR pla.borrado IS NULL)
                    INNER JOIN dd_tj_tipo_juicio tj
                    ON prc.dd_tpo_id = tj.dd_tpo_id
                    INNER JOIN dd_tpo_tipo_procedimiento tpo
                    ON prc.dd_tpo_id = tpo.dd_tpo_id
                  AND (tpo.dd_tac_id <> (SELECT dd_tac_id
                                           FROM dd_tac_tipo_actuacion tac
                                          WHERE tac.dd_tac_codigo = 'TR'))
                    LEFT JOIN tar_tareas_notificaciones tar
                    ON prc.prc_id = tar.prc_id
                  AND (   tar.tar_tarea_finalizada = 0
                       OR tar.tar_tarea_finalizada IS NULL
                      )
                    LEFT JOIN tex_tarea_externa tex
                    ON tex.tar_id = tar.tar_id AND tex.borrado = 0
                    INNER JOIN hayamaster.dd_epr_estado_procedimiento epr
                    ON prc.dd_epr_id = epr.dd_epr_id
              WHERE asu.borrado = 0);
              
              
              
              
CREATE OR REPLACE FORCE VIEW haya01.v_msv_busqueda_asuntos (id_,
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
                                                            prc_saldo_recuperacion,
                                                            prc_fecha_crear,
                                                            tar_tarea
                                                           )
AS
   (SELECT vproc."ID_", vproc."ASU_ID", vproc."PRC_ID", vproc."ASU_NOMBRE",
           vproc."PLAZA", vproc."JUZGADO", vproc."AUTO", vproc."TIPO_PRC",
           vproc."PRINCIPAL", vproc."TEX_ID", vproc."COD_ESTADO_PRC",
           vproc."DES_ESTADO_PRC", vproc."PRC_SALDO_RECUPERACION",
           vproc."PRC_FECHA_CREAR", vproc."TAR_TAREA"
      FROM v_msv_busqueda_asu_proc vproc
    UNION ALL
    SELECT vtram."ID_", vtram."ASU_ID", vtram."PRC_ID", vtram."ASU_NOMBRE",
           vtram."PLAZA", vtram."JUZGADO", vtram."AUTO", vtram."TIPO_PRC",
           vtram."PRINCIPAL", vtram."TEX_ID", vtram."COD_ESTADO_PRC",
           vtram."DES_ESTADO_PRC", vtram."PRC_SALDO_RECUPERACION",
           vtram."PRC_FECHA_CREAR", vtram."TAR_TAREA"
      FROM v_msv_busqueda_asu_tram vtram);
      
      
      
      
CREATE OR REPLACE FORCE VIEW haya01.v_msv_busqueda_asuntos_usuario (id_,
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
                                                                    prc_saldo_recuperacion,
                                                                    prc_fecha_crear,
                                                                    usu_id,
                                                                    tar_tarea
                                                                   )
AS
   SELECT DISTINCT asu."ID_", asu."ASU_ID", asu."PRC_ID", asu."ASU_NOMBRE",
                   asu."PLAZA", asu."JUZGADO", asu."AUTO", asu."TIPO_PRC",
                   asu."PRINCIPAL", asu."TEX_ID", asu."COD_ESTADO_PRC",
                   asu."DES_ESTADO_PRC", asu."PRC_SALDO_RECUPERACION",
                   asu."PRC_FECHA_CREAR", usu.usu_id, asu."TAR_TAREA"
              FROM v_msv_busqueda_asuntos asu LEFT JOIN vtar_asu_vs_usu usu
                   ON asu.asu_id = usu.asu_id
                   ;



