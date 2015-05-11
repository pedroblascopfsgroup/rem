--
-- NOTA:
-- Este script solicita el parámetro master_schema. 
-- Si se ejecuta mediante Toad, lanzar con F5 
-- Este script requiere de la útima versión de las vistas optimizadas del buzón de tareas con soporte a grupos de usuarios.
--
-- COMPROBACIONES
-- 1. Comprobar que existe la columna: vtar_asu_vs_usu.usu_id_original
--

-- Se crea una vista materializada con indices, con la informaci�n de uno de los joins de la vista principal 
-- de b�squeda

DROP MATERIALIZED VIEW V_TAREA_USUPENDIENTE;

CREATE MATERIALIZED VIEW V_TAREA_USUPENDIENTE
    BUILD IMMEDIATE
    REFRESH COMPLETE
    START WITH sysdate
    NEXT sysdate+1
    WITH PRIMARY KEY
    AS 
    /* Formatted on 2013/07/24 13:10 (Formatter Plus v4.8.8) */
    SELECT distinct pendientes.tar_id, asu_pendientes.usu_id_original usu_id
      FROM tar_tareas_notificaciones pendientes LEFT JOIN &&master_schema..dd_sta_subtipo_tarea_base sta ON pendientes.dd_sta_id = sta.dd_sta_id
       LEFT JOIN vtar_asu_vs_usu asu_pendientes ON pendientes.asu_id = asu_pendientes.asu_id AND sta.dd_tge_id = asu_pendientes.dd_tge_id
     WHERE pendientes.dd_ein_id IN (3, 5) AND pendientes.borrado = 0 AND (pendientes.tar_tarea_finalizada IS NULL OR pendientes.tar_tarea_finalizada = 0);


CREATE UNIQUE INDEX IDX_TAREA_USUPENDIENTE_1 ON V_TAREA_USUPENDIENTE (TAR_ID);

CREATE INDEX IDX_TAREA_USUPENDIENTE_2 ON V_TAREA_USUPENDIENTE (USU_ID);