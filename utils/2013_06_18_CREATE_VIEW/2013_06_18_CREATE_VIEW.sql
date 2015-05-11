DROP VIEW UGAS001.V42_BUSQUEDA_TAREAS;

/* Formatted on 2013/06/17 18:46 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW ugas001.v42_busqueda_tareas (tar_id,
                                                          tarea,
                                                          asudesc,
                                                          tipoprcdesc,
                                                          nombrecliente,
                                                          descexpediente,
                                                          estado,
                                                          gestorperfil,
                                                          supervisorperfil,
                                                          usugestor,
                                                          ususupervisor,
                                                          asunto,
                                                          usuariodestinotarea,
                                                          usuarioorigentarea,
                                                          tipoanotacion,
                                                          flagenviocorreo,
                                                          usupendiente,
                                                          dtype
                                                         )
AS
   SELECT DISTINCT tar.tar_id, tar.tar_id, asu.asu_nombre, tpo.dd_tpo_descripcion,
                   CASE
                      WHEN per.per_apellido1 IS NULL AND per.per_apellido2 IS NULL
                         THEN per.per_nombre
                      WHEN per.per_apellido2 IS NULL
                         THEN per.per_apellido1 || ', ' || per.per_nombre
                      WHEN per.per_apellido1 IS NULL
                         THEN per.per_apellido2 || ', ' || per.per_nombre
                      ELSE per.per_apellido1 || ' ' || per.per_apellido2 || ', ' || per.per_nombre
                   END nombre_cliente,
                   expe.exp_descripcion, est.est_id, est.pef_id_gestor, est.pef_id_supervisor, gest.usu_id, sup.usu_id, asu.asu_id, tar.tar_id_dest, tar.tar_emisor, tipo_anotacion,
                   CASE
                      WHEN flag_envio_correo = 1
                         THEN 'true'
                      ELSE 'false'
                   END flag_envio_correo, v.usu_pendientes, 'BTATareaEncontrada' AS dtype
              FROM tar_tareas_notificaciones tar
                   LEFT JOIN
                   (SELECT   tar_id, MAX (flag) flag_envio_correo, MAX (tipo) tipo_anotacion
                        FROM (SELECT DISTINCT ireg1.irg_valor AS tar_id, DECODE (ireg2.irg_clave, 'FLAG_MAIL_TAREA', ireg2.irg_valor) flag,
                                              DECODE (ireg2.irg_clave, 'TIPO_ANO_TAREA', ireg2.irg_valor) tipo, ireg2.irg_valor AS tipo_anotacion, ireg2.irg_clave AS clave
                                         FROM mej_irg_info_registro ireg1 JOIN mej_reg_registro reg1 ON ireg1.reg_id = reg1.reg_id
                                              JOIN mej_dd_trg_tipo_registro tipo1 ON reg1.dd_trg_id = tipo1.dd_trg_id
                                              JOIN mej_reg_registro reg2 ON reg1.reg_id = reg2.reg_id
                                              JOIN mej_irg_info_registro ireg2 ON reg2.reg_id = ireg2.reg_id
                                              JOIN mej_dd_trg_tipo_registro tipo2 ON reg2.dd_trg_id = tipo2.dd_trg_id
                                        WHERE (tipo1.dd_trg_codigo = 'ANO_TAREA' AND tipo2.dd_trg_codigo = 'ANO_TAREA' AND ireg1.irg_clave = 'ID_TAREA')
                                           OR (tipo1.dd_trg_codigo = 'ANO_NOTIFICACION' AND tipo2.dd_trg_codigo = 'ANO_NOTIFICACION' AND ireg1.irg_clave = 'ID_NOTIF'))
                       WHERE (clave = 'TIPO_ANO_TAREA' AND REGEXP_INSTR (tipo_anotacion, '[0-9]') = 0) OR clave = 'FLAG_MAIL_TAREA'
                    GROUP BY tar_id) taraux1 ON TO_CHAR (tar.tar_id) = taraux1.tar_id
                   LEFT JOIN asu_asuntos asu ON tar.asu_id = asu.asu_id
                   LEFT JOIN cli_clientes cli ON tar.cli_id = cli.cli_id
                   LEFT JOIN ugasmaster.dd_est_estados_itinerarios estiti ON cli.dd_est_id = estiti.dd_est_id
                   LEFT JOIN est_estados est ON estiti.dd_est_id = est.dd_est_id
                   LEFT JOIN vtar_asunto_gestor gest ON tar.asu_id = gest.asu_id
                   LEFT JOIN vtar_asunto_supervisor sup ON tar.asu_id = sup.asu_id
                   LEFT JOIN prc_procedimientos prc ON tar.prc_id = prc.prc_id
                   LEFT JOIN dd_tpo_tipo_procedimiento tpo ON prc.dd_tpo_id = tpo.dd_tpo_id
                   LEFT JOIN per_personas per ON cli.per_id = per.per_id
                   LEFT JOIN exp_expedientes expe ON tar.exp_id = expe.exp_id
                   LEFT JOIN vtar_tarea_vs_usuario v ON tar.tar_id = v.tar_id
                   ;

