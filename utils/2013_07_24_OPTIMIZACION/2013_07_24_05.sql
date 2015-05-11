-- Se indican los tipos de registros de las tablas materializadas creadas en la optimización

ALTER MATERIALIZED VIEW V_TAREA_TIPOANOTACION  REFRESH START WITH TO_DATE('01-09-2006 11:00:00','MM-dd-yyyy hh24:mi:ss') NEXT sysdate+1 COMPLETE;

ALTER MATERIALIZED VIEW V_TAREA_USUPENDIENTE  REFRESH START WITH TO_DATE('01-09-2006 11:00:00','MM-dd-yyyy hh24:mi:ss') NEXT sysdate+1 COMPLETE;