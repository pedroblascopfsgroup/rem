--
-- NOTA:
-- Este script solicita el parámetro master_schema. 
-- Si se ejecuta mediante Toad, lanzar con F5 
--
--

-- Optimizacion de la vista de la busqueda

DROP VIEW V42_BUSQUEDA_TAREAS;

/* Formatted on 2013/07/24 13:39 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW v42_busqueda_tareas (tar_id,
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
                                                   usupendiente
                                                  )
AS
   SELECT DISTINCT tar_id, asu_nombre, dd_tpo_descripcion, nombre_cliente, exp_descripcion, est_id, pef_id_gestor, pef_id_supervisor, CAST (MAX (usugestor) AS NUMBER (16)),
                   CAST (MAX (ususupervisor) AS NUMBER (16)), asu_id, tar_id_dest, tar_emisor, tipo_anotacion, flag_envio_correo, usu_id, dtype
              FROM (SELECT tar.tar_id, asu.asu_nombre, tpo.dd_tpo_descripcion,
                           CASE
                              WHEN per.per_apellido1 IS NULL AND per.per_apellido2 IS NULL
                                 THEN per.per_nombre
                              WHEN per.per_apellido2 IS NULL
                                 THEN per.per_apellido1 || ', ' || per.per_nombre
                              WHEN per.per_apellido1 IS NULL
                                 THEN per.per_apellido2 || ', ' || per.per_nombre
                              ELSE per.per_apellido1 || ' ' || per.per_apellido2 || ', ' || per.per_nombre
                           END nombre_cliente,
                           expe.exp_descripcion, est_id, pef_id_gestor, est.pef_id_supervisor, DECODE (gaa.dd_tge_id, 2, usd.usu_id) usugestor, DECODE (gaa.dd_tge_id, 3, usd.usu_id) ususupervisor,
                           asu.asu_id, tar.tar_id_dest, tar.tar_emisor, tipo_anotacion, CASE
                              WHEN flag_envio_correo = 1
                                 THEN 'true'
                              ELSE 'false'
                           END flag_envio_correo, tarusu.usu_id
                      FROM tar_tareas_notificaciones tar LEFT JOIN v_tarea_tipoanotacion anot ON TO_CHAR (tar.tar_id) = anot.tar_id
                           LEFT JOIN asu_asuntos asu ON tar.asu_id = asu.asu_id
                           LEFT JOIN cli_clientes cli ON tar.cli_id = cli.cli_id
                           LEFT JOIN &&master_schema..dd_est_estados_itinerarios estiti ON cli.dd_est_id = estiti.dd_est_id
                           LEFT JOIN est_estados est ON estiti.dd_est_id = est.dd_est_id
                           LEFT JOIN prc_procedimientos prc ON tar.prc_id = prc.prc_id
                           LEFT JOIN dd_tpo_tipo_procedimiento tpo ON prc.dd_tpo_id = tpo.dd_tpo_id
                           LEFT JOIN per_personas per ON cli.per_id = per.per_id
                           LEFT JOIN exp_expedientes expe ON tar.exp_id = expe.exp_id
                           LEFT JOIN v_tarea_usupendiente tarusu ON tar.tar_id = tarusu.tar_id
                           LEFT JOIN gaa_gestor_adicional_asunto gaa ON asu.asu_id = gaa.asu_id
                           LEFT JOIN usd_usuarios_despachos usd ON gaa.usd_id = usd.usd_id
                           )
          GROUP BY tar_id,
                   asu_nombre,
                   dd_tpo_descripcion,
                   nombre_cliente,
                   exp_descripcion,
                   est_id,
                   pef_id_gestor,
                   pef_id_supervisor,
                   asu_id,
                   tar_id_dest,
                   tar_emisor,
                   tipo_anotacion,
                   flag_envio_correo,
                   usu_id

