-- Se crea una vista materializada con indices, con la información de uno de los joins de la vista principal 
-- de búsqueda

DROP MATERIALIZED VIEW UGAS001.V_TAREA_USUPENDIENTE;
CREATE MATERIALIZED VIEW UGAS001.V_TAREA_USUPENDIENTE 
TABLESPACE UGAS001
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 2013/07/24 13:10 (Formatter Plus v4.8.8) */
SELECT pendientes.tar_id, asu_pendientes.usu_id
  FROM tar_tareas_notificaciones pendientes LEFT JOIN ugasmaster.dd_sta_subtipo_tarea_base sta ON pendientes.dd_sta_id = sta.dd_sta_id
       LEFT JOIN vtar_asu_vs_usu asu_pendientes ON pendientes.asu_id = asu_pendientes.asu_id AND sta.dd_tge_id = asu_pendientes.dd_tge_id
 WHERE pendientes.dd_ein_id IN (3, 5) AND pendientes.borrado = 0 AND (pendientes.tar_tarea_finalizada IS NULL OR pendientes.tar_tarea_finalizada = 0);

COMMENT ON MATERIALIZED VIEW UGAS001.V_TAREA_USUPENDIENTE IS 'snapshot table for snapshot UGAS001.V44';

CREATE UNIQUE INDEX UGAS001.IDX_TAREA_USUPENDIENTE_1 ON UGAS001.V_TAREA_USUPENDIENTE
(TAR_ID)
LOGGING
TABLESPACE UGAS001
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX UGAS001.IDX_TAREA_USUPENDIENTE_2 ON UGAS001.V_TAREA_USUPENDIENTE
(USU_ID)
LOGGING
TABLESPACE UGAS001
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;
